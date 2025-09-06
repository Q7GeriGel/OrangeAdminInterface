import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kunde.dart';

/// Start-Daten (ersetzt DB vorübergehend)
final _startDaten = <Kunde>[
  Kunde(
    id: '1',
    name: 'Refik Erdogan',
    telefonnummer: '+43 699 100 000 2007',
    stammkunde: false,
    bevorzugterFriseur: 'Serkan',
    letzterHaarschnitt: DateTime(2025, 6, 17),
    naechsterTermin: DateTime(2025, 7, 1),
  ),
];

class KundenVerwaltung extends ChangeNotifier {
  final List<Kunde> _alle = [..._startDaten];

  // Such-/Filterzustand
  String _suche = '';
  bool? _nurStammkunden; // null = egal
  String? _friseur; // null = egal

  // Getter für UI
  List<Kunde> get kunden {
    Iterable<Kunde> r = _alle;
    if (_suche.trim().isNotEmpty) {
      final q = _suche.toLowerCase();
      r = r.where((k) {
        final lastStr = k.letzterHaarschnitt != null
            ? DateFormat('dd.MM.yyyy').format(k.letzterHaarschnitt!)
            : '';
        return k.name.toLowerCase().contains(q) ||
            k.telefonnummer.toLowerCase().contains(q) ||
            lastStr.contains(q);
      });
    }
    if (_nurStammkunden != null) {
      r = r.where((k) => k.stammkunde == _nurStammkunden);
    }
    if (_friseur != null && _friseur!.isNotEmpty) {
      r = r.where((k) => k.bevorzugterFriseur == _friseur);
    }
    return r.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  // Filter/Suche setzen
  void sucheSetzen(String q) {
    _suche = q;
    notifyListeners();
  }

  void filterSetzen({bool? nurStammkunden, String? friseur}) {
    _nurStammkunden = nurStammkunden;
    _friseur = (friseur?.isEmpty ?? true) ? null : friseur;
    notifyListeners();
  }

  // CRUD
  void hinzufuegen(Kunde k) {
    _alle.add(k);
    notifyListeners();
  }

  void bearbeiten(Kunde k) {
    final i = _alle.indexWhere((x) => x.id == k.id);
    if (i >= 0) {
      _alle[i] = k;
      notifyListeners();
    }
  }

  void loeschen(String id) {
    _alle.removeWhere((k) => k.id == id);
    notifyListeners();
  }

  // Hilfen
  List<String> get friseure {
    final s = <String>{};
    for (final k in _alle) {
      if (k.bevorzugterFriseur.trim().isNotEmpty) s.add(k.bevorzugterFriseur);
    }
    s.addAll({'Serkan', 'Aylin', 'Mira', 'Kenan'});
    final l = s.toList()..sort();
    return l;
  }

  bool? get nurStammkunden => _nurStammkunden;
  String? get friseur => _friseur;
}
