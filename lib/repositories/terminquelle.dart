import '../models/termin.dart';

abstract class Terminquelle {
  Future<List<Termin>> ladeWoche(DateTime monday);
  Future<void> speichereWoche(DateTime monday, List<Termin> termine);
}
