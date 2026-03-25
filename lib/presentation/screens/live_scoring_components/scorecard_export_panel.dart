import 'package:flutter/material.dart';

import '../../../application/services/stats_calculator.dart';
import '../../../core/theme/app_theme.dart';

class ScorecardExportPanel extends StatelessWidget {
  final String headerLabel; // PARTIAL / FINAL
  final Color headerColor;

  final String inningsLabel; // 1st Innings / 2nd Innings
  final String battingTeam;
  final String oppositionTeam;

  final int totalRuns;
  final int wickets;
  final int legalBalls;

  final Map<String, int> extras; // WD/NB/B/LB

  final Map<String, BatsmanStats> batsmen;
  final Map<String, BowlerStats> bowlers;

  const ScorecardExportPanel({
    super.key,
    required this.headerLabel,
    required this.headerColor,
    required this.inningsLabel,
    required this.battingTeam,
    required this.oppositionTeam,
    required this.totalRuns,
    required this.wickets,
    required this.legalBalls,
    required this.extras,
    required this.batsmen,
    required this.bowlers,
  });

  @override
  Widget build(BuildContext context) {
    final overs = (legalBalls ~/ 6);
    final rem = (legalBalls % 6);

    const bg = Colors.white;
    const text = AppTheme.slateColor;
    const muted = AppTheme.slateLight;
    const accent = AppTheme.emeraldColor;

    final batsmenEntries = batsmen.entries.toList();
    batsmenEntries.sort((a, b) => a.key.compareTo(b.key));
    final bowlersEntries = bowlers.entries.toList();
    bowlersEntries.sort((a, b) => a.key.compareTo(b.key));

    return Material(
      color: bg,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'SCORECARD',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    headerLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Text(
              '$inningsLabel • $battingTeam vs $oppositionTeam',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.slateColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$totalRuns/$wickets',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: text,
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '($overs.$rem Ov)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: muted,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              'Extras: '
              'WD ${extras['WD'] ?? 0}, '
              'NB ${extras['NB'] ?? 0}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.slateColor.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'BATTING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: accent,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            _BattingTable(
              batsmen: batsmenEntries.map((e) => e.value).toList(),
              names: batsmenEntries.map((e) => e.key).toList(),
            ),

            const SizedBox(height: 16),

            const Text(
              'BOWLING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: accent,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            _BowlingTable(
              bowlers: bowlersEntries.map((e) => e.value).toList(),
              names: bowlersEntries.map((e) => e.key).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BattingTable extends StatelessWidget {
  final List<BatsmanStats> batsmen;
  final List<String> names;

  const _BattingTable({
    required this.batsmen,
    required this.names,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      color: AppTheme.slateLight,
      letterSpacing: 0.5,
    );

    const cellStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w900,
      color: AppTheme.slateColor,
    );

    const lightCellStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppTheme.slateLight,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(flex: 4, child: Text('BATSMAN', style: headerStyle)),
              Expanded(flex: 2, child: Text('RUNS', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('BALLS', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text('4s', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text('6s', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('S/RATE', style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < batsmen.length; i++) ...[
            _BattingRow(
              name: names[i],
              stats: batsmen[i],
              cellStyle: cellStyle,
              lightCellStyle: lightCellStyle,
            ),
            if (i != batsmen.length - 1) const Divider(height: 24, color: Color(0xFFE2E8F0)),
          ],
        ],
      ),
    );
  }
}

class _BattingRow extends StatelessWidget {
  final String name;
  final BatsmanStats stats;
  final TextStyle cellStyle;
  final TextStyle lightCellStyle;

  const _BattingRow({
    required this.name,
    required this.stats,
    required this.cellStyle,
    required this.lightCellStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isStarred = stats.isStriking || stats.isNonStriker;
    final nameColor = isStarred ? AppTheme.emeraldColor : AppTheme.slateColor;
    final dismissal = stats.dismissalInfo ?? 'not out';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: nameColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (isStarred) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star_rounded, size: 12, color: AppTheme.emeraldColor),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.slateColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dismissal,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.slateColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('${stats.runs}', style: cellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('${stats.balls}', style: cellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.fours}', style: lightCellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.sixes}', style: lightCellStyle, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              stats.strikeRate.toStringAsFixed(1),
              style: lightCellStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _BowlingTable extends StatelessWidget {
  final List<BowlerStats> bowlers;
  final List<String> names;

  const _BowlingTable({
    required this.bowlers,
    required this.names,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      color: AppTheme.slateLight,
      letterSpacing: 0.5,
    );

    const cellStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w900,
      color: AppTheme.slateColor,
    );

    const lightCellStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppTheme.slateLight,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(flex: 3, child: Text('BOWLER', style: headerStyle)),
              Expanded(flex: 1, child: Text('OV', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text('R', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text('W', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text('D', style: headerStyle, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('ECO', style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < bowlers.length; i++) ...[
            _BowlerRow(
              name: names[i],
              stats: bowlers[i],
              cellStyle: cellStyle,
              lightCellStyle: lightCellStyle,
            ),
            if (i != bowlers.length - 1) const Divider(height: 24, color: Color(0xFFE2E8F0)),
          ],
        ],
      ),
    );
  }
}

class _BowlerRow extends StatelessWidget {
  final String name;
  final BowlerStats stats;
  final TextStyle cellStyle;
  final TextStyle lightCellStyle;

  const _BowlerRow({
    required this.name,
    required this.stats,
    required this.cellStyle,
    required this.lightCellStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppTheme.slateColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(flex: 1, child: Text(stats.overs.toStringAsFixed(1), style: cellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.runsConceded}', style: cellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.wickets}', style: cellStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('${stats.dotBalls}', style: lightCellStyle, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              stats.economy.toStringAsFixed(1),
              style: lightCellStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

