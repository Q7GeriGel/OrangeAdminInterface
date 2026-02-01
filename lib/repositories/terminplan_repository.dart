import '../services/terminplan_service.dart';
import '../models/termin.dart';

class TerminplanRepository {
  final TerminplanService service;
  TerminplanRepository(this.service);

  // TODO: später echte Daten holen (API). Jetzt nur leer zurückgeben,
  // damit der Build nicht scheitert.
  Future<List<Termin>> fetchWeek(DateTime sunday) async {
    return [];
  }
}
