import 'package:flutter/material.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.orange,
      secondary: AppColors.bluePanel,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
      dividerColor: scheme.outlineVariant.withOpacity(0.4),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.r14),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.orange),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.r14),
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    // 🔥 Statistik-Look: dunkel, leicht bläulich, Orange-Akzent
    const bg = Color(0xFF0B0F14);
    const surface = Color(0xFF111821);
    const surface2 = Color(0xFF141D27);

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.orange,
      secondary: AppColors.bluePanel,
      surface: surface,
      background: bg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: scheme.outlineVariant.withOpacity(0.35),

      // nicer default texts
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: scheme.onSurface,
            displayColor: scheme.onSurface,
          ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.r14),
          borderSide: BorderSide.none,
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.orange.withOpacity(0.22);
            }
            return surface2;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) return Colors.white;
            return Colors.white.withOpacity(0.80);
          }),
          side: MaterialStateProperty.all(
            BorderSide(color: scheme.outlineVariant.withOpacity(0.35)),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.r14),
            ),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.orange),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.r14),
            ),
          ),
        ),
      ),
    );
  }
}
