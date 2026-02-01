import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'controllers/anmeldung_controller.dart';
import 'controllers/notizen_controller.dart';
import 'controllers/terminplan_controller.dart';

import 'repositories/terminquelle.dart';
import 'repositories/mock_terminquelle.dart';
import 'services/terminplan_service.dart';

import 'seiten/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'de_DE';
  await initializeDateFormatting('de_DE', null);
  await initializeDateFormatting('tr_TR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Terminquelle>(create: (_) => MockTerminquelle()),
        Provider<TerminplanService>(
          create: (ctx) => TerminplanService(quelle: ctx.read<Terminquelle>()),
        ),
        ChangeNotifierProvider<TerminplanController>(
          create: (ctx) => TerminplanController(ctx.read<TerminplanService>()),
        ),

        ChangeNotifierProvider(create: (_) => AnmeldungController()),
        ChangeNotifierProvider(create: (_) => NotizenController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        locale: const Locale('de', 'DE'),
        supportedLocales: const [
          Locale('de', 'DE'),
          Locale('tr', 'TR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFCC5C4C),
        ),

        home: const AuthGate(),
      ),
    );
  }
}
