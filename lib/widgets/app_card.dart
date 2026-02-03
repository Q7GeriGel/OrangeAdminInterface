import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget>? actions;

  final Widget child;
  final EdgeInsets padding;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.actions,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.r18),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
        gradient: colors.isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.scheme.surface.withOpacity(0.98),
                  colors.scheme.surface.withOpacity(0.82),
                ],
              )
            : null,
        color: colors.isDark ? null : colors.scheme.surface,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || actions != null)
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.orange),
                  const SizedBox(width: AppGaps.s10),
                ],
                if (title != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: colors.scheme.onSurface.withOpacity(0.70),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (actions != null) ...actions!,
              ],
            ),
          if (title != null || actions != null) const SizedBox(height: AppGaps.s12),
          child,
        ],
      ),
    );
  }
}
