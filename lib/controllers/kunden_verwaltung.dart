import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/staff_config.dart';
import '../models/kunde.dart';

class KundenVerwaltung extends ChangeNotifier {
  static const _storeKey = 'fo_kunden_v1';
  static const _demoVersionKey = 'fo_kunden_demo_version';
  static const _legacySeedKey = 'fo_kunden_seeded_v1';
  static const int _demoVersion = 6;

  /// ✅ EINZIGE 3 Mitarbeiter im System
  static const List<String> allowedMitarbeiter = StaffConfig.employees;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final List<Kunde> _alle = [];

  String _suche = '';
  bool? _nurStammkunden;
  String? _friseur;

  static String normalizeName(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  Future<void> init() async {
    final sp = await _prefs;
    await _ladeAusStore(sp);
    await _mergeDemoKundenIfNeeded(sp);

    var changed = false;

    for (var i = 0; i < _alle.length; i++) {
      final current = _alle[i];

      final cleanName = current.name.trim().replaceAll(RegExp(r'\s+'), ' ');
      final cleanPhone = current.telefonnummer.trim();
      final cleanFriseur = StaffConfig.isValid(current.bevorzugterFriseur)
          ? current.bevorzugterFriseur.trim()
          : StaffConfig.defaultEmployee;

      if (cleanName != current.name ||
          cleanPhone != current.telefonnummer ||
          cleanFriseur != current.bevorzugterFriseur) {
        _alle[i] = current.kopie()
          ..name = cleanName
          ..telefonnummer = cleanPhone
          ..bevorzugterFriseur = cleanFriseur;
        changed = true;
      }
    }

    _sortiereIntern();

    if (changed) {
      await _persist(sp);
    }

    notifyListeners();
  }

  Future<void> _ladeAusStore(SharedPreferences sp) async {
    final raw = sp.getString(_storeKey);
    if (raw == null || raw.trim().isEmpty) return;

    final decoded = jsonDecode(raw);
    if (decoded is! List) return;

    _alle
      ..clear()
      ..addAll(
        decoded
            .whereType<Map>()
            .map((e) => Kunde.fromJson(Map<String, dynamic>.from(e))),
      );
  }

  Future<void> _mergeDemoKundenIfNeeded(SharedPreferences sp) async {
    final currentVersion = sp.getInt(_demoVersionKey) ?? 0;
    if (currentVersion >= _demoVersion) return;

    final existingNames = _alle.map((k) => normalizeName(k.name)).toSet();
    var changed = false;

    for (final demo in _buildDemoKunden()) {
      if (existingNames.add(normalizeName(demo.name))) {
        _alle.add(demo);
        changed = true;
      }
    }

    _sortiereIntern();

    await sp.setInt(_demoVersionKey, _demoVersion);
    await sp.remove(_legacySeedKey);

    if (changed) {
      await _persist(sp);
    }
  }

  List<Kunde> _buildDemoKunden() {
    final year = DateTime.now().year;

    const names = <String>[
      'Refik Erdogan',
      'Ali Demir',
      'Mehmet Kaya',
      'Ahmet Yilmaz',
      'Mustafa Sahin',
      'Yusuf Celik',
      'Emre Arslan',
      'Mert Koc',
      'Furkan Aydin',
      'Burak Kurt',
      'Onur Polat',
      'Serhat Aslan',
      'Kaan Dogan',
      'Umut Tekin',
      'Can Yildiz',
      'Eren Tas',
      'Hakan Demirtas',
      'Batuhan Ozturk',
      'Tolga Kose',
      'Baris Gunes',
      'Omer Cakir',
      'Taha Karaca',
      'Arda Duman',
      'Berkay Simsek',
      'Kerem Kilic',
      'Volkan Kaplan',
      'Sinan Acar',
      'Samet Akin',
      'Sedat Ekinci',
      'Serkan Ates',
      'Murat Korkmaz',
      'Cihan Sari',
      'Emir Bozkurt',
      'Yasin Bulut',
      'Halil Tasci',
      'Osman Tunc',
      'Aykut Turan',
      'Deniz Coskun',
      'Nihat Uysal',
      'Gokhan Inan',
      'Harun Avci',
      'Riza Peker',
      'Bora Yavuz',
      'Huseyin Guler',
      'Rahmi Erdem',
      'Ege Candan',
      'Miran Gok',
      'Doruk Cinar',
      'Alperen Kir',
      'Berk Erol',
      'Enes Bayram',
      'Sefa Kalkan',
      'Recep Ozdemir',
      'Oguzhan Kuru',
      'Talha Dincer',
      'Mahir Tasdelen',
      'Cem Eren',
      'Orhan Bilgin',
      'Musa Efe',
      'Ibrahim Yildirim',
      'Salih Pala',
      'Abdullah Cetin',
      'Yigit Goktas',
      'Alp Demirel',
      'Ugur Guven',
      'Yunus Emre Acar',
      'Mucahit Altin',
      'Ramazan Kara',
      'Mesut Duran',
      'Ismail Kayaalp',
      'Eray Kocak',
      'Levent Bas',
      'Ferhat Can',
      'Kadir Keles',
      'Tuncay Ay',
      'Suat Ayan',
      'Efehan Ozan',
      'Oktay Karan',
      'Bunyamin Oral',
      'Cagatay Erenler',
      'Muhammed Arslan',
      'Muhammet Celik',
      'Metehan Ucar',
      'Alican Karaman',
      'Poyraz Demirci',
      'Ayberk Gunduz',
      'Emirhan Dalkiran',
      'Kivanc Ates',
      'Hamit Cevik',
      'Sercan Yilmaz',
      'Atakan Tan',
      'Batinhan Korkut',
      'Taylan Akinci',
      'Ozan Karatas',
      'Yavuz Selim Koc',
      'Akif Eren',
      'Hilmi Dursun',
      'Suleyman Ince',
      'Nuri Yasar',
      'Ertugrul Aydemir',
      'Kemal Duran',
      'Azad Demir',
      'Ulas Gokmen',
      'Koray Sahin',
      'Erdem Karakus',
      'Anil Cicek',
      'Cenk Acar',
      'Firat Aslan',
      'Kuzey Yildiz',
      'Batuhan Gokce',
      'Bilal Koseoglu',
      'Yakup Demirezen',
      'Aydin Peker',
      'Arif Korkut',
      'Cemal Ustun',
      'Ilker Genc',
      'Sami Tosun',
      'Taner Kalkan',
      'Engin Sahiner',
      'Vedat Ozer',
      'Necati Yaman',
      'Rauf Tasdemir',
      'Zafer Dindar',
      'Metin Sancak',
      'Turgut Aksoy',
      'Adem Yildiz',
      'Bekir Kocaman',
      'Halim Goktas',
      'Rasim Cetiner',
      'Orcun Bayraktar',
      'Selcuk Turker',
      'Berkant Topal',
      'Erdinc Kalkan',
      'Menderes Ucar',
      'Sinasi Tufan',
      'Caglar Arican',
      'Tolgahan Kurtulus',
      'Halimhan Efe',
      'Mertcan Karaca',
      'Serdar Celik',
      'Maksut Guler',
      'Akin Demirhan',
      'Berke Kaya',
      'Gurkan Oztas',
      'Faruk Kocer',
      'Yalcin Karahan',
      'Okan Demirturk',
      'Tufan Ozer',
      'Abdurrahman Kose',
      'Kamil Aydogan',
      'Rahman Kilinc',
      'Veli Asilturk',
      'Durmus Sahin',
      'Mevlut Turan',
      'Hidayet Duran',
      'Sehmus Kaya',
      'Nedim Polat',
      'Polat Arslan',
      'Rojhat Demir',
      'Seyhmus Celik',
      'Huseyinhan Ates',
      'Orhanhan Koc',
      'Mert Ali Yildirim',
      'Emrehan Cakir',
      'Caner Kurt',
      'Borahan Yilmaz',
      'Onat Demirtas',
      'Aras Korkmaz',
      'Koralp Aydin',
      'Kaan Efe Demir',
      'Emircan Sahin',
      'Talip Ozturk',
      'Bekirhan Kaplan',
      'Niyazi Kose',
      'Fahri Duman',
      'Sahin Demir',
      'Vedat Celik',
      'Selami Aslan',
      'Ismet Kaya',
      'Muratcan Tekin',
      'Haruncan Yildiz',
      'Rifat Tas',
      'Nevzat Demirtas',
      'Tamer Ozen',
      'Berkhan Guler',
      'Aybars Koc',
      'Keremcan Polat',
      'Uras Aydin',
      'Eymen Kurt',
      'Alaz Yilmaz',
      'Sarp Demir',
      'Toprak Celik',
      'Arin Aslan',
      'Pars Sahin',
      'Emin Kose',
      'Naim Gunes',
      'Arel Dincer',
      'Mithat Karaca',
      'Ferdi Kilic',
      'Huseyin Can Tekin',
      'Ercan Ates',
      'Necip Yildirim',
      'Tahir Oztas',
      'Samihan Demir',
      'Mertoglu Koc',
      'Emrah Yildiz',
      'Bekir Aydin',
      'Firat Can',
      'Umit Sahin',
      'Mesut Tekin',
      'Yigitcan Kaya',
      'Tuncer Koc',
      'Serdar Ozturk',
      'Oguz Demir',
      'Cemalettin Arslan',
      'Faruk Demirtas',
      'Suleyman Korkmaz',
      'Akin Polat',
      'Ramiz Cakir',
      'Orhan Demirci',
      'Bilgehan Ates',
      'Haktan Guler',
      'Erdal Kurt',
      'Mecit Aslan',
      'Nihat Demir',
      'Fehmi Kaya',
      'Korhan Tekin',
      'Melih Celik',
      'Ersin Kose',
      'Tayfun Polat',
      'Tolgacan Sahin',
      'Ufuk Yildirim',
      'Yekta Demir',
      'Zaim Kurt',
      'Burhan Acar',
      'Cavit Ozen',
      'Doqan Arslan',
      'Ekrem Kaya',
      'Fatih Polat',
      'Gencay Demir',
    ];

    final list = <Kunde>[];

    for (var i = 0; i < names.length; i++) {
      final preferred = StaffConfig.employees[i % StaffConfig.employees.length];

      final letzterHaarschnitt = DateTime(
        year,
        1 + (i % 6),
        1 + ((i * 3) % 26),
      );

      DateTime? naechsterTermin;
      if (i % 6 != 0) {
        final month = 3 + (i % 5); // März bis Juli
        final day = 1 + ((i * 2) % 15); // bis Mitte Juli
        naechsterTermin = DateTime(year, month, day);
      }

      final phonePart = (1200000 + (i * 173)).toString().padLeft(7, '0');

      list.add(
        Kunde(
          id: 'demo_kunde_${i + 1}',
          name: names[i],
          telefonnummer: '+43 660 $phonePart',
          stammkunde: i % 5 != 0,
          bevorzugterFriseur: preferred,
          letzterHaarschnitt: letzterHaarschnitt,
          naechsterTermin: naechsterTermin,
        ),
      );
    }

    return list;
  }

  Future<void> _persist([SharedPreferences? existingPrefs]) async {
    final sp = existingPrefs ?? await _prefs;
    final payload = _alle.map((e) => e.toJson()).toList();
    await sp.setString(_storeKey, jsonEncode(payload));
  }

  void _sortiereIntern() {
    _alle.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

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

  List<Kunde> get kundenGefiltert => kunden;

  void sucheSetzen(String q) {
    _suche = q;
    notifyListeners();
  }

  void filterSetzen({bool? nurStammkunden, String? friseur}) {
    _nurStammkunden = nurStammkunden;

    if (friseur == null || friseur.trim().isEmpty || !StaffConfig.isValid(friseur)) {
      _friseur = null;
    } else {
      _friseur = friseur.trim();
    }

    notifyListeners();
  }

  Future<void> hinzufuegen(Kunde k) async {
    final cleanName = k.name.trim().replaceAll(RegExp(r'\s+'), ' ');
    final cleanFriseur = StaffConfig.isValid(k.bevorzugterFriseur)
        ? k.bevorzugterFriseur.trim()
        : StaffConfig.defaultEmployee;

    final safeKunde = k.kopie()
      ..name = cleanName
      ..telefonnummer = k.telefonnummer.trim()
      ..bevorzugterFriseur = cleanFriseur;

    _alle.add(safeKunde);
    _sortiereIntern();
    notifyListeners();
    await _persist();
  }

  Future<void> bearbeiten(Kunde k) async {
    final cleanName = k.name.trim().replaceAll(RegExp(r'\s+'), ' ');
    final cleanFriseur = StaffConfig.isValid(k.bevorzugterFriseur)
        ? k.bevorzugterFriseur.trim()
        : StaffConfig.defaultEmployee;

    final safeKunde = k.kopie()
      ..name = cleanName
      ..telefonnummer = k.telefonnummer.trim()
      ..bevorzugterFriseur = cleanFriseur;

    final i = _alle.indexWhere((x) => x.id == safeKunde.id);
    if (i >= 0) {
      _alle[i] = safeKunde;
      _sortiereIntern();
      notifyListeners();
      await _persist();
    }
  }

  Future<void> loeschen(String id) async {
    _alle.removeWhere((k) => k.id == id);
    notifyListeners();
    await _persist();
  }

  bool existiertName(String name) {
    final normalized = normalizeName(name);
    return _alle.any((k) => normalizeName(k.name) == normalized);
  }

  Kunde? findePerName(String name) {
    final normalized = normalizeName(name);
    for (final kunde in _alle) {
      if (normalizeName(kunde.name) == normalized) {
        return kunde;
      }
    }
    return null;
  }

  Future<bool> erstelleKundeFallsFehlt({
    required String name,
    required String bevorzugterFriseur,
    DateTime? naechsterTermin,
  }) async {
    final cleanName = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanName.isEmpty || existiertName(cleanName)) {
      return false;
    }

    await hinzufuegen(
      Kunde(
        id: 'kunde_${DateTime.now().microsecondsSinceEpoch}',
        name: cleanName,
        telefonnummer: '',
        stammkunde: false,
        bevorzugterFriseur: StaffConfig.isValid(bevorzugterFriseur)
            ? bevorzugterFriseur.trim()
            : StaffConfig.defaultEmployee,
        letzterHaarschnitt: null,
        naechsterTermin: naechsterTermin,
      ),
    );

    return true;
  }

  List<String> get friseure => List<String>.from(StaffConfig.employees);

  bool? get nurStammkunden => _nurStammkunden;
  String? get friseur => _friseur;

  List<String> get kundenNamen {
    final s = _alle
        .map((e) => e.name.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return s;
  }
}