import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/termin.dart';
import '../services/terminplan_service.dart';

class FreiesZeitfenster {
  final DateTime start;
  final DateTime end;

  FreiesZeitfenster(this.start, this.end);

  String get beschriftung =>
      '${DateFormat('HH:mm').format(start)} – ${DateFormat('HH:mm').format(end)}';
}

class TerminplanController extends ChangeNotifier {
  final TerminplanService service;

  TerminplanController(this.service) {
    goToday();
  }

  // Woche
  DateTime currentWeekMonday = DateTime.now();
  bool loading = false;
  List<Termin> termine = [];

  // Dashboard (heute)
  bool lade = false;
  List<FreiesZeitfenster> freie = [];
  List<String> aenderungen = [];

  /// ✅ Wichtig: DateTime (damit BoxShared/Notizen nicht mit String crasht)
  DateTime tag = DateTime.now();

  DateTime _mondayOf(DateTime d) => service.mondayOf(d);

  Future<void> ladeWoche(DateTime monday) async {
    loading = true;
    notifyListeners();

    currentWeekMonday = _mondayOf(monday);
    termine = await service.ladeWoche(currentWeekMonday);

    loading = false;
    notifyListeners();

    await aktualisiere(DateTime.now());
  }

  void prevWeek() => ladeWoche(currentWeekMonday.subtract(const Duration(days: 7)));
  void nextWeek() => ladeWoche(currentWeekMonday.add(const Duration(days: 7)));

  void goToday() {
    final now = DateTime.now();
    ladeWoche(_mondayOf(now));
  }

  Future<void> aktualisiere(DateTime day) async {
    lade = true;
    notifyListeners();

    final d0 = DateTime(day.year, day.month, day.day);
    tag = d0;

    final dayTermine = termine.where((t) {
      final s = t.start;
      return s.year == d0.year && s.month == d0.month && s.day == d0.day;
    }).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    freie = _calcFreieZeitfenster(dayTermine, d0);

    lade = false;
    notifyListeners();
  }

  List<FreiesZeitfenster> _calcFreieZeitfenster(List<Termin> dayTermine, DateTime d0) {
    const startHour = 8;
    const endHour = 20;
    const slotMinutes = 30;

    bool overlaps(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
      return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
    }

    final res = <FreiesZeitfenster>[];
    DateTime slot = DateTime(d0.year, d0.month, d0.day, startHour, 0);

    while (slot.isBefore(DateTime(d0.year, d0.month, d0.day, endHour, 0))) {
      final slotEnd = slot.add(const Duration(minutes: slotMinutes));
      final busy = dayTermine.any((t) => overlaps(t.start, t.end, slot, slotEnd));
      if (!busy) res.add(FreiesZeitfenster(slot, slotEnd));
      slot = slotEnd;
    }
    return res;
  }

  List<Termin> kommendeHeute({int limit = 6}) {
    final now = DateTime.now();
    final d0 = DateTime(now.year, now.month, now.day);
    final list = termine.where((t) {
      final s = t.start;
      final isToday = s.year == d0.year && s.month == d0.month && s.day == d0.day;
      return isToday && t.start.isAfter(now.subtract(const Duration(minutes: 1)));
    }).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return list.take(limit).toList();
  }

  void _log(String text) {
    aenderungen.insert(0, text);
    if (aenderungen.length > 12) aenderungen.removeLast();
    notifyListeners();
  }

  Future<void> createTerminAt(DateTime slotStart) async {
    final t = await service.createTerminAt(slotStart);
    _log('Neu: ${t.kundeName} • ${DateFormat('HH:mm').format(t.start)}');
    await ladeWoche(currentWeekMonday);
  }

  Future<void> deleteTermin(String id) async {
    if (termine.isEmpty) return;

    final found = termine.where((x) => x.id == id).toList();
    final anyDate = found.isNotEmpty ? found.first.start : DateTime.now();

    await service.deleteTermin(id, anyDate);

    if (found.isNotEmpty) {
      _log('Gelöscht: ${found.first.kundeName}');
    } else {
      _log('Gelöscht: Termin');
    }

    await ladeWoche(currentWeekMonday);
  }

  Future<void> moveTermin(String id, DateTime newStart) async {
    final idx = termine.indexWhere((x) => x.id == id);
    if (idx == -1) return;

    final t = termine[idx];
    await service.moveTermin(id, newStart, t.start);
    _log('Verschoben: ${t.kundeName} → ${DateFormat('HH:mm').format(newStart)}');
    await ladeWoche(currentWeekMonday);
  }

  Future<void> updateDuration(String id, int minutes) async {
    final idx = termine.indexWhere((x) => x.id == id);
    if (idx == -1) return;

    final t = termine[idx];
    await service.updateDuration(id, minutes, t.start);
    _log('Dauer: ${t.kundeName} → ${minutes}m');
    await ladeWoche(currentWeekMonday);
  }

  Future<void> toggleStatus(String id) async {
    final idx = termine.indexWhere((x) => x.id == id);
    if (idx == -1) return;
    final t = termine[idx];
    _log('Status geändert: ${t.kundeName}');
    notifyListeners();
  }

  Future<void> cancelTermin(String id) async {
    final idx = termine.indexWhere((x) => x.id == id);
    if (idx == -1) return;
    final t = termine[idx];
    _log('Storniert: ${t.kundeName}');
    notifyListeners();
  }
}
