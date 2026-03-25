import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../application/providers/scoring_provider.dart';
import '../../../../application/services/stats_calculator.dart';
import '../../../../application/services/scoring_state.dart';
import '../../../../domain/entities/match.dart';
import '../../../../domain/entities/ball_event.dart';
import '../../../../infrastructure/ads/rewarded_ad_gate.dart';
import 'scorecard_export_file_saver.dart';
import 'scorecard_export_panel.dart';

Future<void> exportScorecardsToPngAndShare({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export is available on Android/iOS only.')),
    );
    return;
  }

  final scoring = ref.read(scoringProvider).value;
  if (scoring == null) return;

  final match = await ref.read(matchRepositoryProvider).getMatch(scoring.matchId);
  final bool isFinal = (match?.status == MatchStatus.completed) || scoring.isMatchComplete;

  final headerLabel = isFinal ? 'FINAL' : 'PARTIAL';
  final headerColor = isFinal ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

  final ballRepo = ref.read(ballRepositoryProvider);
  final events = await ballRepo
      .watchBallEvents(scoring.matchId, null)
      .first;

  final sorted = List<BallEvent>.from(events)..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  final innings1Events = sorted.where((e) => e.inningsId == 'innings1').toList();
  final innings2Events = sorted.where((e) => e.inningsId == 'innings2').toList();

  // Rewarded ad gate (required).
  try {
    await RewardedAdGate().showRewardedAd();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad not available. Try again.')),
      );
    }
    return;
  }

  if (context.mounted) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Exporting...'),
        content: SizedBox(
          height: 64,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  late final Uint8List bytes1;
  late final Uint8List bytes2;
  try {
    final inningsTeams = _inningsTeams(scoring);
    final innings1Batting = inningsTeams['innings1Batting'] ?? scoring.teamAName;
    final innings1Opposition = inningsTeams['innings1Opposition'] ?? scoring.teamBName;
    final innings2Batting = inningsTeams['innings2Batting'] ?? scoring.teamBName;
    final innings2Opposition = inningsTeams['innings2Opposition'] ?? scoring.teamAName;

    bytes1 = await _captureInningsPng(
      scoringState: scoring,
      inningsEvents: innings1Events,
      inningsId: 'innings1',
      inningsLabel: '1st Innings',
      battingTeam: innings1Batting,
      oppositionTeam: innings1Opposition,
      headerLabel: headerLabel,
      headerColor: headerColor,
    );

    bytes2 = await _captureInningsPng(
      scoringState: scoring,
      inningsEvents: innings2Events,
      inningsId: 'innings2',
      inningsLabel: '2nd Innings',
      battingTeam: innings2Batting,
      oppositionTeam: innings2Opposition,
      headerLabel: headerLabel,
      headerColor: headerColor,
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export failed while generating images.')),
      );
    }
    return;
  } finally {
    if (context.mounted) Navigator.of(context).pop();
  }

  final stamp = DateTime.now().millisecondsSinceEpoch;

  final safeMatchId = scoring.matchId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

  final file1Path = await savePngToDevice(
    bytes1,
    'scorecard_${safeMatchId}_${stamp}_innings1.png',
  );

  final file2Path = await savePngToDevice(
    bytes2,
    'scorecard_${safeMatchId}_${stamp}_innings2.png',
  );

  if (context.mounted) {
    // Share both innings PNGs in ONE share action.
    // Chat apps like Messenger often attach only the first file if we share sequentially.
    await SharePlus.instance.share(
      ShareParams(
        text: 'Scorecard ${isFinal ? 'Final' : 'Partial'} (2 innings)',
        files: [
          XFile(file1Path),
          XFile(file2Path),
        ],
      ),
    );
  }

  // Saved to device as PNG files for both innings.
}

Map<String, String> _inningsTeams(ScoringState state) {
  // When state.isFirstInnings is true, state.isTeamABatting refers to innings1 batting team.
  // When false, state.isTeamABatting refers to innings2 batting team.
  final String innings1Batting;
  final String innings2Batting;

  if (state.isFirstInnings) {
    innings1Batting = state.isTeamABatting ? state.teamAName : state.teamBName;
    innings2Batting = state.isTeamABatting ? state.teamBName : state.teamAName;
  } else {
    innings2Batting = state.isTeamABatting ? state.teamAName : state.teamBName;
    innings1Batting = state.isTeamABatting ? state.teamBName : state.teamAName;
  }

  final innings1Opposition = innings1Batting == state.teamAName ? state.teamBName : state.teamAName;
  final innings2Opposition = innings2Batting == state.teamAName ? state.teamBName : state.teamAName;

  return {
    'innings1Batting': innings1Batting,
    'innings1Opposition': innings1Opposition,
    'innings2Batting': innings2Batting,
    'innings2Opposition': innings2Opposition,
  };
}

Future<Uint8List> _captureInningsPng({
  required ScoringState scoringState,
  required List<BallEvent> inningsEvents,
  required String inningsId,
  required String inningsLabel,
  required String battingTeam,
  required String oppositionTeam,
  required String headerLabel,
  required Color headerColor,
}) async {
  final striker = scoringState.inningsId == inningsId ? scoringState.strikerId : '';
  final nonStriker = scoringState.inningsId == inningsId ? scoringState.nonStrikerId : '';

  final sortedEvents = List<BallEvent>.from(inningsEvents)
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  final batsmenStats = StatsCalculator.calculateBatsmenStats(sortedEvents, striker, nonStriker);
  final bowlersStats = StatsCalculator.calculateBowlersStats(sortedEvents);

  final extras = _calculateExtrasBreakdown(sortedEvents);

  int totalRuns = 0;
  int wickets = 0;
  int legalBalls = 0;
  for (final e in sortedEvents) {
    totalRuns += e.totalRuns;
    if (e.wicket) wickets++;
    if (e.legalDelivery) legalBalls++;
  }

  const panelWidth = 1080.0;

  final controller = ScreenshotController();
  return controller.captureFromLongWidget(
    SizedBox(
      width: panelWidth,
      child: ScorecardExportPanel(
        headerLabel: headerLabel,
        headerColor: headerColor,
        inningsLabel: inningsLabel,
        battingTeam: battingTeam,
        oppositionTeam: oppositionTeam,
        totalRuns: totalRuns,
        wickets: wickets,
        legalBalls: legalBalls,
        extras: extras,
        batsmen: batsmenStats,
        bowlers: bowlersStats,
      ),
    ),
    delay: const Duration(seconds: 1),
    pixelRatio: 3.0,
    constraints: const BoxConstraints(maxWidth: panelWidth),
  );
}

Map<String, int> _calculateExtrasBreakdown(List<BallEvent> events) {
  final breakdown = <String, int>{'WD': 0, 'NB': 0, 'B': 0, 'LB': 0};
  for (final ball in events) {
    if (ball.extraType == 'wide') breakdown['WD'] = breakdown['WD']! + ball.extraRuns;
    if (ball.extraType == 'no_ball') breakdown['NB'] = breakdown['NB']! + ball.totalRuns;
    if (ball.extraType == 'bye') breakdown['B'] = breakdown['B']! + ball.extraRuns;
    if (ball.extraType == 'leg_bye') breakdown['LB'] = breakdown['LB']! + ball.extraRuns;
  }
  return breakdown;
}

