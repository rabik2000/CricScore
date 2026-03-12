import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/scoring_engine.dart';
import '../services/scoring_state.dart';
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
    
    // Validation: Ensure a bowler is selected
    if (currentState.bowlerId == 'Select Bowler' || currentState.bowlerId.trim().isEmpty) {
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
    final history = List<ScoringState>.from(currentState.history);
    history.add(currentState.copyWith(history: [])); // Save state without its own history

    state = AsyncValue.data(nextState.copyWith(
      history: history,
      lastBallId: event.id,
    ));

    // Persist to repository
    await _ballRepository.recordBall(event);

    // Automatic innings finish if 10 wickets lost OR last man is out
    if (nextState.totalWickets >= 10 || (nextState.isLastManMode && wicket)) {
      await finishInnings();
    } else if (nextState.isMatchComplete) {
       // Target chased down
       await _updateMatchStatus(nextState.matchId, MatchStatus.completed);
    }
  }

  Future<void> undo() async {
    final currentState = state.value;
    if (currentState == null || currentState.history.isEmpty) return;

    // Remove the last ball from the repository if it exists
    if (currentState.lastBallId != null) {
      await _ballRepository.deleteBall(currentState.lastBallId!);
    }

    final history = List<ScoringState>.from(currentState.history);
    final previousState = history.removeLast();
    
    state = AsyncValue.data(previousState.copyWith(history: history));
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

  Future<void> _updateMatchStatus(String matchId, MatchStatus status) async {
    final match = await _matchRepository.getMatch(matchId);
    if (match != null && match.status != status) {
      await _matchRepository.updateMatch(match.copyWith(status: status));
    }
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
    
    // Update current bowler if it matches
    if (currentState.bowlerId == oldName) {
      nextState = nextState.copyWith(bowlerId: newName);
    }

    // Update last bowler if it matches
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

    // Update maps
    final bowlerLegalBalls = Map<String, int>.from(currentState.bowlerLegalBalls);
    if (bowlerLegalBalls.containsKey(oldName)) {
      bowlerLegalBalls[newName] = bowlerLegalBalls.remove(oldName)!;
    }

    final bowlerDotBalls = Map<String, int>.from(currentState.bowlerDotBalls);
    if (bowlerDotBalls.containsKey(oldName)) {
      bowlerDotBalls[newName] = bowlerDotBalls.remove(oldName)!;
    }

    final bowlerWickets = Map<String, int>.from(currentState.bowlerWickets);
    if (bowlerWickets.containsKey(oldName)) {
      bowlerWickets[newName] = bowlerWickets.remove(oldName)!;
    }

    final bowlerRuns = Map<String, int>.from(currentState.bowlerRuns);
    if (bowlerRuns.containsKey(oldName)) {
      bowlerRuns[newName] = bowlerRuns.remove(oldName)!;
    }

    state = AsyncValue.data(nextState.copyWith(
      previousBowlers: previousBowlers,
      bowlerLegalBalls: bowlerLegalBalls,
      bowlerDotBalls: bowlerDotBalls,
      bowlerWickets: bowlerWickets,
      bowlerRuns: bowlerRuns,
    ));
  }
  
  Future<void> finishInnings() async {
    final currentState = state.value;
    if (currentState == null || currentState.isMatchComplete) return;

    if (currentState.isFirstInnings) {
      final nextState = currentState.copyWith(
        isFirstInnings: false,
        inningsId: 'innings2',
        targetRuns: currentState.totalRuns + 1,
        isTeamABatting: !currentState.isTeamABatting,
        totalRuns: 0,
        totalWickets: 0,
        totalLegalBalls: 0,
        legalBallsThisOver: 0,
        currentOverBalls: [],
        previousBowlers: ['Bowler 1'],
        bowlerId: 'Bowler 1',
        strikerId: 'Batsman 1',
        nonStrikerId: 'Batsman 2',
        strikerRuns: 0,
        strikerBalls: 0,
        nonStrikerRuns: 0,
        nonStrikerBalls: 0,
        bowlerLegalBalls: {},
        bowlerDotBalls: {},
        bowlerWickets: {},
        bowlerRuns: {},
        lastBowlerId: '',
        isLastManMode: false,
        canEnableLastMan: false,
      );
      state = AsyncValue.data(nextState);
    } else {
      // Second innings finish - calculate winner
      String winnerMsg;
      final battingTeam = currentState.isTeamABatting ? currentState.teamAName : currentState.teamBName;
      final bowlingTeam = currentState.isTeamABatting ? currentState.teamBName : currentState.teamAName;
      
      if (currentState.targetRuns != null) {
        if (currentState.totalRuns >= currentState.targetRuns!) {
          winnerMsg = battingTeam;
        } else if (currentState.totalRuns < currentState.targetRuns! - 1) {
          winnerMsg = bowlingTeam;
        } else {
          winnerMsg = 'MATCH TIED';
        }
      } else {
        winnerMsg = 'MATCH CONCLUDED';
      }

      state = AsyncValue.data(currentState.copyWith(
        isMatchComplete: true,
        winnerName: winnerMsg,
      ));
      
      // Persist completed status
      await _updateMatchStatus(currentState.matchId, MatchStatus.completed);
    }
  }

  void switchBatsmen() {
    final currentState = state.value;
    if (currentState == null) return;

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
      state = AsyncValue.data(currentState.copyWith(
        isLastManMode: true,
        canEnableLastMan: false,
        nonStrikerId: '---', // Clear non-striker
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
      strikerId: 'Select Striker',
      nonStrikerId: 'Select Non-Striker',
      bowlerId: 'Select Bowler',
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
         tempState = tempState.copyWith(
            isFirstInnings: false,
            inningsId: 'innings2',
            targetRuns: tempState.totalRuns + 1,
            isTeamABatting: !tempState.isTeamABatting,
            totalRuns: 0, totalWickets: 0, totalLegalBalls: 0, legalBallsThisOver: 0,
            currentOverBalls: [], previousBowlers: [], bowlerId: 'Select Bowler',
            strikerId: 'Select Striker', nonStrikerId: 'Select Non-Striker',
            strikerRuns: 0, strikerBalls: 0, nonStrikerRuns: 0, nonStrikerBalls: 0,
            bowlerLegalBalls: {}, bowlerDotBalls: {}, bowlerWickets: {}, bowlerRuns: {},
            lastBowlerId: '', isLastManMode: false, canEnableLastMan: false,
          );
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
