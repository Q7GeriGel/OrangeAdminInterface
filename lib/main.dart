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

import 'repositories/terminquelle.dart';
import 'models/termin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FriseurOrangeApp());
}

/// ✅ Simple Mock-Datenquelle (RAM) – ersetzt später DB/REST/Prefs
/// -> erzeugt automatisch Demo-Termine, damit man sofort was sieht
class InMemoryTerminquelle implements Terminquelle {
  final Map<String, List<Termin>> _store = {};

  String _key(DateTime monday) => '${monday.year}-${monday.month}-${monday.day}';

  bool _seeded(DateTime monday) => _store.containsKey(_key(monday));

  void _seedWeek(DateTime monday) {
    if (_seeded(monday)) return;

    final list = <Termin>[];
    DateTime d(int weekday, int hour, int minute) {
      final day = monday.add(Duration(days: weekday));
      return DateTime(day.year, day.month, day.day, hour, minute);
    }

    // ✅ Serkan
    list.addAll([
      Termin(
        id: 's1',
        start: d(0, 10, 0),
        end: d(0, 10, 30),
        kundeName: 'Ahmet',
        mitarbeiterName: 'Serkan',
        status: Termin.statusBestaetigt,
        service: 'Haarschnitt',
        price: 25,
        color: const Color(0xFFC95B4C),
      ),
      Termin(
        id: 's2',
        start: d(2, 12, 0),
        end: d(2, 12, 45),
        kundeName: 'Mehmet',
        mitarbeiterName: 'Serkan',
        status: Termin.statusOffen,
        service: 'Bart',
        price: 15,
        color: const Color(0xFFC95B4C),
      ),
    ]);

    // ✅ Samet
    list.addAll([
      Termin(
        id: 'm1',
        start: d(1, 9, 0),
        end: d(1, 9, 30),
        kundeName: 'Yusuf',
        mitarbeiterName: 'Samet',
        status: Termin.statusBestaetigt,
        service: 'Haarschnitt',
        price: 25,
        color: const Color(0xFF3A6EA5),
      ),
      Termin(
        id: 'm2',
        start: d(4, 15, 0),
        end: d(4, 16, 0),
        kundeName: 'Emir',
        mitarbeiterName: 'Samet',
        status: Termin.statusOffen,
        service: 'Farbe',
        price: 45,
        color: const Color(0xFF3A6EA5),
      ),
    ]);

    // ✅ Sedat (Admin)
    list.addAll([
      Termin(
        id: 'a1',
        start: d(3, 11, 0),
        end: d(3, 11, 30),
        kundeName: 'Ali',
        mitarbeiterName: 'Sedad',
        status: Termin.statusBestaetigt,
        service: 'Haarschnitt',
        price: 25,
        color: const Color(0xFF2E7D32),
      ),
    ]);

    list.sort((a, b) => a.start.compareTo(b.start));
    _store[_key(monday)] = list;
  }

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    _seedWeek(monday);
    return List<Termin>.from(_store[_key(monday)] ?? const []);
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    _store[_key(monday)] = List<Termin>.from(termine);
  }
}

class FriseurOrangeApp extends StatelessWidget {
  const FriseurOrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController()..load(),
        ),

        Provider<Terminquelle>(
          create: (_) => InMemoryTerminquelle(),
        ),

        Provider<TerminplanService>(
          create: (ctx) => TerminplanService(
            quelle: ctx.read<Terminquelle>(),
          ),
        ),

        Provider<TerminplanRepository>(
          create: (ctx) => TerminplanRepository(
            ctx.read<TerminplanService>(),
          ),
        ),

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
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
