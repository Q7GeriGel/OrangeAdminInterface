import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Seiten
import 'seiten/auth_gate.dart';

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

    
    final dienst = TerminplanService(
      quelle: quelle,
      minutenProSlot: 30,
      startStunde: 8,
      endStunde: 20,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnmeldungController()..lade()),
        ChangeNotifierProvider(
          create: (_) => TerminplanController(dienst)..loadWeek(),
        ),
        ChangeNotifierProvider(create: (_) => NotizenController()),
      ],
      child: MaterialApp(
        title: 'Friseur Orange',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
        ),

        
        home: const AuthGate(),
      ),
    );
  }
}
