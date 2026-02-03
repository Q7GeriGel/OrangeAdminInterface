import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';

class AppStatusChip extends StatelessWidget {
  final String text;
  final Color? color;

  const AppStatusChip({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final base = color ?? AppColors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: base.withValues(alpha: 0.30)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: colors.isDark ? colors.scheme.onSurface : Colors.black,
        ),
      ),
    );
  }
}
