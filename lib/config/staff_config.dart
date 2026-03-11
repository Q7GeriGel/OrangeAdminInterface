import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser {
  final String username;
  final String password;
  final bool isAdmin;

  const LoginUser({
    required this.username,
    required this.password,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'isAdmin': isAdmin,
      };

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      username: (json['username'] ?? '').toString().trim().toLowerCase(),
      password: (json['password'] ?? '').toString(),
      isAdmin: json['isAdmin'] == true,
    );
  }
}

class StaffConfig {
  static const List<String> employees = ['Serkan', 'Sedat', 'Samet'];
  static const String defaultEmployee = 'Serkan';

  static const String _usersKey = 'fo_login_users_v2';

  static const Map<String, Color> _seedColors = {
    'Serkan': Color(0xFFCC5C4C),
    'Sedat': Color(0xFF2E7D32),
    'Samet': Color(0xFF335776),
  };

  static const List<Color> _dynamicPalette = [
    Color(0xFF6E61A8),
    Color(0xFF2E7DDB),
    Color(0xFF00897B),
    Color(0xFF8E24AA),
    Color(0xFF5D4037),
    Color(0xFF3949AB),
    Color(0xFF546E7A),
    Color(0xFFEF6C00),
  ];

  static List<String> _extraEmployees = [];
  static List<LoginUser> _cachedUsers = [];
  static bool _initialized = false;

  static List<String> get allEmployees => [
        ...employees,
        ..._extraEmployees.where((e) => !employees.contains(e)),
      ];

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    await _loadFromPrefs();
    _initialized = true;
  }

  static Future<void> reload() async {
    _initialized = false;
    _extraEmployees = [];
    _cachedUsers = [];
    await ensureInitialized();
  }

  static Future<List<LoginUser>> loadUsers() async {
    await ensureInitialized();
    return List<LoginUser>.from(_cachedUsers);
  }

  static Future<LoginUser?> findUser(String username) async {
    await ensureInitialized();
    final clean = username.trim().toLowerCase();
    try {
      return _cachedUsers.firstWhere((u) => u.username == clean);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> createEmployee({
    required String username,
    required String password,
  }) async {
    await ensureInitialized();

    final cleanUsername = username.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty) {
      return 'Bitte Benutzername eingeben.';
    }

    if (cleanPassword.isEmpty) {
      return 'Bitte Passwort eingeben.';
    }

    if (!RegExp(r'^[a-z0-9._-]+$').hasMatch(cleanUsername)) {
      return 'Benutzername darf nur Kleinbuchstaben, Zahlen, Punkt, Minus oder Unterstrich enthalten.';
    }

    final exists = _cachedUsers.any((u) => u.username == cleanUsername);
    if (exists) {
      return 'Benutzername existiert bereits.';
    }

    final newUser = LoginUser(
      username: cleanUsername,
      password: cleanPassword,
      isAdmin: false,
    );

    _cachedUsers = [..._cachedUsers, newUser];

    final canonicalName = _toEmployeeName(cleanUsername);
    if (!employees.contains(canonicalName) &&
        !_extraEmployees.contains(canonicalName)) {
      _extraEmployees = [..._extraEmployees, canonicalName];
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(_cachedUsers.map((u) => u.toJson()).toList()),
    );

    return null;
  }

  static Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);

    List<LoginUser> users;

    if (raw == null || raw.trim().isEmpty) {
      users = _seedUsers();
      await prefs.setString(
        _usersKey,
        jsonEncode(users.map((u) => u.toJson()).toList()),
      );
    } else {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          users = decoded
              .whereType<Map>()
              .map((e) => LoginUser.fromJson(Map<String, dynamic>.from(e)))
              .where((u) => u.username.isNotEmpty)
              .toList();
        } else {
          users = _seedUsers();
        }
      } catch (_) {
        users = _seedUsers();
      }

      if (users.isEmpty) {
        users = _seedUsers();
        await prefs.setString(
          _usersKey,
          jsonEncode(users.map((u) => u.toJson()).toList()),
        );
      }
    }

    _cachedUsers = users;

    final canonical = users
        .map((u) => _toEmployeeName(u.username))
        .where((name) => !employees.contains(name))
        .toSet()
        .toList()
      ..sort();

    _extraEmployees = canonical;
  }

  static List<LoginUser> _seedUsers() {
    return const [
      LoginUser(username: 'serkan', password: '123', isAdmin: false),
      LoginUser(username: 'sedat', password: '123', isAdmin: true),
      LoginUser(username: 'samet', password: '123', isAdmin: false),
    ];
  }

  static String _toEmployeeName(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return defaultEmployee;
    return clean[0].toUpperCase() + clean.substring(1).toLowerCase();
  }

  static String normalizeEmployee(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return defaultEmployee;

    final normalized = _toEmployeeName(trimmed);
    return allEmployees.contains(normalized) ? normalized : defaultEmployee;
  }

  static Color colorOf(String name) {
    final normalized = normalizeEmployee(name);
    if (_seedColors.containsKey(normalized)) {
      return _seedColors[normalized]!;
    }

    final hash = normalized.runes.fold<int>(0, (sum, rune) => sum + rune);
    return _dynamicPalette[hash % _dynamicPalette.length];
  }

  static bool isValid(String name) {
    final normalized = normalizeEmployee(name);
    return allEmployees.contains(normalized);
  }
}