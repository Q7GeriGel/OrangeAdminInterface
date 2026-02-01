import 'package:flutter/material.dart';
import '../models/termin.dart';
import '../models/zeitfenster.dart';
import '../services/terminplan_service.dart';

class TerminplanController extends ChangeNotifier {
  final TerminplanService service;

  TerminplanController(this.service) {
    _currentWeekMonday = _startOfWeekMonday(DateTime.now());
    _tag = DateTime.now();
  }

  // ============================
  //   WOCHE (Mo–Sa)
  // ============================

  late DateTime _currentWeekMonday;
  bool _loadingWeek = false;
  List<Termin> _termine = [];

  DateTime get currentWeekMonday => _currentWeekMonday;
  bool get loading => _loadingWeek;
  List<Termin> get termine => List.unmodifiable(_termine);

  DateTime _startOfWeekMonday(DateTime d) {
    final offset = d.weekday - 1; // Montag = 1 -> 0 Offset
    final monday = DateTime(d.year, d.month, d.day).subtract(Duration(days: offset));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Lädt Termine für eine Woche (Dummy oder später API)
  Future<void> loadWeek([DateTime? monday, bool withDummy = true]) async {
    _loadingWeek = true;
    notifyListeners();

    if (monday != null) _currentWeekMonday = monday;

    // TODO: später echte Termine aus Repository laden
    _termine = withDummy ? _demoAppointments(_currentWeekMonday) : [];

    _loadingWeek = false;
    notifyListeners();
  }

  Future<void> prevWeek() =>
      loadWeek(_currentWeekMonday.subtract(const Duration(days: 7)));

  Future<void> nextWeek() =>
      loadWeek(_currentWeekMonday.add(const Duration(days: 7)));

  Future<void> goToday() =>
      loadWeek(_startOfWeekMonday(DateTime.now()));

  // ============================
  //   TAGESANSICHT / FREIE SLOTS
  // ============================

  late DateTime _tag;
  bool _lade = false;
  List<Zeitfenster> _freie = [];

  DateTime get tag => _tag;
  bool get lade => _lade;
  List<Zeitfenster> get freie => List.unmodifiable(_freie);

  /// Lädt freie Zeitfenster für den gewählten Tag
  Future<void> aktualisiere([DateTime? neuerTag]) async {
    if (neuerTag != null) {
      _tag = DateTime(neuerTag.year, neuerTag.month, neuerTag.day);
    }

    _lade = true;
    notifyListeners();

    try {
      _freie = await service.freieSlots(_tag);
    } finally {
      _lade = false;
      notifyListeners();
    }
  }

  // ============================
  //   TERMIN-AKTIONEN
  // ============================

  void createTerminAt(
    DateTime start, {
    String kunde = 'Neuer Kunde',
    String mitarbeiter = 'Aylin',
    int dauerMin = 30,
  }) {
    final termin = Termin(
      id: UniqueKey().toString(),
      start: _roundTo30(start),
      end: _roundTo30(start).add(Duration(minutes: dauerMin)),
      kundeName: kunde,
      mitarbeiterName: mitarbeiter,
      status: 'Offen',
      service: 'Haarschnitt',
      // price entfernt aus UI; Feld bleibt im Model optional
      color: Colors.teal,
    );
    _termine = [..._termine, termin];
    notifyListeners();
  }

  void moveTermin(String id, DateTime newStart) {
    final index = _termine.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final alt = _termine[index];
    final rounded = _roundTo30(newStart);
    final neu = alt.copyWith(
      start: rounded,
      end: rounded.add(alt.end.difference(alt.start)),
    );
    _termine = [..._termine]..[index] = neu;
    notifyListeners();
  }

  /// Dauer in Minuten (nur 30 oder 60 werden unterstützt).
  void updateDuration(String id, int minutes) {
    if (minutes != 30 && minutes != 60) return;
    final index = _termine.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final alt = _termine[index];
    final neu = alt.copyWith(
      end: alt.start.add(Duration(minutes: minutes)),
    );
    _termine = [..._termine]..[index] = neu;
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _termine.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final alt = _termine[index];
    final nextStatus = alt.status == 'Offen' ? 'Bestätigt' : 'Offen';
    _termine = [..._termine]..[index] = alt.copyWith(status: nextStatus);
    notifyListeners();
  }

  void cancelTermin(String id) {
    final index = _termine.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final alt = _termine[index];
    _termine = [..._termine]..[index] = alt.copyWith(status: 'Abgesagt');
    notifyListeners();
  }

  void deleteTermin(String id) {
    _termine = _termine.where((t) => t.id != id).toList(growable: false);
    notifyListeners();
  }

  // 30-Minuten-Rundung (nach unten auf 00/30)
  DateTime _roundTo30(DateTime dt) {
    final mm = dt.minute;
    final roundedMin = (mm < 30) ? 0 : 30;
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMin);
  }
}

// ============================
//   DUMMY-DATEN (Demo)
// ============================

List<Termin> _demoAppointments(DateTime monday) {
  DateTime d(int weekdayOffset, int h, [int m = 0]) =>
      DateTime(monday.year, monday.month, monday.day + weekdayOffset, h, m);

  return [
    Termin(
      id: 'a1',
      start: d(0, 9),
      end: d(0, 9, 30),
      kundeName: 'F. Kaya',
      mitarbeiterName: 'Aylin',
      status: 'Bestätigt',
      service: 'Herrenhaarschnitt',
      color: Colors.teal,
    ),
    Termin(
      id: 'a2',
      start: d(1, 10, 30),
      end: d(1, 11, 30), // 60 min
      kundeName: 'R. Yılmaz',
      mitarbeiterName: 'Kaan',
      status: 'Offen',
      service: 'Färben + Schnitt',
      color: Colors.orange,
    ),
    Termin(
      id: 'a3',
      start: d(2, 8),
      end: d(2, 8, 30),
      kundeName: 'L. Demir',
      mitarbeiterName: 'Aylin',
      status: 'Bestätigt',
      service: 'Barttrimmen',
      color: Colors.blue,
    ),
  ];
}
