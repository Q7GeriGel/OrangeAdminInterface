import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import 'widgets/theme/app_theme.dart';
import 'seiten/auth_gate.dart';

// Controller / Service / Repo
import 'controllers/app_settings_controller.dart';
import 'controllers/terminplan_controller.dart';
import 'services/terminplan_service.dart';
import 'repositories/terminplan_repository.dart';

// ✅ WICHTIG: Terminquelle-Typ kommt von hier
import 'repositories/terminquelle.dart';
import 'models/termin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FriseurOrangeApp());
}

/// ✅ Simple Mock-Datenquelle (RAM) – ersetzt später DB/REST/Prefs
class InMemoryTerminquelle implements Terminquelle {
  final Map<String, List<Termin>> _store = {};

  String _key(DateTime monday) => '${monday.year}-${monday.month}-${monday.day}';

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    // mutable copy zurückgeben (weil Service list.add / sort macht)
    return List<Termin>.from(_store[_key(monday)] ?? const []);
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    // copy speichern
    _store[_key(monday)] = List<Termin>.from(termine);
  }
}

class FriseurOrangeApp extends StatelessWidget {
  const FriseurOrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ Settings global
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController(),
        ),

        // ✅ Terminquelle (Mock)
        Provider<Terminquelle>(
          create: (_) => InMemoryTerminquelle(),
        ),

        // ✅ Service bekommt Terminquelle
        Provider<TerminplanService>(
          create: (ctx) => TerminplanService(
            quelle: ctx.read<Terminquelle>(),
          ),
        ),

        // ✅ Repo (falls irgendwo im UI direkt benutzt)
        Provider<TerminplanRepository>(
          create: (ctx) => TerminplanRepository(
            ctx.read<TerminplanService>(),
          ),
        ),

        // ✅ Controller braucht 1 positional Argument (Service)
        ChangeNotifierProvider<TerminplanController>(
          create: (ctx) => TerminplanController(
            ctx.read<TerminplanService>(),
          ),
        ),
      ],
      child: Consumer<AppSettingsController>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            locale: settings.locale,

            // ✅ L10n
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
