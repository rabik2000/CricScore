import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/providers/scoring_provider.dart';
import '../../../../core/theme/app_theme.dart';

class BatsmanCard extends ConsumerWidget {
  final String name;
  final int runs;
  final int balls;
  final bool isStriking;

  const BatsmanCard({
    super.key,
    required this.name,
    required this.runs,
    required this.balls,
    required this.isStriking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStriking ? AppTheme.emeraldColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isStriking)
                const Icon(Icons.sports_cricket_rounded, color: AppTheme.emeraldColor, size: 14)
              else
                const SizedBox(width: 14),
              const SizedBox(width: 6),
              Expanded(
                child: InkWell(
                  onTap: () => _showEditNameDialog(context, ref, name),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.slateColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showEditNameDialog(context, ref, name),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(Icons.edit_note_rounded, color: AppTheme.slateLight, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                '$runs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isStriking ? AppTheme.emeraldColor : AppTheme.slateColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($balls)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.slateLight,
                ),
              ),
            ],
          ),
// SR removed
],
),
);
}

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Edit Batsman Name',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.slateColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PLAYER NAME',
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
                prefixIcon: const Icon(Icons.person_rounded, color: AppTheme.emeraldColor),
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
                ref.read(scoringProvider.notifier).updatePlayerName(currentName, controller.text.trim());
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
}
