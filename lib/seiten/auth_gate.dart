import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import 'startseite.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;

  /// username (immer klein) -> userinfo
  final Map<String, _UserInfo> _users = {
    'serkan': const _UserInfo(password: '123', isAdmin: false, displayName: 'serkan'),
    'sedat': const _UserInfo(password: '123', isAdmin: true, displayName: 'sedat'),
    'samet': const _UserInfo(password: '123', isAdmin: false, displayName: 'samet'),
  };

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String _t(AppLocalizations? l10n, String fallback, String Function(AppLocalizations l) pick) {
    // falls ARB-Keys noch fehlen -> fallback nutzen
    if (l10n == null) return fallback;
    try {
      return pick(l10n);
    } catch (_) {
      return fallback;
    }
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);

    final username = _userCtrl.text.trim().toLowerCase();
    final password = _passCtrl.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(l10n, 'Bitte Benutzername und Passwort eingeben.', (l) => l.emptyCredentials),
          ),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final info = _users[username];

      if (info == null || info.password != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(l10n, 'Falsche Zugangsdaten.', (l) => l.wrongCredentials),
            ),
          ),
        );
        return;
      }

      if (!mounted) return;

      // ✅ KEIN isAdmin übergeben -> keine Fehler mehr in Startseite
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Startseite(benutzername: info.displayName),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = _t(l10n, 'Friseur Orange', (l) => l.appTitle);
    final usernameText = _t(l10n, 'Benutzername', (l) => l.username);
    final passwordText = _t(l10n, 'Passwort', (l) => l.password);
    final signInText = _t(l10n, 'Einloggen', (l) => l.signIn);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF121826),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(60, 0, 0, 0),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _userCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: usernameText,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF0F131B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: passwordText,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF0F131B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC95B4C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            signInText,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Zulässige Accounts: serkan / sedat / samet (Passwort: 123)',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfo {
  final String password;
  final bool isAdmin; // für später (Rechte)
  final String displayName;

  const _UserInfo({
    required this.password,
    required this.isAdmin,
    required this.displayName,
  });
}
