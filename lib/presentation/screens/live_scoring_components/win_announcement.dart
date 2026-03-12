import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WinAnnouncement extends StatelessWidget {
  final String winnerName;
  const WinAnnouncement({super.key, required this.winnerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.emeraldColor.withValues(alpha: 0.1),
        border: Border(top: BorderSide(color: AppTheme.emeraldColor.withValues(alpha: 0.2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppTheme.emeraldColor, size: 48),
          const SizedBox(height: 16),
          Text(
            (winnerName.contains('TIED') || winnerName.contains('CONCLUDED'))
                ? winnerName
                : '$winnerName WINS!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppTheme.emeraldColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Match Completed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.slateLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emeraldColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('BACK TO HOME', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
