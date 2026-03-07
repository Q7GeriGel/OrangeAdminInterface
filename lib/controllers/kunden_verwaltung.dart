import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/staff_config.dart';
import '../models/kunde.dart';

class KundenVerwaltung extends ChangeNotifier {
  static const _storeKey = 'fo_kunden_v1';
  static const _seedKey = 'fo_kunden_seeded_v1';

  /// ✅ EINZIGE 3 Mitarbeiter im System (wird in Dialogen als const benutzt)
  static const List<String> allowedMitarbeiter = StaffConfig.employees;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Kunde> _alle = [];

  // Such-/Filterzustand
  String _suche = '';
  bool? _nurStammkunden; // null = egal
  String? _friseur; // null = egal

  // ✅ init: aus SharedPreferences laden (und ggf. Demo seed)
  Future<void> init() async {
    final sp = await _prefs;
    final raw = sp.getString(_storeKey);

    if (raw != null && raw.trim().isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _alle
          ..clear()
          ..addAll(decoded
              .whereType<Map>()
              .map((e) => Kunde.fromJson(Map<String, dynamic>.from(e))));
      }
    }

    final seeded = sp.getBool(_seedKey) ?? false;
    if (!seeded && _alle.isEmpty) {
      // kleine Demo-Liste, damit Autocomplete direkt was hat
      _alle.addAll([
        Kunde(
          id: '1',
          name: 'Refik Erdogan',
          telefonnummer: '+43 699 100 000 2007',
          stammkunde: false,
          bevorzugterFriseur: StaffConfig.employees[0],
          letzterHaarschnitt: DateTime(2025, 6, 17),
          naechsterTermin: null,
        ),
        Kunde(
          id: '2',
          name: 'Ali Demir',
          telefonnummer: '+43 699 111 222 333',
          stammkunde: true,
          bevorzugterFriseur: StaffConfig.employees[1],
          letzterHaarschnitt: DateTime(2025, 7, 2),
          naechsterTermin: null,
        ),
      ]);

      await sp.setBool(_seedKey, true);
      await _persist();
    }

    // Safety: falls alte Daten andere Namen hatten -> rausfiltern
    _alle.removeWhere((k) => !StaffConfig.isValid(k.bevorzugterFriseur));
    await _persist();

    notifyListeners();
  }

  Future<void> _persist() async {
    final sp = await _prefs;
    final payload = _alle.map((e) => e.toJson()).toList();
    await sp.setString(_storeKey, jsonEncode(payload));
  }

  // Getter für UI (mit Suche/Filter)
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

    final list = r.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  /// Alias (für ältere UI-Stellen)
  List<Kunde> get kundenGefiltert => kunden;

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

  // CRUD (persist)
  Future<void> hinzufuegen(Kunde k) async {
    // Safety: nur 3 Friseure erlauben
    if (!StaffConfig.isValid(k.bevorzugterFriseur)) {
      k = k.kopie()..bevorzugterFriseur = StaffConfig.defaultEmployee;
    }
    _alle.add(k);
    notifyListeners();
    await _persist();
  }

  Future<void> bearbeiten(Kunde k) async {
    if (!StaffConfig.isValid(k.bevorzugterFriseur)) {
      k = k.kopie()..bevorzugterFriseur = StaffConfig.defaultEmployee;
    }
    final i = _alle.indexWhere((x) => x.id == k.id);
    if (i >= 0) {
      _alle[i] = k;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> loeschen(String id) async {
    _alle.removeWhere((k) => k.id == id);
    notifyListeners();
    await _persist();
  }

  // ✅ Mitarbeiterliste: NUR diese 3
  List<String> get friseure => List<String>.from(StaffConfig.employees);

  bool? get nurStammkunden => _nurStammkunden;
  String? get friseur => _friseur;

  // Optional: Autocomplete-Hilfe
  List<String> get kundenNamen {
    final s = _alle
        .map((e) => e.name.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    s.sort();
    return s;
  }
}