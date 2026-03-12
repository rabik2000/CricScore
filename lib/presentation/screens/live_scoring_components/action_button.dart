import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppTheme.slateColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: (color ?? AppTheme.slateColor).withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: textColor ?? Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
