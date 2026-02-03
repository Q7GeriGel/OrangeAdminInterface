import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  const AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    final lc = Localizations.localeOf(context);
    return AppStrings(lc);
  }

  bool get isTr => locale.languageCode.toLowerCase() == 'tr';

  // Sidebar
  String get navDashboard => isTr ? 'Panel' : 'Dashboard';
  String get navKunden => isTr ? 'Müşteriler' : 'Kunden';
  String get navMitarbeiter => isTr ? 'Personel' : 'Mitarbeiter';
  String get navTermine => isTr ? 'Randevu Özeti' : 'Terminübersicht';
  String get navStatistik => isTr ? 'İstatistik' : 'Statistik';
  String get navEinstellungen => isTr ? 'Ayarlar' : 'Einstellungen';

  // Settings Page
  String get settingsTitle => isTr ? 'Ayarlar' : 'Einstellungen';
  String get save => isTr ? 'Kaydet' : 'Speichern';
  String get saved => isTr ? 'Kaydedildi ✅' : 'Gespeichert ✅';
  String get unsaved => isTr ? 'Kaydedilmemiş değişiklikler' : 'Ungespeicherte Änderungen';
  String get reset => isTr ? 'Sıfırla' : 'Zurücksetzen';
  String get close => isTr ? 'Schließen' : 'Schließen';

  String get sectionAppearance => isTr ? 'Görünüm' : 'Design';
  String get darkMode => isTr ? 'Karanlık Mod' : 'Darkmode';
  String get compactTables => isTr ? 'Kompakt Liste' : 'Kompaktmodus';
  String get reduceMotion => isTr ? 'Animasyonları azalt' : 'Weniger Animationen';

  String get sectionLanguage => isTr ? 'Dil' : 'Sprache';
  String get languageLabel => isTr ? 'Uygulama dili' : 'App-Sprache';
  String get german => 'Deutsch';
  String get turkish => 'Türkçe';

  String get sectionSafety => isTr ? 'Sicherheit' : 'Sicherheit';
  String get confirmDeletes => isTr ? 'Silmeden önce sor' : 'Vor Löschen bestätigen';

  String get sectionAccount => isTr ? 'Konto' : 'Konto';
  String get logout => isTr ? 'Çıkış' : 'Logout';

  String get sectionAbout => isTr ? 'Hakkında' : 'Info';
  String get infoText => isTr
      ? 'Bu ayarlar cihazda kaydedilir (SharedPreferences).'
      : 'Diese Einstellungen werden lokal gespeichert (SharedPreferences).';
}
