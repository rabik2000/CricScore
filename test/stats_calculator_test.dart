import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scorer/application/services/stats_calculator.dart';
import 'package:cricket_scorer/domain/entities/ball_event.dart';

void main() {
  group('StatsCalculator', () {
    test('calculateBatsmenStats should compute accurate runs and balls', () {
      final List<BallEvent> events = [
        BallEvent(
          id: '1', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 1,
          strikerId: 'Batsman 1', nonStrikerId: 'Batsman 2', bowlerId: 'B1',
          runs: 1, runsFromBat: 1, extraRuns: 0, totalRuns: 1, wicket: false, legalDelivery: true, timestamp: DateTime.now(),
        ),
        BallEvent(
          id: '2', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 2,
          strikerId: 'Batsman 2', nonStrikerId: 'Batsman 1', bowlerId: 'B1',
          runs: 4, runsFromBat: 4, extraRuns: 0, totalRuns: 4, wicket: false, legalDelivery: true, timestamp: DateTime.now(),
        ),
      ];

      final stats = StatsCalculator.calculateBatsmenStats(events, 'Batsman 2', 'Batsman 1');

      expect(stats['Batsman 1']!.runs, 1);
      expect(stats['Batsman 1']!.balls, 1);
      expect(stats['Batsman 2']!.runs, 4);
      expect(stats['Batsman 2']!.balls, 1);
      expect(stats['Batsman 2']!.fours, 1);
    });

    test('calculateBowlersStats should compute overs and economy', () {
      final List<BallEvent> events = [
        BallEvent(
          id: '1', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 1,
          strikerId: 'B1', nonStrikerId: 'B2', bowlerId: 'Bowler 1',
          runs: 6, runsFromBat: 6, extraRuns: 0, totalRuns: 6, wicket: false, legalDelivery: true, timestamp: DateTime.now(),
        ),
        BallEvent(
          id: '2', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 2,
          strikerId: 'B1', nonStrikerId: 'B2', bowlerId: 'Bowler 1',
          runs: 0, runsFromBat: 0, extraRuns: 0, totalRuns: 0, wicket: false, legalDelivery: true, timestamp: DateTime.now(),
        ),
      ];

      final stats = StatsCalculator.calculateBowlersStats(events);

      expect(stats['Bowler 1']!.runsConceded, 6);
      expect(stats['Bowler 1']!.legalBalls, 2);
      expect(stats['Bowler 1']!.dotBalls, 1);
      expect(stats['Bowler 1']!.overs, 0.2);
    });

    test('calculateBowlersStats should exclude byes and leg-byes from bowler runs', () {
      final List<BallEvent> events = [
        // Leg bye
        BallEvent(
          id: '1', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 1,
          strikerId: 'B1', nonStrikerId: 'B2', bowlerId: 'Bowler 1',
          runs: 1, runsFromBat: 0, extraRuns: 1, totalRuns: 1, extraType: 'leg_bye', wicket: false, legalDelivery: true, timestamp: DateTime.now(),
        ),
        // Wide
        BallEvent(
          id: '2', matchId: 'm', inningsId: 'i1', overNumber: 1, ballNumber: 2,
          strikerId: 'B1', nonStrikerId: 'B2', bowlerId: 'Bowler 1',
          runs: 1, runsFromBat: 0, extraRuns: 1, totalRuns: 1, extraType: 'wide', wicket: false, legalDelivery: false, timestamp: DateTime.now(),
        ),
      ];

      final stats = StatsCalculator.calculateBowlersStats(events);

      // Bowler conceded the wide run, but NOT the leg bye
      expect(stats['Bowler 1']!.runsConceded, 1);
      expect(stats['Bowler 1']!.legalBalls, 1); // Wide not legal
    });
  });
}
