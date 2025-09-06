enum Startseite { dashboard, kunden, terminuebersicht }
enum Sprache { de, en, tr }

class AppSettings {
  // Profil
  Sprache sprache;

  // Darstellung
  bool darkmode;
  Startseite startseite;

  // Termine
  int standardTermindauerMin; // 15/30/45/60
  int pufferVorMin;           // 0/5/10/15
  int pufferNachMin;          // 0/5/10/15
  bool pausenAutomatisch;     // z.B. Mittagspause automatisch blocken

  // Benachrichtigungen
  bool kundenErinnerung;
  bool mitarbeiterReminder;
  bool tagesuebersichtAmMorgen;

  AppSettings({
    this.sprache = Sprache.de,
    this.darkmode = true,
    this.startseite = Startseite.dashboard,
    this.standardTermindauerMin = 30,
    this.pufferVorMin = 0,
    this.pufferNachMin = 0,
    this.pausenAutomatisch = false,
    this.kundenErinnerung = true,
    this.mitarbeiterReminder = true,
    this.tagesuebersichtAmMorgen = false,
  });

  AppSettings copyWith({
    Sprache? sprache,
    bool? darkmode,
    Startseite? startseite,
    int? standardTermindauerMin,
    int? pufferVorMin,
    int? pufferNachMin,
    bool? pausenAutomatisch,
    bool? kundenErinnerung,
    bool? mitarbeiterReminder,
    bool? tagesuebersichtAmMorgen,
  }) {
    return AppSettings(
      sprache: sprache ?? this.sprache,
      darkmode: darkmode ?? this.darkmode,
      startseite: startseite ?? this.startseite,
      standardTermindauerMin:
          standardTermindauerMin ?? this.standardTermindauerMin,
      pufferVorMin: pufferVorMin ?? this.pufferVorMin,
      pufferNachMin: pufferNachMin ?? this.pufferNachMin,
      pausenAutomatisch: pausenAutomatisch ?? this.pausenAutomatisch,
      kundenErinnerung: kundenErinnerung ?? this.kundenErinnerung,
      mitarbeiterReminder: mitarbeiterReminder ?? this.mitarbeiterReminder,
      tagesuebersichtAmMorgen:
          tagesuebersichtAmMorgen ?? this.tagesuebersichtAmMorgen,
    );
  }
}
