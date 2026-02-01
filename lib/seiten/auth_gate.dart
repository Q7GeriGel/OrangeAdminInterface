import 'package:flutter/material.dart';
import 'startseite.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Fake-"Datenbank" im Speicher – KEY = Benutzername
  final Map<String, String> _users = {
    'admin': '123456', // Testuser: Benutzername = admin, Passwort = 123456
  };

  bool _isLogin = true; // true = Login, false = Registrieren

  final _benutzernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String? _infoText;           // <-- gemeinsame Message (Fehler ODER Erfolg)
  bool _infoIsError = false;   // <-- steuert die Farbe

  void _submit() {
    final benutzername = _benutzernameCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (benutzername.isEmpty || password.isEmpty) {
      setState(() {
        _infoText = 'Bitte Benutzername und Passwort eingeben.';
        _infoIsError = true;
      });
      return;
    }

    if (_isLogin) {
      _handleLogin(benutzername, password);
    } else {
      _handleRegister(benutzername, password);
    }
  }

  void _handleLogin(String benutzername, String password) {
    final savedPw = _users[benutzername];

    if (savedPw == null || savedPw != password) {
      setState(() {
        _infoText = 'Falscher Benutzername oder falsches Passwort.';
        _infoIsError = true;
      });
      return;
    }

    // ✅ Erfolg → weiter in Startseite (Sidebar + Dashboard)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Startseite(benutzername: benutzername),
      ),
    );
  }

  void _handleRegister(String benutzername, String password) {
    if (_users.containsKey(benutzername)) {
      setState(() {
        _infoText = 'Dieser Benutzername ist bereits vergeben.';
        _infoIsError = true;
      });
      return;
    }

    // "Speichern" in der Fake-Map
    _users[benutzername] = password;

    // TODO: später hier echten API-Call / DB-Speicherung einbauen

    // ✅ Erfolgs-Message in GRÜN anzeigen + auf Login wechseln
    setState(() {
      _isLogin = true;
      _infoText = 'Registrierung erfolgreich. Du kannst dich jetzt einloggen.';
      _infoIsError = false; // <-- wichtig: Erfolg = nicht rot
      _passwordCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Friseur Orange Admin',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Melde dich an, um fortzufahren.'
                          : 'Erstelle einen neuen Account.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Login / Registrieren Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text('Login'),
                          selected: _isLogin,
                          onSelected: (_) => setState(() {
                            _isLogin = true;
                            _infoText = null;
                          }),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Registrieren'),
                          selected: !_isLogin,
                          onSelected: (_) => setState(() {
                            _isLogin = false;
                            _infoText = null;
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _benutzernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Benutzername',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Passwort',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),

                    if (_infoText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _infoText!,
                        style: TextStyle(
                          color: _infoIsError ? Colors.red : Colors.green,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(_isLogin ? 'Anmelden' : 'Registrieren'),
                      ),
                    ),

                    // Kein "Noch kein Account..."-Button mehr
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
