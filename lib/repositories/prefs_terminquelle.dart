import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/staff_config.dart';
import '../models/termin.dart';
import 'terminquelle.dart';

class PrefsTerminquelle implements Terminquelle {
  PrefsTerminquelle({this.seedDemoData = true});

  final bool seedDemoData;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const _seedKey = 'fo_termine_seeded_v1';

  DateTime _mondayOf(DateTime d) {
    final x = DateTime(d.year, d.month, d.day);
    return x.subtract(Duration(days: x.weekday - DateTime.monday));
  }

  String _weekKey(DateTime monday) {
    final m = _mondayOf(monday);
    final y = m.year.toString();
    final mo = m.month.toString().padLeft(2, '0');
    final da = m.day.toString().padLeft(2, '0');
    return 'fo_termine_week_$y$mo$da';
  }

  DateTime _d(DateTime monday, int dayIndex, int h, int m) {
    final base = monday.add(Duration(days: dayIndex));
    return DateTime(base.year, base.month, base.day, h, m);
  }

  Future<void> _maybeSeed(DateTime monday) async {
    if (!seedDemoData) return;

    final sp = await _prefs;
    final seeded = sp.getBool(_seedKey) ?? false;
    if (seeded) return;

    // Seed nur in "dieser Woche", und nur wenn noch nix gespeichert ist
    final nowMon = _mondayOf(DateTime.now());
    if (_mondayOf(monday) != nowMon) return;

    final k = _weekKey(nowMon);
    if (sp.getString(k) != null) {
      await sp.setBool(_seedKey, true);
      return;
    }

    final list = <Termin>[
      Termin(
        id: 'seed_${k}_1',
        start: _d(nowMon, 0, 9, 0),
        end: _d(nowMon, 0, 9, 30),
        kundeName: 'Refik Erdogan',
        mitarbeiterName: StaffConfig.employees[0],
        status: Termin.statusBestaetigt,
        service: 'Haarschnitt',
        price: 25,
        color: StaffConfig.colorOf(StaffConfig.employees[0]),
      ),
      Termin(
        id: 'seed_${k}_2',
        start: _d(nowMon, 0, 10, 0),
        end: _d(nowMon, 0, 10, 30),
        kundeName: 'Ali',
        mitarbeiterName: StaffConfig.employees[1],
        status: Termin.statusOffen,
        service: 'Bart',
        price: 20,
        color: StaffConfig.colorOf(StaffConfig.employees[1]),
      ),
    ];

    await sp.setString(k, jsonEncode(list.map((e) => e.toJson()).toList()));
    await sp.setBool(_seedKey, true);
  }

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    final m = _mondayOf(monday);
    await _maybeSeed(m);

    final sp = await _prefs;
    final raw = sp.getString(_weekKey(m));
    if (raw == null || raw.trim().isEmpty) return [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];

    final list = decoded
        .whereType<Map>()
        .map((e) => Termin.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    // Safety: nur 3 Mitarbeiter (falls alte Daten drin waren)
    return list
        .where((t) => StaffConfig.isValid(t.mitarbeiterName))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    final m = _mondayOf(monday);
    final sp = await _prefs;

    final cleaned = termine
        .where((t) => StaffConfig.isValid(t.mitarbeiterName))
        .map((e) => e.toJson())
        .toList();

    await sp.setString(_weekKey(m), jsonEncode(cleaned));
  }
}