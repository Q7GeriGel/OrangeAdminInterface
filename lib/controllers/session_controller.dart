import 'package:flutter/foundation.dart';

class SessionController extends ChangeNotifier {
  String? _loggedInUser;
  bool _isAdmin = false;
  String? _activeUser;

  bool get isLoggedIn => _loggedInUser != null;
  bool get isAdmin => _isAdmin;

  String get loggedInUser => _loggedInUser ?? '';
  String get activeUser => (_activeUser ?? _loggedInUser ?? '').trim();

  void login({required String username, required bool isAdmin}) {
    _loggedInUser = username.trim();
    _isAdmin = isAdmin;
    _activeUser = _loggedInUser; // Default: man sieht sich selbst
    notifyListeners();
  }

  void logout() {
    _loggedInUser = null;
    _activeUser = null;
    _isAdmin = false;
    notifyListeners();
  }

  void setActiveUser(String username) {
    final u = username.trim();
    if (u.isEmpty) return;

    // Nur Admin darf "umschalten"
    _activeUser = _isAdmin ? u : _loggedInUser;
    notifyListeners();
  }
}
