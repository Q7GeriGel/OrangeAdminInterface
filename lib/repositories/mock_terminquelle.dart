import 'dart:math';
import 'terminquelle.dart';

/// Fake-Datenquelle: erzeugt zufällige Buchungen zwischen 09:00–18:00
class MockTerminquelle implements Terminquelle {
  final _rng = Random();

  @override
  Future<List<DateTime>> holeGebuchteStarts(DateTime tag) async {
    final basis = DateTime(tag.year, tag.month, tag.day, 9, 0);
    final set = <DateTime>{};
    for (int i = 0; i < 6; i++) {
      final off = _rng.nextInt(16); // 16 * 30min = 09:00..17:30
      set.add(basis.add(Duration(minutes: 30 * off)));
    }
    return set.toList()..sort();
  }
}
