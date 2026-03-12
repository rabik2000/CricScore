import '../../domain/entities/ball_event.dart';

class BatsmanStats {
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final bool isOut;
  final String? dismissalInfo;
  final bool isStriking;
  final bool isNonStriker;

  BatsmanStats({
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    this.isOut = false,
    this.dismissalInfo,
    this.isStriking = false,
    this.isNonStriker = false,
  });

  double get strikeRate => balls == 0 ? 0 : (runs / balls) * 100;
}

class BowlerStats {
  final int runsConceded;
  final int wickets;
  final int legalBalls;
  final int dotBalls; // Added for user request

  BowlerStats({
    required this.runsConceded,
    required this.wickets,
    required this.legalBalls,
    this.dotBalls = 0,
  });

  double get overs => (legalBalls ~/ 6) + (legalBalls % 6) / 10.0;
  double get economy => overs == 0 ? 0 : runsConceded / (legalBalls / 6.0);
}

class StatsCalculator {
  static Map<String, BatsmanStats> calculateBatsmenStats(List<BallEvent> events, String currentStriker, String currentNonStriker) {
    final stats = <String, Map<String, dynamic>>{};
    final seenBatsmen = <String>[];

    // Initialize with current batters if they exist
    if (currentStriker.isNotEmpty && !seenBatsmen.contains(currentStriker)) {
      seenBatsmen.add(currentStriker);
      stats[currentStriker] = {'runs': 0, 'balls': 0, 'fours': 0, 'sixes': 0, 'isOut': false, 'dismissal': null};
    }
    if (currentNonStriker.isNotEmpty && !seenBatsmen.contains(currentNonStriker)) {
      seenBatsmen.add(currentNonStriker);
      stats[currentNonStriker] = {'runs': 0, 'balls': 0, 'fours': 0, 'sixes': 0, 'isOut': false, 'dismissal': null};
    }

    for (final event in events) {
      if (event.isCorrected) continue;
      
      final strikerId = event.strikerId;
      final nonStrikerId = event.nonStrikerId;

      if (!seenBatsmen.contains(strikerId)) {
        seenBatsmen.add(strikerId);
        stats[strikerId] = {'runs': 0, 'balls': 0, 'fours': 0, 'sixes': 0, 'isOut': false, 'dismissal': null};
      }
      
      if (!seenBatsmen.contains(nonStrikerId)) {
        seenBatsmen.add(nonStrikerId);
        stats[nonStrikerId] = {'runs': 0, 'balls': 0, 'fours': 0, 'sixes': 0, 'isOut': false, 'dismissal': null};
      }
      
      final sData = stats[strikerId]!;
      sData['runs'] = sData['runs'] + event.runsFromBat;
      if (event.legalDelivery) {
        sData['balls'] = sData['balls'] + 1;
      }
      
      if (event.runsFromBat == 4) sData['fours'] = sData['fours'] + 1;
      if (event.runsFromBat == 6) sData['sixes'] = sData['sixes'] + 1;

      if (event.wicket) {
        final outPlayer = event.dismissedPlayerId ?? event.strikerId;
        if (!seenBatsmen.contains(outPlayer)) {
          seenBatsmen.add(outPlayer);
          stats[outPlayer] = {'runs': 0, 'balls': 0, 'fours': 0, 'sixes': 0, 'isOut': false, 'dismissal': null};
        }
        
        final outData = stats[outPlayer]!;
        outData['isOut'] = true;
        if (event.dismissalType == 'run_out') {
           outData['dismissal'] = 'run out';
         } else {
            outData['dismissal'] = 'b. ${event.bowlerId}';
         }
      }
    }

    final resultMap = <String, BatsmanStats>{};
    for (final id in seenBatsmen) {
      final trimmedId = id.trim();
      // Filter out common placeholders and empty names
      if (trimmedId == '---' || 
          trimmedId == '--' || 
          trimmedId == 'SOLO' || 
          trimmedId.toLowerCase().contains('select') || 
          trimmedId.isEmpty) {
        continue;
      }
      
      final s = stats[id]!;
      final isStriking = id == currentStriker;
      final isNonStriker = id == currentNonStriker;
      final balls = s['balls'] as int;
      final isOut = s['isOut'] as bool;

      // STRICT FILTER: 
      // Show only if:
      // 1. Is currently at the crease (regardless of stats)
      // 2. Or is Out (meaning they batted or were dismissed)
      // 3. Or has actually faced at least one ball
      if (!isStriking && !isNonStriker && !isOut && balls == 0) continue;

      resultMap[id] = BatsmanStats(
        runs: s['runs'],
        balls: balls,
        fours: s['fours'],
        sixes: s['sixes'],
        isOut: isOut,
        dismissalInfo: s['dismissal'],
        isStriking: isStriking,
        isNonStriker: isNonStriker,
      );
    }
    return resultMap;
  }

  static Map<String, BowlerStats> calculateBowlersStats(List<BallEvent> events) {
    final stats = <String, Map<String, int>>{};
    final seenBowlers = <String>[];

    for (final event in events) {
      if (event.isCorrected) continue;

      final bowlerId = event.bowlerId;
      if (bowlerId == 'Select Bowler') continue;
      
      if (!seenBowlers.contains(bowlerId)) {
        seenBowlers.add(bowlerId);
        stats[bowlerId] = {'runs': 0, 'wickets': 0, 'balls': 0, 'dots': 0};
      }

      if (event.extraType != 'bye' && event.extraType != 'leg_bye') {
        stats[bowlerId]!['runs'] = stats[bowlerId]!['runs']! + event.totalRuns;
      }

      if (event.wicket && event.dismissalType != 'run_out') {
        stats[bowlerId]!['wickets'] = stats[bowlerId]!['wickets']! + 1;
      }

      if (event.legalDelivery) {
        stats[bowlerId]!['balls'] = stats[bowlerId]!['balls']! + 1;
        // Dot ball: legal delivery, no runs from bat, no extra runs
        if (event.runsFromBat == 0 && event.extraRuns == 0 && !event.wicket) {
          stats[bowlerId]!['dots'] = stats[bowlerId]!['dots']! + 1;
        }
      }
    }

    final resultMap = <String, BowlerStats>{};
    for (final id in seenBowlers) {
      final s = stats[id]!;
      resultMap[id] = BowlerStats(
        runsConceded: s['runs']!,
        wickets: s['wickets']!,
        legalBalls: s['balls']!,
        dotBalls: s['dots']!,
      );
    }
    return resultMap;
  }
}
