import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Sidebar
import 'widgets/sidebar.dart';

// Seiten
import 'seiten/dashboard.dart';
import 'seiten/kunden.dart';
import 'seiten/mitarbeiter.dart';
import 'seiten/einstellung.dart'; // 👈 NEU

// Controller + Infrastruktur
import 'controllers/anmeldung_controller.dart';
import 'controllers/terminplan_controller.dart';
import 'controllers/notizen_controller.dart';
import 'repositories/terminquelle.dart';
import 'repositories/mock_terminquelle.dart';
import 'services/terminplan_service.dart';

void main() {
  runApp(const FriseurOrangeApp());
}

class FriseurOrangeApp extends StatelessWidget {
  const FriseurOrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Terminquelle quelle = MockTerminquelle();
    final dienst = TerminplanService(quelle: quelle);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnmeldungController()..lade()),
        ChangeNotifierProvider(create: (_) => TerminplanController(dienst)),
        ChangeNotifierProvider(create: (_) => NotizenController()),
      ],
      child: const MaterialApp(
        title: 'Friseur Orange',
        debugShowCheckedModeBanner: false,
        home: Startseite(),
      ),
    );
  }
}

class Startseite extends StatefulWidget {
  const Startseite({super.key});

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  int ausgewaehlterIndex = 0; // 0 = Dashboard
  final String benutzername = "Eren"; // Fallback, falls noch kein gespeicherter Name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            ausgewaehlterIndex: ausgewaehlterIndex,
            beimAuswaehlen: (index) => setState(() => ausgewaehlterIndex = index),
          ),
          Expanded(child: _seiteFuerIndex(ausgewaehlterIndex)),
        ],
      ),
    );
  }

  /// Zentrale Stelle: welche Seite wird angezeigt?
  Widget _seiteFuerIndex(int index) {
    switch (index) {
      case 0:
        return DashboardPage(benutzername: benutzername);
      case 1:
        return const KundenSeite();
      case 2:
        return MitarbeiterSeite(benutzernameFallback: benutzername);
      case 3:
        return const Center(child: Text("Terminübersicht"));
      case 4:
        return const Center(child: Text("Statistik"));
      case 5:
        return const EinstellungSeite(); // 👈 NEU
      default:
        return const Center(child: Text("Unbekannt"));
    }
  }
}
