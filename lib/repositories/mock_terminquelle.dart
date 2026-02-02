import 'dart:math';
import 'package:flutter/material.dart';

import '../models/termin.dart';
import 'terminquelle.dart';

class MockTerminquelle implements Terminquelle {
  final Map<String, List<Termin>> _cache = {};

  String _key(DateTime monday) =>
      '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    final k = _key(monday);
    if (_cache.containsKey(k)) return _cache[k]!;

    final seed = monday.year * 10000 + monday.month * 100 + monday.day;
    final r = Random(seed);

    final kunden = [
      'L. Demir', 'F. Kaya', 'R. Yılmaz', 'S. Aydin', 'E. Öztürk',
      'M. Can', 'A. Şahin', 'N. Arslan', 'B. Koç', 'Z. Polat'
    ];
    final mitarbeiter = ['Aylin', 'Kaan', 'Selin', 'Mert'];

    Color colorForMitarbeiter(String name) {
      switch (name) {
        case 'Aylin':
          return const Color(0xFF2E7DDB);
        case 'Kaan':
          return const Color(0xFFFF9800);
        case 'Selin':
          return const Color(0xFF00A7A7);
        default:
          return const Color(0xFF7E57C2);
      }
    }

    String randomStatus() {
      // bisschen realistischer verteilt
      final x = r.nextInt(100);
      if (x < 10) return Termin.statusAbgesagt;     // 10%
      if (x < 55) return Termin.statusBestaetigt;   // 45%
      return Termin.statusOffen;                    // 45%
    }

    DateTime dayOf(int dayIndex) =>
        DateTime(monday.year, monday.month, monday.day + dayIndex);

    DateTime slot(DateTime d, int h, int m) =>
        DateTime(d.year, d.month, d.day, h, m);

    final termine = <Termin>[];

    // 8–14 Termine pro Woche
    final count = 8 + r.nextInt(7);
    for (int i = 0; i < count; i++) {
      final d = dayOf(r.nextInt(6)); // Mo–Sa
      final startHour = 8 + r.nextInt(11); // 08–18
      final startMin = r.nextBool() ? 0 : 30;

      final durOptions = [30, 30, 30, 60, 60, 90];
      final dur = durOptions[r.nextInt(durOptions.length)];

      final start = slot(d, startHour, startMin);
      final end = start.add(Duration(minutes: dur));

      final knd = kunden[r.nextInt(kunden.length)];
      final emp = mitarbeiter[r.nextInt(mitarbeiter.length)];

      final id = 'w_${_key(monday)}_$i';

      termine.add(
        Termin(
          id: id,
          start: start,
          end: end,
          kundeName: knd,
          mitarbeiterName: emp,
          status: randomStatus(), // ✅ REQUIRED
          color: colorForMitarbeiter(emp),
          service: r.nextBool() ? 'Haarschnitt' : 'Bart',
          price: r.nextBool() ? 25.0 : 35.0,
        ),
      );
    }

    termine.sort((a, b) => a.start.compareTo(b.start));

    _cache[k] = termine;
    return termine;
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    _cache[_key(monday)] = List<Termin>.from(termine);
  }
}
