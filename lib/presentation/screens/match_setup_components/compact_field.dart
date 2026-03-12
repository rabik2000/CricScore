import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CompactField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const CompactField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: AppTheme.slateLight.withValues(alpha: 0.7),
          fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1,
        )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.slateColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 16, color: AppTheme.slateLight.withValues(alpha: 0.3), fontWeight: FontWeight.w500),
            prefixIcon: Icon(icon, size: 20, color: AppTheme.slateLight.withValues(alpha: 0.5)),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            filled: true,
            fillColor: AppTheme.bgColor.withValues(alpha: 0.5),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.slateColor.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.emeraldColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
