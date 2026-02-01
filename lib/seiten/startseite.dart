import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import 'dashboard.dart';
import 'kunden.dart';
import 'mitarbeiter.dart';
import 'einstellung.dart';
import 'termine_wochenansicht.dart';

class Startseite extends StatefulWidget {
  final String benutzername;

  const Startseite({super.key, required this.benutzername});

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  int ausgewaehlterIndex = 0; // 0 = Dashboard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            ausgewaehlterIndex: ausgewaehlterIndex,
            beimAuswaehlen: (index) => setState(() => ausgewaehlterIndex = index),
          ),
          Expanded(
            child: _seiteFuerIndex(ausgewaehlterIndex),
          ),
        ],
      ),
    );
  }

  /// Zentrale Stelle: welche Seite wird angezeigt?
  Widget _seiteFuerIndex(int index) {
    switch (index) {
      case 0:
        return DashboardPage(benutzername: widget.benutzername);
      case 1:
        return const KundenSeite();
      case 2:
        return MitarbeiterSeite(
          benutzernameFallback: widget.benutzername,
        );
      case 3:
        return const TermineWochenansicht();
      case 4:
        return const Center(child: Text("Statistik"));
      case 5:
        return const EinstellungSeite();
      default:
        return const Center(child: Text("Unbekannt"));
    }
  }
}
