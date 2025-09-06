import 'package:flutter/foundation.dart';
import '../models/zeitfenster.dart';
import '../services/terminplan_service.dart';

class TerminplanController extends ChangeNotifier {
  final TerminplanService dienst;
  TerminplanController(this.dienst);

  DateTime _tag = DateTime.now();
  List<Zeitfenster> _freie = [];
  bool _lade = false;

  DateTime get tag => _tag;
  List<Zeitfenster> get freie => _freie;
  bool get lade => _lade;

  Future<void> aktualisiere([DateTime? neuerTag]) async {
    _lade = true; notifyListeners();
    _tag = neuerTag ?? _tag;
    _freie = await dienst.freieSlots(_tag);
    _lade = false; notifyListeners();
  }
}
