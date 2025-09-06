import 'package:flutter/foundation.dart';

@immutable
abstract class Terminquelle {
  /// Gebuchte Startzeiten (z. B. 09:00, 09:30, …) für einen Tag
  Future<List<DateTime>> holeGebuchteStarts(DateTime tag);
}
