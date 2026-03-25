import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scorer/application/services/scoring_engine.dart';
import 'package:cricket_scorer/application/services/scoring_state.dart';

void main() {
  group('ScoringEngine', () {
    late ScoringState initialState;

    setUp(() {
      initialState = const ScoringState(
        matchId: 'test-match',
        inningsId: 'innings1',
        teamAName: 'Team A',
        teamBName: 'Team B',
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
    });

    test('createBallEvent should create a valid BallEvent', () {
      final event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 4,
        extraRuns: 0,
      );

      expect(event.runsFromBat, 4);
      expect(event.totalRuns, 4);
      expect(event.legalDelivery, true);
      expect(event.strikerId, 'Batsman 1');
      expect(event.bowlerId, 'Bowler 1');
    });

    test('nextState should handle normal runs (0, 1, 2, 4, 6)', () {
      // 0 runs
      var event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 0,
        extraRuns: 0,
      );
      var state = ScoringEngine.nextState(initialState, event);
      expect(state.totalRuns, 0);
      expect(state.totalLegalBalls, 1);
      expect(state.strikerId, 'Batsman 1');

      // 1 run (strike swap)
      event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 1,
        extraRuns: 0,
      );
      state = ScoringEngine.nextState(initialState, event);
      expect(state.totalRuns, 1);
      expect(state.strikerId, 'Batsman 2');
      expect(state.nonStrikerId, 'Batsman 1');
      expect(state.strikerRuns, 0); // Batsman 2 hasn't scored yet
      expect(state.nonStrikerRuns, 1); // Batsman 1 moved to non-striker

      // 4 runs
      event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 4,
        extraRuns: 0,
      );
      state = ScoringEngine.nextState(initialState, event);
      expect(state.totalRuns, 4);
      expect(state.strikerId, 'Batsman 1'); // No swap for even runs
      expect(state.strikerRuns, 4);
    });

    test('nextState should handle extras (Wide, No-Ball)', () {
      // Wide
      var event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 0,
        extraRuns: 1,
        extraType: 'wide',
      );
      var state = ScoringEngine.nextState(initialState, event);
      expect(state.totalRuns, 1);
      expect(state.totalLegalBalls, 0); // Wides don't count towards legal balls
      expect(state.strikerBalls, 0); // Batsman doesn't face a ball on wide

      // No Ball
      event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 0,
        extraRuns: 1,
        extraType: 'no_ball',
      );
      state = ScoringEngine.nextState(initialState, event);
      expect(state.totalRuns, 1);
      expect(state.totalLegalBalls, 0);
      expect(state.strikerBalls, 0);
    });

    test('nextState should handle wickets', () {
      final event = ScoringEngine.createBallEvent(
        currentState: initialState,
        runsFromBat: 0,
        extraRuns: 0,
        wicket: true,
      );
      final state = ScoringEngine.nextState(initialState, event);
      expect(state.totalWickets, 1);
      expect(state.totalLegalBalls, 1);
      expect(state.strikerId, 'Batsman 3'); // Batsman 1 got out, Batsman 3 comes in
      expect(state.strikerRuns, 0);
      expect(state.canEnableLastMan, false); // Not 3 wickets yet
    });

    test('canEnableLastMan should be true ONLY after 3 wickets and only on a wicket event', () {
      var state = initialState;
      // 1st wicket
      state = ScoringEngine.nextState(state, ScoringEngine.createBallEvent(currentState: state, runsFromBat: 0, extraRuns: 0, wicket: true));
      expect(state.canEnableLastMan, false);
      
      // 2nd wicket
      state = ScoringEngine.nextState(state, ScoringEngine.createBallEvent(currentState: state, runsFromBat: 0, extraRuns: 0, wicket: true));
      expect(state.canEnableLastMan, false);
      
      // 3rd wicket
      state = ScoringEngine.nextState(state, ScoringEngine.createBallEvent(currentState: state, runsFromBat: 0, extraRuns: 0, wicket: true));
      expect(state.canEnableLastMan, true); // 3 wickets and it's a wicket event

      // Next ball is a dot (not a wicket)
      state = ScoringEngine.nextState(state, ScoringEngine.createBallEvent(currentState: state, runsFromBat: 0, extraRuns: 0));
      expect(state.canEnableLastMan, false); // Should reset to false after next ball
      
      // 4th wicket
      state = ScoringEngine.nextState(state, ScoringEngine.createBallEvent(currentState: state, runsFromBat: 0, extraRuns: 0, wicket: true));
      expect(state.canEnableLastMan, true); // Re-appears on 4th wicket
    });

    test('nextState should swap strike at the end of an over', () {
      var state = initialState;
      for (int i = 0; i < 6; i++) {
        final event = ScoringEngine.createBallEvent(
          currentState: state,
          runsFromBat: 0,
          extraRuns: 0,
        );
        state = ScoringEngine.nextState(state, event);
      }

      // After 6 legal balls, strike should swap and over should reset
      expect(state.legalBallsThisOver, 0);
      expect(state.strikerId, 'Batsman 2');
      expect(state.nonStrikerId, 'Batsman 1');
      expect(state.bowlerId, startsWith('Bowler 2'));
    });

    test('transitionToSecondInnings should correctly flip the match', () {
      final firstInningsFinalState = initialState.copyWith(
        totalRuns: 150,
        totalWickets: 5,
        totalLegalBalls: 120,
      );

      final secondInningsState = ScoringEngine.transitionToSecondInnings(firstInningsFinalState);

      expect(secondInningsState.isFirstInnings, false);
      expect(secondInningsState.inningsId, 'innings2');
      expect(secondInningsState.targetRuns, 151);
      expect(secondInningsState.totalRuns, 0);
      expect(secondInningsState.totalWickets, 0);
      expect(secondInningsState.isTeamABatting, false);
      expect(secondInningsState.strikerId, 'Batsman 1'); // New batsmen for 2nd innings
    });

    test('reconstructState should build correct state from events', () {
      final events = [
        ScoringEngine.createBallEvent(currentState: initialState, runsFromBat: 1, extraRuns: 0),
        ScoringEngine.createBallEvent(
          currentState: ScoringEngine.nextState(initialState, ScoringEngine.createBallEvent(currentState: initialState, runsFromBat: 1, extraRuns: 0)),
          runsFromBat: 4,
          extraRuns: 0,
        ),
      ];

      final state = ScoringEngine.reconstructState(
        matchId: 'test-match',
        teamAName: 'Team A',
        teamBName: 'Team B',
        events: events,
      );

      expect(state.totalRuns, 5);
      expect(state.totalLegalBalls, 2);
    });
  });
}
