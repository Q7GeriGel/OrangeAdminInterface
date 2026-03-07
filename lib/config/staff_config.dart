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

  static Color colorOf(String name) {
    final n = name.trim();
    return _colors[n] ?? _colors[defaultEmployee]!;
  }

  static bool isValid(String name) => employees.contains(name.trim());
}