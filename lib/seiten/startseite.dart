import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/sidebar.dart';
import 'auth_gate.dart';
import 'dashboard.dart';
import 'kunden.dart';
import 'mitarbeiter.dart';
import 'einstellung.dart';
import 'termine_wochenansicht.dart';
import 'statistik.dart';

class Startseite extends StatefulWidget {
  final String benutzername;
  final bool isAdmin;

  const Startseite({
    super.key,
    required this.benutzername,
    this.isAdmin = false,
  });

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  int ausgewaehlterIndex = 0;

  // ✅ das ist der "aktive" Mitarbeiter (für Ansicht/Statistik/Notizen etc.)
  late String _aktiverAccount;

  @override
  void initState() {
    super.initState();
    _aktiverAccount = widget.benutzername;
  }

  void _setAccount(String name) {
    setState(() => _aktiverAccount = name);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ safe cleanup (egal welche keys du vorher genutzt hast)
    await prefs.remove('username');
    await prefs.remove('benutzername');
    await prefs.remove('isAdmin');
    await prefs.remove('loggedIn');
    await prefs.remove('loggedInUser');

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            ausgewaehlterIndex: ausgewaehlterIndex,
            beimAuswaehlen: (index) => setState(() => ausgewaehlterIndex = index),

            // ✅ für Hesap / Toggle
            isAdmin: widget.isAdmin,
            aktiverAccount: _aktiverAccount,
            onAccountChanged: _setAccount,

            // ✅ Logout wieder da + echt
            onLogout: _logout,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) {
                final slide = Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(anim);

                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(ausgewaehlterIndex),
                child: _seiteFuerIndex(ausgewaehlterIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seiteFuerIndex(int index) {
    switch (index) {
      case 0:
        return DashboardPage(benutzername: _aktiverAccount);

      case 1:
        return const KundenSeite();

      case 2:
        return MitarbeiterSeite(
          benutzername: _aktiverAccount,
          isAdmin: widget.isAdmin,
          aktiverAccount: _aktiverAccount,
          onAccountChanged: _setAccount,
        );

      case 3:
        // ✅ HIER war dein Fehler -> jetzt wird isAdmin übergeben
        return TermineWochenansicht(isAdmin: widget.isAdmin);

      case 4:
        return StatistikSeite(
          angemeldeterName: _aktiverAccount,
          isAdmin: widget.isAdmin,
        );

      case 5:
        return const EinstellungSeite();

      default:
        return const Center(child: Text("Unbekannt"));
    }
  }
}
