import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';

class AppCard extends StatelessWidget {
  // ✅ optional, damit alte Aufrufe ohne title weiter funktionieren
  final String? title;
  final IconData? icon;
  final Widget? trailing;

  final Widget child;
  final EdgeInsets padding;

  const AppCard({
    super.key,
    this.title,
    this.icon,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.r18),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: colors.isDark
              ? colors.scheme.outlineVariant.withValues(alpha: 0.35)
              : colors.scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.orange),
                  const SizedBox(width: AppGaps.s12),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppGaps.s12),
          ],
          child,
        ],
      ),
    );
  }
}
