import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAName = ref.watch(scoringProvider.select((s) => s.value?.teamAName ?? ''));
    final teamBName = ref.watch(scoringProvider.select((s) => s.value?.teamBName ?? ''));
    final isTeamABatting = ref.watch(scoringProvider.select((s) => s.value?.isTeamABatting ?? true));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.slateColor, size: 20),
            onPressed: () {
              ref.invalidate(matchesProvider);
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TeamNameBox(
                  name: teamAName,
                  isBatting: isTeamABatting,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'vs',
                    style: TextStyle(
                      color: AppTheme.slateLight,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                _TeamNameBox(
                  name: teamBName,
                  isBatting: !isTeamABatting,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save_rounded, color: AppTheme.emeraldColor),
            tooltip: 'Save Session',
            onPressed: () async {
              await ref.read(scoringProvider.notifier).saveSession();
              ref.invalidate(matchesProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Session saved successfully!'),
                    backgroundColor: AppTheme.emeraldColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.insights_rounded, color: AppTheme.slateColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _TeamNameBox extends StatelessWidget {
  final String name;
  final bool isBatting;

  const _TeamNameBox({required this.name, required this.isBatting});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isBatting ? AppTheme.emeraldColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBatting ? AppTheme.emeraldColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isBatting ? AppTheme.emeraldColor : AppTheme.slateColor,
            ),
          ),
          if (isBatting)
            const Text(
              'BATTING',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: AppTheme.emeraldColor,
                letterSpacing: 1,
              ),
            ),
        ],
      ),
    );
  }
}
