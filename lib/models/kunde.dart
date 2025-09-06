
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
    this.stammkunde = false,
    this.bevorzugterFriseur = '',
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
}
