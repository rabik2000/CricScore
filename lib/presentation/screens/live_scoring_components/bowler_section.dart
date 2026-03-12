import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';

class BowlerSection extends ConsumerWidget {
  const BowlerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bowlerId = ref.watch(scoringProvider.select((s) => s.value?.bowlerId ?? 'Bowler 1'));
    final bowlerIdx = ref.watch(scoringProvider.select((s) => s.value?.bowlerNameToIndex[bowlerId]));
    final bowlerLegalBalls = ref.watch(scoringProvider.select((s) => bowlerIdx != null ? (s.value?.bowlerLegalBalls[bowlerIdx] ?? 0) : 0));
    final bowlerRuns = ref.watch(scoringProvider.select((s) => bowlerIdx != null ? (s.value?.bowlerRuns[bowlerIdx] ?? 0) : 0));
    final legalBallsThisOver = ref.watch(scoringProvider.select((s) => s.value?.legalBallsThisOver ?? 0));

    final overs = bowlerLegalBalls ~/ 6;
    final ballsRemainder = bowlerLegalBalls % 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BOWLING',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppTheme.slateLight,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (legalBallsThisOver == 0)
                ? () => _showAddBowlerDialog(context, ref)
                : () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot change bowler in the middle of an over'))),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sports_baseball_rounded, color: AppTheme.slateColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                              Text(
                                bowlerId,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.slateColor,
                                ),
                              ),
                            if (bowlerId.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showEditBowlerNameDialog(context, ref, bowlerId),
                                  borderRadius: BorderRadius.circular(4),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.edit_note_rounded, color: AppTheme.slateLight, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (bowlerLegalBalls > 0)
                          Text(
                            '$overs.$ballsRemainder Ov  •  $bowlerRuns Runs',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.slateLight,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else
                          const Text(
                            'Tap to change bowler',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.slateLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Opacity(
                    opacity: (legalBallsThisOver == 0) ? 1.0 : 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz_rounded, size: 14, color: AppTheme.emeraldColor),
                          SizedBox(width: 4),
                          Text(
                            'CHANGE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.emeraldColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditBowlerNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Edit Bowler Name',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.slateColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BOWLER NAME',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.slateColor),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: TextStyle(color: AppTheme.slateLight.withValues(alpha: 0.5)),
                filled: true,
                fillColor: AppTheme.bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.sports_baseball_rounded, color: AppTheme.emeraldColor),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.slateLight)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(scoringProvider.notifier).renameBowler(currentName, controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emeraldColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _showAddBowlerDialog(BuildContext context, WidgetRef ref) {
    final state = ref.read(scoringProvider).value;
    if (state == null) return;
    
    // All previous bowlers shown; lastBowlerId shown but disabled
    final allBowlers = state.previousBowlers;

    // Suggest next sequential bowler name by finding max "Bowler X"
    int maxBowlerNum = 0;
    final bowlerRegex = RegExp(r'^Bowler\s+(\d+)$', caseSensitive: false);
    
    for (final name in allBowlers) {
      final match = bowlerRegex.firstMatch(name);
      if (match != null) {
        final num = int.tryParse(match.group(1) ?? '0') ?? 0;
        if (num > maxBowlerNum) maxBowlerNum = num;
      }
    }
    
    // Also check current bowler if it's not in the list yet
    final currentNameMatch = bowlerRegex.firstMatch(state.bowlerId);
    if (currentNameMatch != null) {
      final num = int.tryParse(currentNameMatch.group(1) ?? '0') ?? 0;
      if (num > maxBowlerNum) maxBowlerNum = num;
    }

    final suggestedName = 'Bowler ${maxBowlerNum + 1}';
    final controller = TextEditingController(text: suggestedName);
    
    final hasAnyBowler = allBowlers.isNotEmpty;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Tighter for mobile
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Bowler Selection',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.slateColor),
        ),
        content: SizedBox(
          width: 400, // Explicit max width for mobile feel
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasAnyBowler) ...[
                // Header row
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 36), // avatar width
                      SizedBox(width: 10), // spacing
                      Expanded(flex: 3, child: SizedBox()), // name column
                      Expanded(child: _StatLabel('Overs')),
                      Expanded(child: _StatLabel('Wkts')),
                      Expanded(child: _StatLabel('Runs')),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 0.5),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: allBowlers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
                    itemBuilder: (context, index) {
                      final bowlerName = allBowlers[index];
                      final isDisabled = bowlerName == state.lastBowlerId;
                      final bIdx = state.bowlerNameToIndex[bowlerName];
                      final legal = bIdx != null ? (state.bowlerLegalBalls[bIdx] ?? 0) : 0;
                      final overs = legal ~/ 6;
                      final rem = legal % 6;
                      final wkts = bIdx != null ? (state.bowlerWickets[bIdx] ?? 0) : 0;
                      final runs = bIdx != null ? (state.bowlerRuns[bIdx] ?? 0) : 0;

                      final nameColor = isDisabled ? Colors.black45 : AppTheme.slateColor;
                      final statColor = isDisabled ? Colors.black45 : AppTheme.slateColor;

                      return InkWell(
                        onTap: isDisabled
                            ? null
                            : () {
                                ref.read(scoringProvider.notifier).updateBowlerName(bowlerName);
                                Navigator.pop(context);
                              },
                        child: Opacity(
                          opacity: isDisabled ? 0.75 : 1.0,
                          child: Container(
                            color: isDisabled ? const Color(0xFFF8FAFC) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isDisabled ? const Color(0xFFE2E8F0) : AppTheme.bgColor,
                                  child: Text(
                                    bowlerName.isNotEmpty ? bowlerName[0].toUpperCase() : '?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: nameColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    bowlerName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: nameColor,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(child: _StatValue('$overs.$rem', statColor)),
                                Expanded(child: _StatValue('$wkts', statColor)),
                                Expanded(child: _StatValue('$runs', statColor)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                'NEW BOWLER',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: !hasAnyBowler,
                style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.slateColor),
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  hintStyle: TextStyle(color: AppTheme.slateLight.withValues(alpha: 0.8)),
                  filled: true,
                  fillColor: AppTheme.bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.emeraldColor),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.slateLight)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(scoringProvider.notifier).updateBowlerName(controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emeraldColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('START BOWLING', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

// Small helper widgets for stats display
class _StatLabel extends StatelessWidget {
  final String label;
  const _StatLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.slateLight, letterSpacing: 0.3),
    );
  }
}

class _StatValue extends StatelessWidget {
  final String value;
  final Color color;
  const _StatValue(this.value, [this.color = AppTheme.slateColor]);
  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
