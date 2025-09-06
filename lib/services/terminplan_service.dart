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
}
