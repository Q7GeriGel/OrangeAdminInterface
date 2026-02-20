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
  // ✅ Nur diese 3 dürfen auswählbar sein
  static const List<String> allowedFriseure = ['Serkan', 'Samet', 'Sedat'];

  final List<Kunde> _alle = [..._startDaten];

  // Such-/Filterzustand
  String _suche = '';
  bool? _nurStammkunden; // null = egal
  String? _friseur; // null = egal

  String _normalizeFriseur(String input) {
    final low = input.trim().toLowerCase();
    for (final f in allowedFriseure) {
      if (f.toLowerCase() == low) return f;
    }
    return allowedFriseure.first; // fallback Serkan
  }

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
    _friseur = (friseur?.isEmpty ?? true) ? null : _normalizeFriseur(friseur!);
    notifyListeners();
  }

  // CRUD
  void hinzufuegen(Kunde k) {
    final n = k.kopie();
    n.bevorzugterFriseur = _normalizeFriseur(n.bevorzugterFriseur);
    _alle.add(n);
    notifyListeners();
  }

  void bearbeiten(Kunde k) {
    final i = _alle.indexWhere((x) => x.id == k.id);
    if (i >= 0) {
      final n = k.kopie();
      n.bevorzugterFriseur = _normalizeFriseur(n.bevorzugterFriseur);
      _alle[i] = n;
      notifyListeners();
    }
  }

  void loeschen(String id) {
    _alle.removeWhere((k) => k.id == id);
    notifyListeners();
  }

  // ✅ Für Dropdowns in "Neuer Kunde" + Filter: NUR DIESE 3
  List<String> get friseure => List<String>.from(allowedFriseure);

  bool? get nurStammkunden => _nurStammkunden;
  String? get friseur => _friseur;
}