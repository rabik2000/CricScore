import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ScoreboardCard extends ConsumerWidget {
  const ScoreboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Granular selection for efficiency
    final totalRuns = ref.watch(scoringProvider.select((s) => s.value?.totalRuns ?? 0));
    final totalWickets = ref.watch(scoringProvider.select((s) => s.value?.totalWickets ?? 0));
    final totalLegalBalls = ref.watch(scoringProvider.select((s) => s.value?.totalLegalBalls ?? 0));
    final isFirstInnings = ref.watch(scoringProvider.select((s) => s.value?.isFirstInnings ?? true));
    final targetRuns = ref.watch(scoringProvider.select((s) => s.value?.targetRuns));
    final isMatchComplete = ref.watch(scoringProvider.select((s) => s.value?.isMatchComplete ?? false));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$totalRuns',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.slateColor,
                  height: 1,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '/',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.slateLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Text(
                '$totalWickets',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.slateColor,
                  height: 1,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OVERS: ${(totalLegalBalls ~/ 6)}.${(totalLegalBalls % 6)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.slateColor,
                  letterSpacing: -0.5,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              if (!isFirstInnings) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    width: 1,
                    height: 18,
                    color: AppTheme.slateLight.withValues(alpha: 0.2),
                  ),
                ),
                Text(
                  'TARGET: $targetRuns',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.emeraldColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ],
          ),
          if (!isMatchComplete) ...[
            const SizedBox(height: 10),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showFinishInningsDialog(context, ref),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D55).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF2D55).withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag_rounded, size: 16, color: Color(0xFFFF2D55)),
                        SizedBox(width: 8),
                        Text(
                          'FINISH INNINGS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF2D55),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFinishInningsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Finish Innings?',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.slateColor),
        ),
        content: const Text(
          'This will end the current innings and switch to the second innings. Target will be calculated based on the current score.',
          style: TextStyle(color: AppTheme.slateLight, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.slateLight)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(scoringProvider.notifier).finishInnings();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2D55),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('FINISH INNINGS', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
