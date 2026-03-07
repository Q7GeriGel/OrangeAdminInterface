import 'package:flutter/material.dart';

class StaffConfig {
  /// ✅ EINZIGE 3 Mitarbeiter im System
  static const List<String> employees = ['Serkan', 'Sedat', 'Samet'];

  static const String defaultEmployee = 'Serkan';

  static const Map<String, Color> _colors = {
    'Serkan': Color(0xFFCC5C4C),
    'Sedat': Color(0xFF2E7D32),
    'Samet': Color(0xFF335776),
  };

  static String normalizeEmployee(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return defaultEmployee;

    final normalized =
        trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();

    return employees.contains(normalized) ? normalized : defaultEmployee;
  }

  static Color colorOf(String name) {
    final normalized = normalizeEmployee(name);
    return _colors[normalized] ?? _colors[defaultEmployee]!;
  }

  static bool isValid(String name) {
    final normalized = normalizeEmployee(name);
    return employees.contains(normalized);
  }
}