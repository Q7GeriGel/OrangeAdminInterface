import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/gen/app_localizations.dart';

import 'controllers/app_settings_controller.dart';
import 'controllers/session_controller.dart';
import 'controllers/kunden_verwaltung.dart';
import 'controllers/terminplan_controller.dart';

import 'repositories/terminquelle.dart';
import 'repositories/prefs_terminquelle.dart';
import 'services/terminplan_service.dart';
import 'repositories/terminplan_repository.dart';

import 'widgets/theme/app_theme.dart';
import 'seiten/auth_gate.dart';
import 'config/staff_config.dart';
import 'models/termin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StaffConfig.ensureInitialized();
  runApp(const FriseurOrangeApp());
}

const bool usePrefsStorage = true;

class FriseurOrangeApp extends StatelessWidget {
  const FriseurOrangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController()..load(),
        ),
        ChangeNotifierProvider<SessionController>(
          create: (_) => SessionController(),
        ),
        ChangeNotifierProvider<KundenVerwaltung>(
          create: (_) {
            final v = KundenVerwaltung();
            v.init();
            return v;
          },
        ),
        Provider<Terminquelle>(
          create: (_) => usePrefsStorage
              ? PrefsTerminquelle(seedDemoData: true)
              : InMemoryTerminquelle(),
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
            routes: {
              '/login': (_) => const AuthGate(),
            },
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class InMemoryTerminquelle implements Terminquelle {
  final Map<String, List<Termin>> _store = {};

  String _key(DateTime monday) =>
      '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';

  DateTime _mondayOf(DateTime d) {
    final x = DateTime(d.year, d.month, d.day);
    return x.subtract(Duration(days: x.weekday - DateTime.monday));
  }

  DateTime _d(DateTime monday, int dayIndex, int h, int m) {
    final base = monday.add(Duration(days: dayIndex));
    return DateTime(base.year, base.month, base.day, h, m);
  }

  void _seedWeek(DateTime monday) {
    final m = _mondayOf(monday);
    final k = _key(m);
    if (_store.containsKey(k)) return;

    final employees = StaffConfig.allEmployees;

    final list = <Termin>[
      Termin(
        id: 'seed_${k}_1',
        start: _d(m, 0, 9, 0),
        end: _d(m, 0, 9, 30),
        kundeName: 'Refik Erdogan',
        mitarbeiterName:
            employees.isNotEmpty ? employees[0] : StaffConfig.defaultEmployee,
        status: Termin.statusBestaetigt,
        service: 'Haarschnitt',
        price: 25,
        color: StaffConfig.colorOf(
          employees.isNotEmpty ? employees[0] : StaffConfig.defaultEmployee,
        ),
      ),
      Termin(
        id: 'seed_${k}_2',
        start: _d(m, 0, 10, 0),
        end: _d(m, 0, 10, 30),
        kundeName: 'Ali',
        mitarbeiterName:
            employees.length > 1 ? employees[1] : StaffConfig.defaultEmployee,
        status: Termin.statusOffen,
        service: 'Bart',
        price: 20,
        color: StaffConfig.colorOf(
          employees.length > 1 ? employees[1] : StaffConfig.defaultEmployee,
        ),
      ),
    ];

    list.sort((a, b) => a.start.compareTo(b.start));
    _store[k] = list;
  }

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    final m = _mondayOf(monday);
    _seedWeek(m);
    return List<Termin>.from(_store[_key(m)] ?? const []);
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    final m = _mondayOf(monday);
    _store[_key(m)] = List<Termin>.from(termine);
  }
}