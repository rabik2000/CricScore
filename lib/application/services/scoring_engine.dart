import 'package:uuid/uuid.dart';
import '../../domain/entities/ball_event.dart';
import 'scoring_state.dart';

class ScoringEngine {
  static BallEvent createBallEvent({
    required ScoringState currentState,
    required int runsFromBat,
    required int extraRuns,
    String? extraType,
    bool wicket = false,
    String? dismissalType,
    String? dismissedPlayerId,
  }) {
    final isLegal = extraType != 'wide' && extraType != 'no_ball';
    final totalRuns = runsFromBat + extraRuns;

    return BallEvent(
      id: const Uuid().v4(),
      matchId: currentState.matchId,
      inningsId: currentState.inningsId,
      overNumber: (currentState.totalLegalBalls ~/ 6) + 1,
      ballNumber: (currentState.totalLegalBalls % 6) + 1,
      strikerId: currentState.strikerId,
      nonStrikerId: currentState.nonStrikerId,
      bowlerId: currentState.bowlerId,
      runs: totalRuns,
      extraType: extraType,
      extraRuns: extraRuns,
      runsFromBat: runsFromBat,
      totalRuns: totalRuns,
      wicket: wicket,
      dismissalType: dismissalType,
      dismissedPlayerId: dismissedPlayerId,
      legalDelivery: isLegal,
      timestamp: DateTime.now(),
    );
  }

  static ScoringState nextState(ScoringState current, BallEvent event) {
    if (event.isCorrected) return current;

    var strikerId = event.strikerId;
    var nonStrikerId = event.nonStrikerId;
    var strikerRuns = current.strikerRuns;
    var strikerBalls = current.strikerBalls;
    var nonStrikerRuns = current.nonStrikerRuns;
    var nonStrikerBalls = current.nonStrikerBalls;
    
    var totalRuns = current.totalRuns + event.totalRuns;
    var totalWickets = current.totalWickets + (event.wicket ? 1 : 0);
    var legalBallsThisOver = current.legalBallsThisOver + (event.legalDelivery ? 1 : 0);
    var totalLegalBalls = current.totalLegalBalls + (event.legalDelivery ? 1 : 0);

    if (event.extraType != 'wide') {
      strikerRuns += event.runsFromBat;
    }
    if (event.legalDelivery) {
      strikerBalls++;
    }

    // Strike Rotation
    if (!current.isLastManMode) {
      int runsForStrikerToSwitch = event.runsFromBat;
      if (event.extraType == 'wide') {
        runsForStrikerToSwitch = event.totalRuns - 1; // 1 wide + X runs taken
      } else if (event.extraType == 'no_ball') {
         runsForStrikerToSwitch = event.runsFromBat; // Leg byes on NB don't rotate strike usually in simple games, but let's follow: runsFromBat rotates.
      } else if (event.extraType == 'bye' || event.extraType == 'leg_bye') {
        runsForStrikerToSwitch = event.totalRuns;
      }

      if (runsForStrikerToSwitch % 2 != 0) {
        // Swap striker and non-striker
        final tempId = strikerId;
        final tempRuns = strikerRuns;
        final tempBalls = strikerBalls;
        
        strikerId = nonStrikerId;
        strikerRuns = nonStrikerRuns;
        strikerBalls = nonStrikerBalls;
        
        nonStrikerId = tempId;
        nonStrikerRuns = tempRuns;
        nonStrikerBalls = tempBalls;
      }
    }

    // Handle Match Completion and Wicket / Run-Out replacement
    bool isMatchComplete = false;
    String? winnerName;

    if (event.wicket) {
      if (current.isLastManMode) {
        // Innings ends, but let ScoringNotifier handle the transition
      } else {
        final outPlayer = event.dismissedPlayerId ?? event.strikerId;
        final nextBatsmanNum = totalWickets + 2; 
        final nextBatsmanName = 'Batsman $nextBatsmanNum';
        
        if (outPlayer == strikerId) {
          strikerId = nextBatsmanName;
          strikerRuns = 0;
          strikerBalls = 0;
        } else {
          nonStrikerId = nextBatsmanName;
          nonStrikerRuns = 0;
          nonStrikerBalls = 0;
        }
      }
    }

    // Track balls in current over
    final ballsInOver = List<String>.from(current.currentOverBalls);
    String ballLabel = event.runsFromBat.toString();
    
    if (event.extraType == 'wide') {
      ballLabel = event.totalRuns == 1 ? 'WD' : '${event.totalRuns - 1}WD';
    } else if (event.extraType == 'no_ball') {
      ballLabel = event.totalRuns == 1 ? 'NB' : '${event.totalRuns - 1}NB';
    } else if (event.wicket) {
      if (event.dismissalType == 'run_out') {
        ballLabel = '${event.totalRuns}W';
      } else {
        ballLabel = 'W';
      }
    }
    
    ballsInOver.add(ballLabel);

    var currentBowlerId = event.bowlerId;
    var lastBowlerId = current.lastBowlerId;

    // Update per-bowler stats for the current bowler
    final bLegal = Map<String, int>.from(current.bowlerLegalBalls);
    final bDots = Map<String, int>.from(current.bowlerDotBalls);
    final bWickets = Map<String, int>.from(current.bowlerWickets);
    final bRuns = Map<String, int>.from(current.bowlerRuns);

    if (event.legalDelivery) {
      bLegal[currentBowlerId] = (bLegal[currentBowlerId] ?? 0) + 1;
    }
    if (event.legalDelivery && event.runsFromBat == 0 && event.extraRuns == 0 && !event.wicket) {
      bDots[currentBowlerId] = (bDots[currentBowlerId] ?? 0) + 1;
    }
    if (event.wicket && event.dismissalType != 'run_out') {
      bWickets[currentBowlerId] = (bWickets[currentBowlerId] ?? 0) + 1;
    }
    bRuns[currentBowlerId] = (bRuns[currentBowlerId] ?? 0) + event.totalRuns;

    // Check for target chase completion
    if (!current.isFirstInnings && current.targetRuns != null) {
      if (totalRuns >= current.targetRuns!) {
        isMatchComplete = true;
        winnerName = current.isTeamABatting ? current.teamAName : current.teamBName;
      }
    }

    // Over completion logic
    if (legalBallsThisOver == 6) {
      // Swap strike at end of over ONLY if NOT in Last Man Mode
      if (!current.isLastManMode) {
        final tempId = strikerId;
        final tempRuns = strikerRuns;
        final tempBalls = strikerBalls;
        
        strikerId = nonStrikerId;
        strikerRuns = nonStrikerRuns;
        strikerBalls = nonStrikerBalls;
        
        nonStrikerId = tempId;
        nonStrikerRuns = tempRuns;
        nonStrikerBalls = tempBalls;
      }
      
      legalBallsThisOver = 0;
      ballsInOver.clear();

      final updatedPreviousBowlers = List<String>.from(current.previousBowlers);
      if (!updatedPreviousBowlers.contains(currentBowlerId)) {
        updatedPreviousBowlers.add(currentBowlerId);
      }
      
      lastBowlerId = currentBowlerId;
      
      int maxBowlerNum = 0;
      final bowlerRegex = RegExp(r'^Bowler\s+(\d+)$', caseSensitive: false);
      for (final name in updatedPreviousBowlers) {
        final match = bowlerRegex.firstMatch(name);
        if (match != null) {
          final num = int.tryParse(match.group(1) ?? '0') ?? 0;
          if (num > maxBowlerNum) maxBowlerNum = num;
        }
      }
      
      currentBowlerId = 'Bowler ${maxBowlerNum + 1}';
      
      return current.copyWith(
        strikerId: strikerId,
        nonStrikerId: nonStrikerId,
        strikerRuns: strikerRuns,
        strikerBalls: strikerBalls,
        nonStrikerRuns: nonStrikerRuns,
        nonStrikerBalls: nonStrikerBalls,
        totalRuns: totalRuns,
        totalWickets: totalWickets,
        legalBallsThisOver: legalBallsThisOver,
        totalLegalBalls: totalLegalBalls,
        currentOverBalls: ballsInOver,
        bowlerId: currentBowlerId,
        lastBowlerId: lastBowlerId,
        bowlerLegalBalls: bLegal,
        bowlerDotBalls: bDots,
        bowlerWickets: bWickets,
        bowlerRuns: bRuns,
        previousBowlers: updatedPreviousBowlers,
        isMatchComplete: isMatchComplete,
        winnerName: winnerName,
        lastBallWicket: event.wicket,
        canEnableLastMan: totalWickets >= 3 && event.wicket,
        isLastManMode: current.isLastManMode,
      );
    }

    return current.copyWith(
      strikerId: strikerId,
      nonStrikerId: nonStrikerId,
      strikerRuns: strikerRuns,
      strikerBalls: strikerBalls,
      nonStrikerRuns: nonStrikerRuns,
      nonStrikerBalls: nonStrikerBalls,
      totalRuns: totalRuns,
      totalWickets: totalWickets,
      legalBallsThisOver: legalBallsThisOver,
      totalLegalBalls: totalLegalBalls,
      currentOverBalls: ballsInOver,
      bowlerId: currentBowlerId,
      lastBowlerId: lastBowlerId,
      bowlerLegalBalls: bLegal,
      bowlerDotBalls: bDots,
      bowlerWickets: bWickets,
      bowlerRuns: bRuns,
      isMatchComplete: isMatchComplete,
      winnerName: winnerName,
      lastBallWicket: event.wicket,
      canEnableLastMan: totalWickets >= 3 && event.wicket,
      isLastManMode: current.isLastManMode,
    );
  }

  static ScoringState reconstructState({
    required String matchId,
    required String teamAName,
    required String teamBName,
    required List<BallEvent> events,
  }) {
    // Initial state is always Innings 1 start
    var currentState = ScoringState(
      matchId: matchId,
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
      isTeamABatting: true, // Placeholder, will be corrected by events if needed
    );

    // Group events by innings and sort by timestamp
    final sortedEvents = List<BallEvent>.from(events)..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final event in sortedEvents) {
      // If event belongs to a different innings than current state, we need to transition
      if (event.inningsId != currentState.inningsId) {
        // transitioning from innings 1 to innings 2
        if (currentState.isFirstInnings && event.inningsId == 'innings2') {
           // This logic mirrors ScoringNotifier.finishInnings for 1st innings
           currentState = currentState.copyWith(
            isFirstInnings: false,
            inningsId: 'innings2',
            targetRuns: currentState.totalRuns + 1,
            isTeamABatting: !currentState.isTeamABatting,
            totalRuns: 0,
            totalWickets: 0,
            totalLegalBalls: 0,
            legalBallsThisOver: 0,
            currentOverBalls: [],
            previousBowlers: [],
            bowlerId: 'Select Bowler',
            strikerId: 'Select Striker',
            nonStrikerId: 'Select Non-Striker',
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
        }
      }
      
      currentState = nextState(currentState, event);
    }

    return currentState;
  }
}
