import '../models/termin.dart';
import '../repositories/terminquelle.dart';
import 'package:flutter/material.dart';


class TerminplanService {
  final Terminquelle quelle;

  TerminplanService({required this.quelle});

  Future<List<Termin>> ladeWoche(DateTime monday) => quelle.ladeWoche(monday);

  Future<void> speichereWoche(DateTime monday, List<Termin> termine) =>
      quelle.speichereWoche(monday, termine);

  // Helper: findet Montag der Woche
  DateTime mondayOf(DateTime d) {
    final dd = DateTime(d.year, d.month, d.day);
    final diff = dd.weekday - DateTime.monday;
    return dd.subtract(Duration(days: diff));
  }

  // ✅ wird von createTerminManual benutzt
  Future<Termin> createTerminAt(
    DateTime slotStart, {
    int minutes = 30,
    String kundeName = 'Neuer Kunde',
    String mitarbeiterName = 'Aylin',
    String status = Termin.statusOffen,
    String? service,
    double? price,
    String? notes,
    Color? color,
  }) async {
    final monday = mondayOf(slotStart);
    final list = await ladeWoche(monday);

    final id = 'new_${DateTime.now().millisecondsSinceEpoch}';
    final t = Termin(
      id: id,
      start: slotStart,
      end: slotStart.add(Duration(minutes: minutes)),
      kundeName: kundeName,
      mitarbeiterName: mitarbeiterName,
      status: status,
      service: service,
      price: price,
      notes: notes,
      color: color,
    );

    list.add(t);
    list.sort((a, b) => a.start.compareTo(b.start));

    await speichereWoche(monday, list);
    return t;
  }

  Future<void> deleteTermin(String id, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    list.removeWhere((t) => t.id == id);
    await speichereWoche(monday, list);
  }

  Future<void> moveTermin(String id, DateTime newStart, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final old = list[idx];
    final dur = old.end.difference(old.start);

    list[idx] = old.copyWith(
      start: newStart,
      end: newStart.add(dur),
    );

    list.sort((a, b) => a.start.compareTo(b.start));
    await speichereWoche(monday, list);
  }

  Future<void> updateDuration(String id, int minutes, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final old = list[idx];
    list[idx] = old.copyWith(
      end: old.start.add(Duration(minutes: minutes)),
    );

    list.sort((a, b) => a.start.compareTo(b.start));
    await speichereWoche(monday, list);
  }
}
