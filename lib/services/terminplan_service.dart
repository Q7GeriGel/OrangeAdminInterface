import 'package:flutter/material.dart';
import '../models/zeitfenster.dart';
import '../repositories/terminquelle.dart';

class TerminplanService {
  final Terminquelle quelle;
  final int minutenProSlot;
  final int startStunde;
  final int endStunde;

  TerminplanService({
    required this.quelle,
    this.minutenProSlot = 30,
    this.startStunde = 9,
    this.endStunde = 18,
  });

  /// --- Bestehend: freie Slots für EINEN Tag ---
  Future<List<Zeitfenster>> freieSlots(DateTime tag) async {
    final gebucht = await quelle.holeGebuchteStarts(tag);
    final keys = gebucht.map((d) => d.millisecondsSinceEpoch).toSet();

    final start = DateTime(tag.year, tag.month, tag.day, startStunde, 0);
    final ende  = DateTime(tag.year, tag.month, tag.day, endStunde, 0);

    final out = <Zeitfenster>[];
    var cur = start;
    while (cur.isBefore(ende)) {
      final next = cur.add(Duration(minutes: minutenProSlot));
      if (!keys.contains(cur.millisecondsSinceEpoch)) {
        out.add(Zeitfenster(cur, next));
      }
      cur = next;
    }

    final now = DateTime.now();
    if (DateUtils.isSameDay(now, tag)) {
      return out.where((z) => z.beginn.isAfter(now)).toList();
    }
    return out;
  }

  // ===============================
  //        NEU AB HIER
  // ===============================

  /// Helper: Sonntag 00:00 der Woche von [d]
  DateTime startVonWocheSonntag(DateTime d) {
    final offset = d.weekday % 7; // So=0, Mo=1, ...
    final so = DateTime(d.year, d.month, d.day).subtract(Duration(days: offset));
    return DateTime(so.year, so.month, so.day);
  }

  /// Alle Slots (frei + belegt-agnostisch) eines Tages in Minutenrastern.
  /// Nützlich fürs UI, wenn du alle Slots rendern willst.
  List<Zeitfenster> alleSlotsEinesTages(DateTime tag) {
    final start = DateTime(tag.year, tag.month, tag.day, startStunde, 0);
    final ende  = DateTime(tag.year, tag.month, tag.day, endStunde, 0);

    final out = <Zeitfenster>[];
    var cur = start;
    while (cur.isBefore(ende)) {
      final next = cur.add(Duration(minutes: minutenProSlot));
      out.add(Zeitfenster(cur, next));
      cur = next;
    }
    return out;
  }

  /// Freie Slots für die GANZE Woche (So–Sa). Key = Kalendertag 00:00.
  /// Nutzt intern deine bestehende Tagesfunktion.
  Future<Map<DateTime, List<Zeitfenster>>> freieSlotsWoche(DateTime sonntag) async {
    final so = startVonWocheSonntag(sonntag);
    final result = <DateTime, List<Zeitfenster>>{};

    for (int i = 0; i < 7; i++) {
      final tag = DateTime(so.year, so.month, so.day).add(Duration(days: i));
      result[tag] = await freieSlots(tag);
    }
    return result;
  }
}
