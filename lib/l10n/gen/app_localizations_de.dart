// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Friseur Orange';

  @override
  String get login => 'Login';

  @override
  String get register => 'Registrieren';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get signIn => 'Einloggen';

  @override
  String get signUp => 'Registrieren';

  @override
  String get emptyCredentials => 'Bitte Benutzername und Passwort eingeben.';

  @override
  String get wrongCredentials => 'Falscher Benutzername oder Passwort.';

  @override
  String get allowedAccountsHint =>
      'Zulässige Accounts: serkan / sedat / samet (Passwort: 123)';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get customers => 'Kunden';

  @override
  String get employees => 'Mitarbeiter';

  @override
  String get schedule => 'Termine';

  @override
  String get statistics => 'Statistik';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDone => 'Du wurdest ausgeloggt.';

  @override
  String get save => 'Speichern';

  @override
  String get saved => 'Gespeichert ✅';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get apply => 'Übernehmen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get ok => 'OK';

  @override
  String get minutesShort => 'min';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Sprache';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get welcome => 'Willkommen';

  @override
  String get dailyPlan => 'Hier ist dein Tagesplan:';

  @override
  String get refreshToday => 'Heute aktualisieren';

  @override
  String get refreshed => 'Aktualisiert ✅';

  @override
  String get newAppointment => 'Neuer Termin';

  @override
  String get newCustomer => 'Neuer Kunde';

  @override
  String get customerCreated => 'Kunde erstellt:';

  @override
  String get successAppointmentSaved => 'Termin gespeichert ✅';

  @override
  String get kpiAppointmentsToday => 'Termine heute';

  @override
  String get kpiNextAppointment => 'Nächster Termin';

  @override
  String get kpiFreeSlots => 'Freie Slots';

  @override
  String get kpiChanges => 'Änderungen';

  @override
  String get appointmentsOverview => 'Terminübersicht';

  @override
  String get noPermissionAdminOnly => 'Keine Berechtigung (nur Admin).';

  @override
  String get today => 'Heute';

  @override
  String get prevWeek => 'Vorherige Woche';

  @override
  String get nextWeek => 'Nächste Woche';

  @override
  String get monShort => 'Mo';

  @override
  String get tueShort => 'Di';

  @override
  String get wedShort => 'Mi';

  @override
  String get thuShort => 'Do';

  @override
  String get friShort => 'Fr';

  @override
  String get satShort => 'Sa';

  @override
  String get sunShort => 'So';

  @override
  String get customersTitle => 'Kunden';

  @override
  String get searchHintCustomers =>
      'Suche bei Name, Telefonnummer oder Datum (dd.MM.yyyy)';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterActivePrefix => 'Filter aktiv:';

  @override
  String get filterRegularLabel => 'Stammkunde:';

  @override
  String get filterEmployeeLabel => 'Friseur:';

  @override
  String get filterAny => 'Egal';

  @override
  String get filterOnlyRegulars => 'Nur Stammkunden';

  @override
  String get filterOnlyNonRegulars => 'Nur Nicht-Stammkunden';

  @override
  String get pickNextAppointment => 'Nächsten Termin auswählen';

  @override
  String get tableName => 'Name';

  @override
  String get tablePhone => 'Telefon';

  @override
  String get tableLastVisit => 'Letzter';

  @override
  String get tableNextAppointment => 'Nächster Termin';

  @override
  String get tableStaff => 'Friseur';

  @override
  String get tableActions => 'Aktionen';

  @override
  String get tooltipEdit => 'Bearbeiten';

  @override
  String get tooltipSetAppointment => 'Termin setzen';

  @override
  String get tooltipDelete => 'Löschen';

  @override
  String get confirmDeleteTitle => 'Wirklich löschen?';

  @override
  String get confirmDeleteCustomerText =>
      'Willst du diesen Kunden wirklich löschen?';

  @override
  String get deletedCustomer => 'Kunde gelöscht.';

  @override
  String get confirmDeleteAppointmentText =>
      'Willst du diesen Termin wirklich löschen?';

  @override
  String get deletedAppointment => 'Termin gelöscht.';

  @override
  String get employeesSubtitle => 'Intern • Team-Übersicht & Notizen';

  @override
  String get account => 'Konto';

  @override
  String get accountPanelHint =>
      'Ansicht filtert Dashboard / Termine / Statistik.';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleStaff => 'Mitarbeiter';

  @override
  String get freeSlotsToday => 'Freie Zeitfenster heute';

  @override
  String get notesTitle => 'Notizen';

  @override
  String get notesHint => 'Notizen…';

  @override
  String get notesDefaultTemplate =>
      'Was ist passiert?\nWelche Kunden kamen nicht?\nWas lief gut/schlecht?\nWas soll morgen vorbereitet werden?';

  @override
  String get notesSaved => 'Notizen gespeichert ✅';

  @override
  String get noteSavedSnack => 'Notiz gespeichert ✅';

  @override
  String get free => 'frei';

  @override
  String get booked => 'gebucht';

  @override
  String get statisticsTitle => 'Statistik';

  @override
  String get team => 'Team';

  @override
  String get onlyMe => 'Nur ich';

  @override
  String get forMe => 'für mich';

  @override
  String get forTeam => 'Team';

  @override
  String get revenueTrendWeekTitle => 'Umsatz-Verlauf (Woche)';

  @override
  String get idleHeatmapTitle => 'Leerlauf-Heatmap (pro Tag/Zeitslot)';

  @override
  String get idleHeatmapFor => 'Für:';

  @override
  String get legendIdle => 'Leerlauf (frei)';

  @override
  String get legendBooked => 'Belegt';

  @override
  String get metricWeekRevenue => 'Gesamtumsatz (Woche)';

  @override
  String get metricTodayRevenue => 'Umsatz heute';

  @override
  String get metricIdleToday => 'Leerlauf heute';

  @override
  String get metricUtilToday => 'Auslastung heute';

  @override
  String get freeSlotsTop => 'Freie Slots heute (Top)';

  @override
  String get adminToolsLater => 'Admin-Tools (später)';

  @override
  String get adminToolsDesc => 'Export / erweiterte Filter / Team-Auswertungen';

  @override
  String get createAppointmentTitle => 'Neuer Termin';

  @override
  String get customerName => 'Kunde';

  @override
  String get customerHintExample => 'z.B. Lara Demir';

  @override
  String get employee => 'Mitarbeiter';

  @override
  String get date => 'Datum';

  @override
  String get startTime => 'Startzeit';

  @override
  String get durationMinutes => 'Dauer (Min.)';

  @override
  String get status => 'Status';

  @override
  String get statusOpen => 'Offen';

  @override
  String get statusConfirmed => 'Bestätigt';

  @override
  String get statusCancelled => 'Abgesagt';

  @override
  String get create => 'Erstellen';

  @override
  String get invalidDay => 'Sonntag ist nicht erlaubt.';

  @override
  String get invalidTimeRange => 'Termin endet nach 20:00.';

  @override
  String get invalidWorkHours =>
      'Termine müssen zwischen 08:00 und 20:00 liegen.';

  @override
  String get customerRequired => 'Bitte Kundennamen eingeben.';

  @override
  String get appointmentDetailsTitle => 'Termin Details';

  @override
  String get details => 'Details';

  @override
  String get moveTime => 'Verschieben';

  @override
  String get changeDuration => 'Dauer';

  @override
  String get durationChangeTitle => 'Dauer ändern';

  @override
  String get toggleStatus => 'Status';

  @override
  String get cancelAppointment => 'Stornieren';

  @override
  String get viewOnlyNoEdit => 'Nur Ansicht (keine Bearbeitung)';

  @override
  String get boxCurrentChangesTitle => 'Aktuelle Änderungen';

  @override
  String get boxCurrentChangesEmpty => 'Noch keine Änderungen';

  @override
  String get boxUpcomingCustomersTitle => 'Bevorstehende Kunden';

  @override
  String get boxUpcomingCustomersEmpty => 'Keine Termine mehr heute';

  @override
  String get boxFreeSlotsTodayTitle => 'Freie Zeitfenster heute';

  @override
  String get boxFreeSlotsTodayEmpty => 'Heute keine freien Slots';
}
