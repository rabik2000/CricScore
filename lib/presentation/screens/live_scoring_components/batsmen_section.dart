import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../scorecard_screen.dart';
import 'batsman_card.dart';

class BatsmenSection extends ConsumerWidget {
  const BatsmenSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strikerId = ref.watch(scoringProvider.select((s) => s.value?.strikerId ?? ''));
    final strikerRuns = ref.watch(scoringProvider.select((s) => s.value?.strikerRuns ?? 0));
    final strikerBalls = ref.watch(scoringProvider.select((s) => s.value?.strikerBalls ?? 0));
    final nonStrikerId = ref.watch(scoringProvider.select((s) => s.value?.nonStrikerId ?? ''));
    final nonStrikerRuns = ref.watch(scoringProvider.select((s) => s.value?.nonStrikerRuns ?? 0));
    final nonStrikerBalls = ref.watch(scoringProvider.select((s) => s.value?.nonStrikerBalls ?? 0));
    final totalLegalBalls = ref.watch(scoringProvider.select((s) => s.value?.totalLegalBalls ?? 0));
    final currentOverBallsEmpty = ref.watch(scoringProvider.select((s) => s.value?.currentOverBalls.isEmpty ?? true));
    final lastBallWicket = ref.watch(scoringProvider.select((s) => s.value?.lastBallWicket ?? false));
    final totalWickets = ref.watch(scoringProvider.select((s) => s.value?.totalWickets ?? 0));
    final isMatchComplete = ref.watch(scoringProvider.select((s) => s.value?.isMatchComplete ?? false));
    final canEnableLastMan = ref.watch(scoringProvider.select((s) => s.value?.canEnableLastMan ?? false));
    final isLastManMode = ref.watch(scoringProvider.select((s) => s.value?.isLastManMode ?? false));

    return Column(
      children: [
        const SizedBox(height: 4),
        if (!isMatchComplete && (canEnableLastMan || isLastManMode))
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: canEnableLastMan && !isLastManMode
                      ? () => ref.read(scoringProvider.notifier).toggleLastManMode()
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLastManMode 
                          ? AppTheme.emeraldColor 
                          : (canEnableLastMan ? Colors.white : AppTheme.slateColor.withValues(alpha: 0.05)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isLastManMode 
                            ? AppTheme.emeraldColor 
                            : (canEnableLastMan ? AppTheme.emeraldColor : Colors.transparent),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLastManMode ? Icons.check_circle_rounded : Icons.person_off_rounded,
                          size: 14,
                          color: isLastManMode ? Colors.white : (canEnableLastMan ? AppTheme.emeraldColor : AppTheme.slateLight),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LAST MAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: isLastManMode ? Colors.white : (canEnableLastMan ? AppTheme.emeraldColor : AppTheme.slateLight),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: BatsmanCard(
                    name: strikerId,
                    runs: strikerRuns,
                    balls: strikerBalls,
                    isStriking: true,
                  ),
                ),
                if (!isLastManMode) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: BatsmanCard(
                      name: nonStrikerId,
                      runs: nonStrikerRuns,
                      balls: nonStrikerBalls,
                      isStriking: false,
                    ),
                  ),
                ],
              ],
            ),
            if (((totalLegalBalls == 0 && currentOverBallsEmpty) || lastBallWicket) && !isLastManMode)
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  onTap: () => ref.read(scoringProvider.notifier).switchBatsmen(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.emeraldColor.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.sync_alt_rounded, color: AppTheme.emeraldColor, size: 20),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScorecardScreen()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.slateColor.withValues(alpha: 0.08)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.analytics_rounded, size: 16, color: AppTheme.slateColor),
                    SizedBox(width: 8),
                    Text(
                      'SCORECARD',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: AppTheme.slateColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
