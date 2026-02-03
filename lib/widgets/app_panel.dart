import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';

/// Blaues Panel + Innen-Card (Standard-Look)
class AppPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const AppPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppGaps.s18),
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bluePanel,
            borderRadius: BorderRadius.circular(AppRadii.r22),
          ),
          child: Padding(
            padding: padding,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadii.r18),
                boxShadow: AppShadows.card,
                border: Border.all(color: Colors.black.withAlpha(12)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.r18),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
