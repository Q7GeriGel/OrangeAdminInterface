import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import 'dashboard.dart';
import 'kunden.dart';
import 'mitarbeiter.dart';
import 'einstellung.dart';
import 'termine_wochenansicht.dart';
import 'statistik.dart';

class Startseite extends StatefulWidget {
  final String benutzername;

  const Startseite({super.key, required this.benutzername});

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  int ausgewaehlterIndex = 0;

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
        return DashboardPage(benutzername: widget.benutzername);
      case 1:
        return const KundenSeite();
      case 2:
        return MitarbeiterSeite(benutzername: widget.benutzername);
      case 3:
        return const TermineWochenansicht();
      case 4:
        return const StatistikSeite();
      case 5:
        return const EinstellungSeite();
      default:
        return const Center(child: Text("Unbekannt"));
    }
  }
}
