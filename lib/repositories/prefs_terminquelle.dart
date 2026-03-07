import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/staff_config.dart';
import '../models/termin.dart';
import 'terminquelle.dart';

class PrefsTerminquelle implements Terminquelle {
  PrefsTerminquelle({this.seedDemoData = true});

  final bool seedDemoData;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const _demoVersionKey = 'fo_termine_demo_version';
  static const _legacySeedKey = 'fo_termine_seeded_v1';
  static const int _demoVersion = 6;

  static const List<String> _kundePool = <String>[
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

  DateTime _mondayOf(DateTime d) {
    final x = DateTime(d.year, d.month, d.day);
    return x.subtract(Duration(days: x.weekday - DateTime.monday));
  }

  String _weekKey(DateTime monday) {
    final m = _mondayOf(monday);
    final y = m.year.toString();
    final mo = m.month.toString().padLeft(2, '0');
    final da = m.day.toString().padLeft(2, '0');
    return 'fo_termine_week_$y$mo$da';
  }

  String _weekStamp(DateTime monday) {
    final m = _mondayOf(monday);
    final y = m.year.toString();
    final mo = m.month.toString().padLeft(2, '0');
    final da = m.day.toString().padLeft(2, '0');
    return '$y$mo$da';
  }

  DateTime _d(DateTime monday, int dayIndex, int h, int m) {
    final base = monday.add(Duration(days: dayIndex));
    return DateTime(base.year, base.month, base.day, h, m);
  }

  Future<void> _maybeSeed(DateTime monday) async {
    if (!seedDemoData) return;

    final sp = await _prefs;
    final currentVersion = sp.getInt(_demoVersionKey) ?? 0;
    if (currentVersion >= _demoVersion) return;

    final now = DateTime.now();
    final nowMonday = _mondayOf(now);
    final julyCutoff = DateTime(now.year, 7, 15);
    final cutoffMonday = _mondayOf(now.isAfter(julyCutoff) ? now : julyCutoff);

    for (var cursor = nowMonday;
        !cursor.isAfter(cutoffMonday);
        cursor = cursor.add(const Duration(days: 7))) {
      await _mergeDemoWeek(sp, cursor);
    }

    await sp.setInt(_demoVersionKey, _demoVersion);
    await sp.remove(_legacySeedKey);
  }

  Future<void> _mergeDemoWeek(SharedPreferences sp, DateTime monday) async {
    final key = _weekKey(monday);
    final existing = _parseWeek(sp.getString(key));
    final existingIds = existing.map((e) => e.id).toSet();
    final demo = _buildDemoWeek(monday);

    final merged = <Termin>[...existing];

    for (final termin in demo) {
      if (existingIds.add(termin.id)) {
        merged.add(termin);
      }
    }

    merged.sort((a, b) => a.start.compareTo(b.start));
    await sp.setString(key, jsonEncode(merged.map((e) => e.toJson()).toList()));
  }

  List<Termin> _parseWeek(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    return decoded
        .whereType<Map>()
        .map((e) => Termin.fromJson(Map<String, dynamic>.from(e)))
        .where((t) => StaffConfig.isValid(t.mitarbeiterName))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  List<String> _stammkundenFuerMitarbeiter(int employeeIndex) {
    const blockSize = 24;
    final start = employeeIndex * blockSize;
    final end = start + blockSize;
    return _kundePool.sublist(start, end);
  }

  List<_SlotSeed> _baseSlotsForEmployee(int employeeIndex) {
    switch (employeeIndex) {
      case 0:
        return const <_SlotSeed>[
          _SlotSeed(hour: 8, minute: 30, duration: 30, service: 'Haarschnitt', price: 25),
          _SlotSeed(hour: 9, minute: 15, duration: 45, service: 'Fade Cut', price: 31),
          _SlotSeed(hour: 10, minute: 15, duration: 30, service: 'Bart', price: 19),
          _SlotSeed(hour: 11, minute: 15, duration: 45, service: 'Haarschnitt + Bart', price: 39),
          _SlotSeed(hour: 13, minute: 15, duration: 30, service: 'Konturen', price: 17),
          _SlotSeed(hour: 14, minute: 15, duration: 45, service: 'Waschen + Styling', price: 27),
          _SlotSeed(hour: 15, minute: 30, duration: 30, service: 'Maschinenschnitt', price: 22),
          _SlotSeed(hour: 16, minute: 15, duration: 45, service: 'Skin Fade', price: 33),
          _SlotSeed(hour: 17, minute: 30, duration: 30, service: 'Kontur + Finish', price: 18),
          _SlotSeed(hour: 18, minute: 0, duration: 30, service: 'Express Cut', price: 21),
        ];
      case 1:
        return const <_SlotSeed>[
          _SlotSeed(hour: 8, minute: 45, duration: 30, service: 'Maschinenschnitt', price: 22),
          _SlotSeed(hour: 9, minute: 30, duration: 45, service: 'Mid Fade', price: 30),
          _SlotSeed(hour: 10, minute: 30, duration: 30, service: 'Bart + Rasur', price: 22),
          _SlotSeed(hour: 11, minute: 30, duration: 45, service: 'Haarschnitt Premium', price: 37),
          _SlotSeed(hour: 13, minute: 30, duration: 30, service: 'Konturen', price: 17),
          _SlotSeed(hour: 14, minute: 15, duration: 45, service: 'Styling', price: 24),
          _SlotSeed(hour: 15, minute: 30, duration: 30, service: 'Haarschnitt', price: 24),
          _SlotSeed(hour: 16, minute: 15, duration: 45, service: 'Skin Fade', price: 33),
          _SlotSeed(hour: 17, minute: 15, duration: 30, service: 'Bart', price: 18),
          _SlotSeed(hour: 18, minute: 0, duration: 30, service: 'Kontur + Finish', price: 18),
        ];
      default:
        return const <_SlotSeed>[
          _SlotSeed(hour: 8, minute: 30, duration: 30, service: 'Haarschnitt', price: 24),
          _SlotSeed(hour: 9, minute: 30, duration: 45, service: 'Low Fade', price: 30),
          _SlotSeed(hour: 10, minute: 45, duration: 30, service: 'Bart', price: 18),
          _SlotSeed(hour: 11, minute: 45, duration: 45, service: 'Haarschnitt + Waschen', price: 34),
          _SlotSeed(hour: 13, minute: 45, duration: 30, service: 'Augenbrauen + Kontur', price: 16),
          _SlotSeed(hour: 14, minute: 30, duration: 45, service: 'Styling + Finish', price: 26),
          _SlotSeed(hour: 15, minute: 45, duration: 30, service: 'Maschinenschnitt', price: 21),
          _SlotSeed(hour: 16, minute: 30, duration: 45, service: 'Fade Cut', price: 31),
          _SlotSeed(hour: 17, minute: 30, duration: 30, service: 'Express Cut', price: 20),
          _SlotSeed(hour: 18, minute: 0, duration: 30, service: 'Konturen', price: 17),
        ];
    }
  }

  List<int> _slotIndexesForDay(int dayIndex) {
    switch (dayIndex) {
      case 0: // Montag
        return const [0, 1, 2, 3, 5, 6, 7];
      case 1: // Dienstag
        return const [0, 1, 2, 3, 5, 7];
      case 2: // Mittwoch
        return const [0, 1, 3, 5, 6, 7];
      case 3: // Donnerstag
        return const [0, 1, 2, 3, 5, 6, 7, 8];
      case 4: // Freitag
        return const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      case 5: // Samstag
        return const [0, 1, 2, 3, 5, 6, 7, 8];
      default:
        return const [0, 1, 2, 3, 5, 6];
    }
  }

  String _kundeFuerTermin({
    required int weekIndex,
    required int dayIndex,
    required int employeeIndex,
    required int slotIndex,
  }) {
    final stammkunden = _stammkundenFuerMitarbeiter(employeeIndex);
    final recurringSeed = weekIndex * 11 + dayIndex * 5 + slotIndex;

    final useStammkunde = recurringSeed % 10 < 7;
    if (useStammkunde) {
      final idx = (weekIndex * 3 + dayIndex * 2 + slotIndex) % stammkunden.length;
      return stammkunden[idx];
    }

    final poolIndex =
        (weekIndex * 37 + dayIndex * 13 + employeeIndex * 7 + slotIndex * 5) % _kundePool.length;
    return _kundePool[poolIndex];
  }

  List<Termin> _buildDemoWeek(DateTime monday) {
    final list = <Termin>[];
    final weekIndex = _mondayOf(monday)
            .difference(_mondayOf(DateTime(DateTime.now().year, 1, 1)))
            .inDays ~/
        7;

    for (var dayIndex = 0; dayIndex < 6; dayIndex++) {
      final slotIndexes = _slotIndexesForDay(dayIndex);

      for (var employeeIndex = 0;
          employeeIndex < StaffConfig.employees.length;
          employeeIndex++) {
        final employee = StaffConfig.employees[employeeIndex];
        final slots = _baseSlotsForEmployee(employeeIndex);

        for (var visualOrder = 0; visualOrder < slotIndexes.length; visualOrder++) {
          final slotIndex = slotIndexes[visualOrder];
          final slot = slots[slotIndex];

          final kundeName = _kundeFuerTermin(
            weekIndex: weekIndex,
            dayIndex: dayIndex,
            employeeIndex: employeeIndex,
            slotIndex: slotIndex,
          );

          final start = _d(monday, dayIndex, slot.hour, slot.minute);

          list.add(
            Termin(
              id: 'demo_${_weekStamp(monday)}_${dayIndex}_${employeeIndex}_$slotIndex',
              start: start,
              end: start.add(Duration(minutes: slot.duration)),
              kundeName: kundeName,
              mitarbeiterName: employee,
              status: _statusFor(weekIndex, dayIndex, employeeIndex, visualOrder),
              service: slot.service,
              price: slot.price,
              color: StaffConfig.colorOf(employee),
            ),
          );
        }
      }
    }

    list.sort((a, b) => a.start.compareTo(b.start));
    return list;
  }

  String _statusFor(int weekIndex, int dayIndex, int employeeIndex, int slotOrder) {
    final seed = weekIndex * 17 + dayIndex * 7 + employeeIndex * 3 + slotOrder;

    if (seed % 23 == 0) return Termin.statusAbgesagt;
    if (seed % 6 == 0) return Termin.statusOffen;
    return Termin.statusBestaetigt;
  }

  @override
  Future<List<Termin>> ladeWoche(DateTime monday) async {
    final m = _mondayOf(monday);
    await _maybeSeed(m);

    final sp = await _prefs;
    return _parseWeek(sp.getString(_weekKey(m)));
  }

  @override
  Future<void> speichereWoche(DateTime monday, List<Termin> termine) async {
    final m = _mondayOf(monday);
    final sp = await _prefs;

    final cleaned = termine
        .where((t) => StaffConfig.isValid(t.mitarbeiterName))
        .map((e) => e.toJson())
        .toList();

    await sp.setString(_weekKey(m), jsonEncode(cleaned));
  }
}

class _SlotSeed {
  final int hour;
  final int minute;
  final int duration;
  final String service;
  final double price;

  const _SlotSeed({
    required this.hour,
    required this.minute,
    required this.duration,
    required this.service,
    required this.price,
  });
}