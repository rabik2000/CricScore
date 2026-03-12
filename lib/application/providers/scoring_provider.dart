import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/scoring_engine.dart';
import '../services/scoring_state.dart';
import '../services/undo_manager.dart';
import '../services/match_lifecycle.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/ball_event.dart';
import '../../domain/repositories/interfaces.dart';
import '../../data/repositories/local_repositories.dart';

final ballRepositoryProvider = Provider<BallRepository>((ref) {
  return LocalBallRepository();
});

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return LocalMatchRepository();
});

final matchesProvider = StreamProvider<List<Match>>((ref) {
  return ref.watch(matchRepositoryProvider).watchLiveMatches();
});

final matchSummaryProvider = StreamProvider.family<ScoringState?, Match>((ref, match) {
  final ballRepository = ref.watch(ballRepositoryProvider);
  return ballRepository.watchBallEvents(match.id, null).map((events) {
    return ScoringEngine.reconstructState(
      matchId: match.id,
      teamAName: match.teamAId,
      teamBName: match.teamBId,
      events: events,
    );
  });
});

/// Deletes a match by id and refreshes the matches list.
Future<void> deleteMatch(WidgetRef ref, String matchId) async {
  await ref.read(matchRepositoryProvider).deleteMatch(matchId);
  ref.invalidate(matchesProvider);
}

class ScoringNotifier extends StateNotifier<AsyncValue<ScoringState>> {
  final BallRepository _ballRepository;
  final MatchRepository _matchRepository;
  
  ScoringNotifier(this._ballRepository, this._matchRepository) : super(const AsyncValue.loading());

  Future<void> init(ScoringState initialState) async {
    state = AsyncValue.data(initialState);

    // Create the initial match entity in the repository
    final match = Match(
      id: initialState.matchId,
      teamAId: initialState.teamAName,
      teamBId: initialState.teamBName,
      oversLimit: 20, // Default for now
      status: MatchStatus.live,
      createdAt: DateTime.now(),
    );
    await _matchRepository.createMatch(match);
  }

  Future<void> recordBall({
    required int runsFromBat,
    required int extraRuns,
    String? extraType,
    bool wicket = false,
    String? dismissalType,
    String? dismissedPlayerId,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    // Validation: Ensure a bowler name is present
    if (currentState.bowlerId.trim().isEmpty) {
      return;
    }

    final event = ScoringEngine.createBallEvent(
      currentState: currentState,
      runsFromBat: runsFromBat,
      extraRuns: extraRuns,
      extraType: extraType,
      wicket: wicket,
      dismissalType: dismissalType,
      dismissedPlayerId: dismissedPlayerId,
    );

    // Update local state and push to history
    final nextState = ScoringEngine.nextState(currentState, event);
    final history = UndoManager.addToHistory(currentState);

    state = AsyncValue.data(nextState.copyWith(
      history: history,
      lastBallId: event.id,
    ));

    // Persist to repository
    await _ballRepository.recordBall(event);

    // Automatic innings finish if 10 wickets lost OR last man is out
    if (MatchLifecycleManager.shouldAutoFinishInnings(nextState, wicket)) {
      await finishInnings();
    } else if (nextState.isMatchComplete) {
       // Target chased down — persist completed status
       final match = await _matchRepository.getMatch(nextState.matchId);
       if (match != null && match.status != MatchStatus.completed) {
         await _matchRepository.updateMatch(match.copyWith(status: MatchStatus.completed));
       }
    }
  }

  Future<void> undo() async {
    final currentState = state.value;
    if (currentState == null) return;

    final restoredState = await UndoManager.undo(currentState, _ballRepository);
    if (restoredState != null) {
      state = AsyncValue.data(restoredState);
    }
  }

  void updatePlayerName(String oldName, String newName) {
    final currentState = state.value;
    if (currentState == null) return;
    
    var nextState = currentState;
    if (currentState.strikerId == oldName) {
      nextState = nextState.copyWith(strikerId: newName);
    } else if (currentState.nonStrikerId == oldName) {
      nextState = nextState.copyWith(nonStrikerId: newName);
    }
    
    state = AsyncValue.data(nextState);
  }

  void updateBowlerName(String newName) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final previousBowlers = List<String>.from(currentState.previousBowlers);
    if (!previousBowlers.contains(newName)) {
      previousBowlers.add(newName);
    }
    
    state = AsyncValue.data(currentState.copyWith(
      bowlerId: newName,
      previousBowlers: previousBowlers,
    ));
  }

  void renameBowler(String oldName, String newName) {
    final currentState = state.value;
    if (currentState == null) return;

    var nextState = currentState;
    
    // Update current bowler display name
    if (currentState.bowlerId == oldName) {
      nextState = nextState.copyWith(bowlerId: newName);
    }

    // Update last bowler display name
    if (currentState.lastBowlerId == oldName) {
      nextState = nextState.copyWith(lastBowlerId: newName);
    }

    // Update previous bowlers list
    final previousBowlers = List<String>.from(currentState.previousBowlers);
    final index = previousBowlers.indexOf(oldName);
    if (index != -1) {
      previousBowlers[index] = newName;
    } else if (!previousBowlers.contains(newName)) {
      previousBowlers.add(newName);
    }

    // Update the registry: transfer the stable index from oldName to newName
    final registry = Map<String, int>.from(currentState.bowlerNameToIndex);
    if (registry.containsKey(oldName)) {
      final stableIndex = registry.remove(oldName)!;
      registry[newName] = stableIndex;
    }
    // Stats maps (bowlerLegalBalls, bowlerRuns, etc.) are keyed by int index,
    // so they remain untouched — no fragile key renaming needed!

    state = AsyncValue.data(nextState.copyWith(
      previousBowlers: previousBowlers,
      bowlerNameToIndex: registry,
    ));
  }


  
  Future<void> finishInnings() async {
    final currentState = state.value;
    if (currentState == null || currentState.isMatchComplete) return;

    final nextState = await MatchLifecycleManager.finishInnings(
      currentState,
      _matchRepository,
    );
    state = AsyncValue.data(nextState);
  }

  void switchBatsmen() {
    final currentState = state.value;
    if (currentState == null || currentState.isLastManMode) return;

    // Allow switching if no balls have been bowled OR if the last ball was a wicket
    if ((currentState.totalLegalBalls == 0 && currentState.currentOverBalls.isEmpty) || currentState.lastBallWicket) {
      state = AsyncValue.data(currentState.copyWith(
        strikerId: currentState.nonStrikerId,
        strikerRuns: currentState.nonStrikerRuns,
        strikerBalls: currentState.nonStrikerBalls,
        nonStrikerId: currentState.strikerId,
        nonStrikerRuns: currentState.strikerRuns,
        nonStrikerBalls: currentState.strikerBalls,
      ));
    }
  }

  void toggleLastManMode() {
    final currentState = state.value;
    if (currentState == null) return;

    if (!currentState.isLastManMode && currentState.canEnableLastMan) {
      // When Last Man is enabled, the surviving batsman (non-striker) 
      // becomes the striker to finish the game alone.
      state = AsyncValue.data(currentState.copyWith(
        isLastManMode: true,
        canEnableLastMan: false,
        strikerId: currentState.nonStrikerId,
        strikerRuns: currentState.nonStrikerRuns,
        strikerBalls: currentState.nonStrikerBalls,
        nonStrikerId: 'SOLO', 
        nonStrikerRuns: 0,
        nonStrikerBalls: 0,
      ));
    }
  }

  void toggleBattingTeam() {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncValue.data(currentState.copyWith(isTeamABatting: !currentState.isTeamABatting));
  }

  Future<void> saveSession() async {
    final currentState = state.value;
    if (currentState == null) return;

    final match = await _matchRepository.getMatch(currentState.matchId);
    if (match != null) {
      await _matchRepository.updateMatch(match.copyWith(
        status: currentState.isMatchComplete ? MatchStatus.completed : MatchStatus.live,
      ));
    }
  }

  Future<void> resumeMatch(Match match, String teamAName, String teamBName) async {
    state = const AsyncValue.loading();
    
    // Fetch ALL events for this match across all innings
    final eventsStream = _ballRepository.watchBallEvents(match.id, null);
    final events = await eventsStream.first;

    final currentState = ScoringEngine.reconstructState(
      matchId: match.id,
      teamAName: teamAName,
      teamBName: teamBName,
      events: events,
    );

    // Reconstruct history for undo capability
    final history = <ScoringState>[];
    var tempState = ScoringState(
      matchId: match.id,
      inningsId: 'innings1',
      teamAName: teamAName,
      teamBName: teamBName,
      strikerId: 'Batsman 1',
      nonStrikerId: 'Batsman 2',
      bowlerId: 'Bowler 1',
      totalRuns: 0,
      totalWickets: 0,
      legalBallsThisOver: 0,
      totalLegalBalls: 0,
      currentOverBalls: [],
      previousBowlers: [],
      isTeamABatting: true,
    );

    final sortedEvents = List<BallEvent>.from(events)..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (final event in sortedEvents) {
      if (event.inningsId != tempState.inningsId && tempState.isFirstInnings && event.inningsId == 'innings2') {
        tempState = ScoringEngine.transitionToSecondInnings(tempState);
      }
      history.add(tempState.copyWith(history: []));
      tempState = ScoringEngine.nextState(tempState, event);
    }

    state = AsyncValue.data(currentState.copyWith(history: history));
  }
}

final scoringProvider = StateNotifierProvider<ScoringNotifier, AsyncValue<ScoringState>>((ref) {
  return ScoringNotifier(
    ref.watch(ballRepositoryProvider),
    ref.watch(matchRepositoryProvider),
  );
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return LocalTeamRepository();
});
