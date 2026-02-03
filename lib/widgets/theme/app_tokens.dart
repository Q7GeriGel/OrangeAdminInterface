import 'package:flutter/material.dart';

class AppColors {
  // Brand / Accent (statisch nutzbar UND über of(context) kompatibel)
  static const Color orange = Color(0xFFC95B4C);
  static const Color orangeSoft = Color(0xFFFFE1DC);

  // Panels / Accent 2
  static const Color bluePanel = Color(0xFF355B7A);

  // Utility
  static const Color muted = Color(0xFF6B7280);

  final ColorScheme scheme;
  final bool isDark;

  const AppColors._(this.scheme, this.isDark);

  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    return AppColors._(theme.colorScheme, theme.brightness == Brightness.dark);
  }

  // Komfort-Getter (damit überall gleich)
  Color get surface => scheme.surface;
  Color get surface2 => isDark ? scheme.surface.withOpacity(0.85) : scheme.surface;
  Color get border => scheme.outlineVariant.withOpacity(isDark ? 0.35 : 0.55);

  Color get onSurface => scheme.onSurface;

  Color get accent => orange;
  Color get accentSoft => orangeSoft;
}

class AppRadii {
  static const double r14 = 14;
  static const double r18 = 18;
  static const double r22 = 22;
  static const double pill = 999;
}

class AppGaps {
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s24 = 24;
}

class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color.fromARGB(30, 0, 0, 0),
      blurRadius: 22,
      offset: Offset(0, 12),
    ),
  ];
}
