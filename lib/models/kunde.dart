class Kunde {
  String id;
  String name;
  String telefonnummer;
  bool stammkunde;
  String bevorzugterFriseur;
  DateTime? letzterHaarschnitt;
  DateTime? naechsterTermin;

  Kunde({
    required this.id,
    required this.name,
    required this.telefonnummer,
    required this.stammkunde,
    required this.bevorzugterFriseur,
    this.letzterHaarschnitt,
    this.naechsterTermin,
  });

  Kunde kopie() => Kunde(
        id: id,
        name: name,
        telefonnummer: telefonnummer,
        stammkunde: stammkunde,
        bevorzugterFriseur: bevorzugterFriseur,
        letzterHaarschnitt: letzterHaarschnitt,
        naechsterTermin: naechsterTermin,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'telefonnummer': telefonnummer,
        'stammkunde': stammkunde,
        'bevorzugterFriseur': bevorzugterFriseur,
        'letzterHaarschnitt': letzterHaarschnitt?.toIso8601String(),
        'naechsterTermin': naechsterTermin?.toIso8601String(),
      };

  static Kunde fromJson(Map<String, dynamic> j) => Kunde(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        telefonnummer: (j['telefonnummer'] ?? '').toString(),
        stammkunde: (j['stammkunde'] == true),
        bevorzugterFriseur: (j['bevorzugterFriseur'] ?? '').toString(),
        letzterHaarschnitt: (j['letzterHaarschnitt'] is String && (j['letzterHaarschnitt'] as String).isNotEmpty)
            ? DateTime.tryParse(j['letzterHaarschnitt'] as String)
            : null,
        naechsterTermin: (j['naechsterTermin'] is String && (j['naechsterTermin'] as String).isNotEmpty)
            ? DateTime.tryParse(j['naechsterTermin'] as String)
            : null,
      );
}