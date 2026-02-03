import 'package:flutter/material.dart';

class AppColors {
  final ColorScheme scheme;
  final bool isDark;

  const AppColors._(this.scheme, this.isDark);

  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    return AppColors._(
      theme.colorScheme,
      theme.brightness == Brightness.dark,
    );
  }

  // Brand / Accent (statisch, damit const + überall nutzbar)
  static const Color orange = Color(0xFFC95B4C);
  static const Color orangeSoft = Color(0xFFFFE1DC);

  // Panels
  static const Color bluePanel = Color(0xFF355B7A);

  // Text
  static const Color muted = Color(0xFF6B7280);

  // Theme-Surface
  Color get surface => scheme.surface;
}

class AppRadii {
  static const double r18 = 18;
  static const double r22 = 22;
  static const double pill = 999;
}

class AppGaps {
  static const double s12 = 12;
  static const double s18 = 18;
}

class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color.fromARGB(28, 0, 0, 0),
      blurRadius: 18,
      offset: Offset(0, 10),
    ),
  ];
}
