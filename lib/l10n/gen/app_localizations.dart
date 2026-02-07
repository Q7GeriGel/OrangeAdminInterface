import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Friseur Orange'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get register;

  /// No description provided for @username.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get username;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In de, this message translates to:
  /// **'Einloggen'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get signUp;

  /// No description provided for @emptyCredentials.
  ///
  /// In de, this message translates to:
  /// **'Bitte Benutzername und Passwort eingeben.'**
  String get emptyCredentials;

  /// No description provided for @wrongCredentials.
  ///
  /// In de, this message translates to:
  /// **'Falscher Benutzername oder Passwort.'**
  String get wrongCredentials;

  /// No description provided for @allowedAccountsHint.
  ///
  /// In de, this message translates to:
  /// **'Zulässige Accounts: serkan / sedat / samet (Passwort: 123)'**
  String get allowedAccountsHint;

  /// No description provided for @dashboard.
  ///
  /// In de, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @customers.
  ///
  /// In de, this message translates to:
  /// **'Kunden'**
  String get customers;

  /// No description provided for @employees.
  ///
  /// In de, this message translates to:
  /// **'Mitarbeiter'**
  String get employees;

  /// No description provided for @schedule.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get schedule;

  /// No description provided for @statistics.
  ///
  /// In de, this message translates to:
  /// **'Statistik'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDone.
  ///
  /// In de, this message translates to:
  /// **'Du wurdest ausgeloggt.'**
  String get logoutDone;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In de, this message translates to:
  /// **'Gespeichert ✅'**
  String get saved;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get edit;

  /// No description provided for @apply.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get reset;

  /// No description provided for @undo.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get undo;

  /// No description provided for @ok.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @minutesShort.
  ///
  /// In de, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @darkMode.
  ///
  /// In de, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @themeLight.
  ///
  /// In de, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In de, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @langGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @langTurkish.
  ///
  /// In de, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @welcome.
  ///
  /// In de, this message translates to:
  /// **'Willkommen'**
  String get welcome;

  /// No description provided for @dailyPlan.
  ///
  /// In de, this message translates to:
  /// **'Hier ist dein Tagesplan:'**
  String get dailyPlan;

  /// No description provided for @refreshToday.
  ///
  /// In de, this message translates to:
  /// **'Heute aktualisieren'**
  String get refreshToday;

  /// No description provided for @refreshed.
  ///
  /// In de, this message translates to:
  /// **'Aktualisiert ✅'**
  String get refreshed;

  /// No description provided for @newAppointment.
  ///
  /// In de, this message translates to:
  /// **'Neuer Termin'**
  String get newAppointment;

  /// No description provided for @newCustomer.
  ///
  /// In de, this message translates to:
  /// **'Neuer Kunde'**
  String get newCustomer;

  /// No description provided for @customerCreated.
  ///
  /// In de, this message translates to:
  /// **'Kunde erstellt:'**
  String get customerCreated;

  /// No description provided for @successAppointmentSaved.
  ///
  /// In de, this message translates to:
  /// **'Termin gespeichert ✅'**
  String get successAppointmentSaved;

  /// No description provided for @kpiAppointmentsToday.
  ///
  /// In de, this message translates to:
  /// **'Termine heute'**
  String get kpiAppointmentsToday;

  /// No description provided for @kpiNextAppointment.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin'**
  String get kpiNextAppointment;

  /// No description provided for @kpiFreeSlots.
  ///
  /// In de, this message translates to:
  /// **'Freie Slots'**
  String get kpiFreeSlots;

  /// No description provided for @kpiChanges.
  ///
  /// In de, this message translates to:
  /// **'Änderungen'**
  String get kpiChanges;

  /// No description provided for @appointmentsOverview.
  ///
  /// In de, this message translates to:
  /// **'Terminübersicht'**
  String get appointmentsOverview;

  /// No description provided for @noPermissionAdminOnly.
  ///
  /// In de, this message translates to:
  /// **'Keine Berechtigung (nur Admin).'**
  String get noPermissionAdminOnly;

  /// No description provided for @today.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get today;

  /// No description provided for @prevWeek.
  ///
  /// In de, this message translates to:
  /// **'Vorherige Woche'**
  String get prevWeek;

  /// No description provided for @nextWeek.
  ///
  /// In de, this message translates to:
  /// **'Nächste Woche'**
  String get nextWeek;

  /// No description provided for @monShort.
  ///
  /// In de, this message translates to:
  /// **'Mo'**
  String get monShort;

  /// No description provided for @tueShort.
  ///
  /// In de, this message translates to:
  /// **'Di'**
  String get tueShort;

  /// No description provided for @wedShort.
  ///
  /// In de, this message translates to:
  /// **'Mi'**
  String get wedShort;

  /// No description provided for @thuShort.
  ///
  /// In de, this message translates to:
  /// **'Do'**
  String get thuShort;

  /// No description provided for @friShort.
  ///
  /// In de, this message translates to:
  /// **'Fr'**
  String get friShort;

  /// No description provided for @satShort.
  ///
  /// In de, this message translates to:
  /// **'Sa'**
  String get satShort;

  /// No description provided for @sunShort.
  ///
  /// In de, this message translates to:
  /// **'So'**
  String get sunShort;

  /// No description provided for @customersTitle.
  ///
  /// In de, this message translates to:
  /// **'Kunden'**
  String get customersTitle;

  /// No description provided for @searchHintCustomers.
  ///
  /// In de, this message translates to:
  /// **'Suche bei Name, Telefonnummer oder Datum (dd.MM.yyyy)'**
  String get searchHintCustomers;

  /// No description provided for @filterTitle.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterActivePrefix.
  ///
  /// In de, this message translates to:
  /// **'Filter aktiv:'**
  String get filterActivePrefix;

  /// No description provided for @filterRegularLabel.
  ///
  /// In de, this message translates to:
  /// **'Stammkunde:'**
  String get filterRegularLabel;

  /// No description provided for @filterEmployeeLabel.
  ///
  /// In de, this message translates to:
  /// **'Friseur:'**
  String get filterEmployeeLabel;

  /// No description provided for @filterAny.
  ///
  /// In de, this message translates to:
  /// **'Egal'**
  String get filterAny;

  /// No description provided for @filterOnlyRegulars.
  ///
  /// In de, this message translates to:
  /// **'Nur Stammkunden'**
  String get filterOnlyRegulars;

  /// No description provided for @filterOnlyNonRegulars.
  ///
  /// In de, this message translates to:
  /// **'Nur Nicht-Stammkunden'**
  String get filterOnlyNonRegulars;

  /// No description provided for @pickNextAppointment.
  ///
  /// In de, this message translates to:
  /// **'Nächsten Termin auswählen'**
  String get pickNextAppointment;

  /// No description provided for @tableName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get tableName;

  /// No description provided for @tablePhone.
  ///
  /// In de, this message translates to:
  /// **'Telefon'**
  String get tablePhone;

  /// No description provided for @tableLastVisit.
  ///
  /// In de, this message translates to:
  /// **'Letzter'**
  String get tableLastVisit;

  /// No description provided for @tableNextAppointment.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin'**
  String get tableNextAppointment;

  /// No description provided for @tableStaff.
  ///
  /// In de, this message translates to:
  /// **'Friseur'**
  String get tableStaff;

  /// No description provided for @tableActions.
  ///
  /// In de, this message translates to:
  /// **'Aktionen'**
  String get tableActions;

  /// No description provided for @tooltipEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get tooltipEdit;

  /// No description provided for @tooltipSetAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin setzen'**
  String get tooltipSetAppointment;

  /// No description provided for @tooltipDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get tooltipDelete;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Wirklich löschen?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteCustomerText.
  ///
  /// In de, this message translates to:
  /// **'Willst du diesen Kunden wirklich löschen?'**
  String get confirmDeleteCustomerText;

  /// No description provided for @deletedCustomer.
  ///
  /// In de, this message translates to:
  /// **'Kunde gelöscht.'**
  String get deletedCustomer;

  /// No description provided for @confirmDeleteAppointmentText.
  ///
  /// In de, this message translates to:
  /// **'Willst du diesen Termin wirklich löschen?'**
  String get confirmDeleteAppointmentText;

  /// No description provided for @deletedAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin gelöscht.'**
  String get deletedAppointment;

  /// No description provided for @employeesSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Intern • Team-Übersicht & Notizen'**
  String get employeesSubtitle;

  /// No description provided for @account.
  ///
  /// In de, this message translates to:
  /// **'Konto'**
  String get account;

  /// No description provided for @accountPanelHint.
  ///
  /// In de, this message translates to:
  /// **'Ansicht filtert Dashboard / Termine / Statistik.'**
  String get accountPanelHint;

  /// No description provided for @roleAdmin.
  ///
  /// In de, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleStaff.
  ///
  /// In de, this message translates to:
  /// **'Mitarbeiter'**
  String get roleStaff;

  /// No description provided for @freeSlotsToday.
  ///
  /// In de, this message translates to:
  /// **'Freie Zeitfenster heute'**
  String get freeSlotsToday;

  /// No description provided for @notesTitle.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get notesTitle;

  /// No description provided for @notesHint.
  ///
  /// In de, this message translates to:
  /// **'Notizen…'**
  String get notesHint;

  /// No description provided for @notesDefaultTemplate.
  ///
  /// In de, this message translates to:
  /// **'Was ist passiert?\nWelche Kunden kamen nicht?\nWas lief gut/schlecht?\nWas soll morgen vorbereitet werden?'**
  String get notesDefaultTemplate;

  /// No description provided for @notesSaved.
  ///
  /// In de, this message translates to:
  /// **'Notizen gespeichert ✅'**
  String get notesSaved;

  /// No description provided for @noteSavedSnack.
  ///
  /// In de, this message translates to:
  /// **'Notiz gespeichert ✅'**
  String get noteSavedSnack;

  /// No description provided for @free.
  ///
  /// In de, this message translates to:
  /// **'frei'**
  String get free;

  /// No description provided for @booked.
  ///
  /// In de, this message translates to:
  /// **'gebucht'**
  String get booked;

  /// No description provided for @statisticsTitle.
  ///
  /// In de, this message translates to:
  /// **'Statistik'**
  String get statisticsTitle;

  /// No description provided for @team.
  ///
  /// In de, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @onlyMe.
  ///
  /// In de, this message translates to:
  /// **'Nur ich'**
  String get onlyMe;

  /// No description provided for @forMe.
  ///
  /// In de, this message translates to:
  /// **'für mich'**
  String get forMe;

  /// No description provided for @forTeam.
  ///
  /// In de, this message translates to:
  /// **'Team'**
  String get forTeam;

  /// No description provided for @revenueTrendWeekTitle.
  ///
  /// In de, this message translates to:
  /// **'Umsatz-Verlauf (Woche)'**
  String get revenueTrendWeekTitle;

  /// No description provided for @idleHeatmapTitle.
  ///
  /// In de, this message translates to:
  /// **'Leerlauf-Heatmap (pro Tag/Zeitslot)'**
  String get idleHeatmapTitle;

  /// No description provided for @idleHeatmapFor.
  ///
  /// In de, this message translates to:
  /// **'Für:'**
  String get idleHeatmapFor;

  /// No description provided for @legendIdle.
  ///
  /// In de, this message translates to:
  /// **'Leerlauf (frei)'**
  String get legendIdle;

  /// No description provided for @legendBooked.
  ///
  /// In de, this message translates to:
  /// **'Belegt'**
  String get legendBooked;

  /// No description provided for @metricWeekRevenue.
  ///
  /// In de, this message translates to:
  /// **'Gesamtumsatz (Woche)'**
  String get metricWeekRevenue;

  /// No description provided for @metricTodayRevenue.
  ///
  /// In de, this message translates to:
  /// **'Umsatz heute'**
  String get metricTodayRevenue;

  /// No description provided for @metricIdleToday.
  ///
  /// In de, this message translates to:
  /// **'Leerlauf heute'**
  String get metricIdleToday;

  /// No description provided for @metricUtilToday.
  ///
  /// In de, this message translates to:
  /// **'Auslastung heute'**
  String get metricUtilToday;

  /// No description provided for @freeSlotsTop.
  ///
  /// In de, this message translates to:
  /// **'Freie Slots heute (Top)'**
  String get freeSlotsTop;

  /// No description provided for @adminToolsLater.
  ///
  /// In de, this message translates to:
  /// **'Admin-Tools (später)'**
  String get adminToolsLater;

  /// No description provided for @adminToolsDesc.
  ///
  /// In de, this message translates to:
  /// **'Export / erweiterte Filter / Team-Auswertungen'**
  String get adminToolsDesc;

  /// No description provided for @createAppointmentTitle.
  ///
  /// In de, this message translates to:
  /// **'Neuer Termin'**
  String get createAppointmentTitle;

  /// No description provided for @customerName.
  ///
  /// In de, this message translates to:
  /// **'Kunde'**
  String get customerName;

  /// No description provided for @customerHintExample.
  ///
  /// In de, this message translates to:
  /// **'z.B. Lara Demir'**
  String get customerHintExample;

  /// No description provided for @employee.
  ///
  /// In de, this message translates to:
  /// **'Mitarbeiter'**
  String get employee;

  /// No description provided for @date.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @startTime.
  ///
  /// In de, this message translates to:
  /// **'Startzeit'**
  String get startTime;

  /// No description provided for @durationMinutes.
  ///
  /// In de, this message translates to:
  /// **'Dauer (Min.)'**
  String get durationMinutes;

  /// No description provided for @status.
  ///
  /// In de, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusOpen.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get statusOpen;

  /// No description provided for @statusConfirmed.
  ///
  /// In de, this message translates to:
  /// **'Bestätigt'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In de, this message translates to:
  /// **'Abgesagt'**
  String get statusCancelled;

  /// No description provided for @create.
  ///
  /// In de, this message translates to:
  /// **'Erstellen'**
  String get create;

  /// No description provided for @invalidDay.
  ///
  /// In de, this message translates to:
  /// **'Sonntag ist nicht erlaubt.'**
  String get invalidDay;

  /// No description provided for @invalidTimeRange.
  ///
  /// In de, this message translates to:
  /// **'Termin endet nach 20:00.'**
  String get invalidTimeRange;

  /// No description provided for @invalidWorkHours.
  ///
  /// In de, this message translates to:
  /// **'Termine müssen zwischen 08:00 und 20:00 liegen.'**
  String get invalidWorkHours;

  /// No description provided for @customerRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte Kundennamen eingeben.'**
  String get customerRequired;

  /// No description provided for @appointmentDetailsTitle.
  ///
  /// In de, this message translates to:
  /// **'Termin Details'**
  String get appointmentDetailsTitle;

  /// No description provided for @details.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @moveTime.
  ///
  /// In de, this message translates to:
  /// **'Verschieben'**
  String get moveTime;

  /// No description provided for @changeDuration.
  ///
  /// In de, this message translates to:
  /// **'Dauer'**
  String get changeDuration;

  /// No description provided for @durationChangeTitle.
  ///
  /// In de, this message translates to:
  /// **'Dauer ändern'**
  String get durationChangeTitle;

  /// No description provided for @toggleStatus.
  ///
  /// In de, this message translates to:
  /// **'Status'**
  String get toggleStatus;

  /// No description provided for @cancelAppointment.
  ///
  /// In de, this message translates to:
  /// **'Stornieren'**
  String get cancelAppointment;

  /// No description provided for @viewOnlyNoEdit.
  ///
  /// In de, this message translates to:
  /// **'Nur Ansicht (keine Bearbeitung)'**
  String get viewOnlyNoEdit;

  /// No description provided for @boxCurrentChangesTitle.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Änderungen'**
  String get boxCurrentChangesTitle;

  /// No description provided for @boxCurrentChangesEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Änderungen'**
  String get boxCurrentChangesEmpty;

  /// No description provided for @boxUpcomingCustomersTitle.
  ///
  /// In de, this message translates to:
  /// **'Bevorstehende Kunden'**
  String get boxUpcomingCustomersTitle;

  /// No description provided for @boxUpcomingCustomersEmpty.
  ///
  /// In de, this message translates to:
  /// **'Keine Termine mehr heute'**
  String get boxUpcomingCustomersEmpty;

  /// No description provided for @boxFreeSlotsTodayTitle.
  ///
  /// In de, this message translates to:
  /// **'Freie Zeitfenster heute'**
  String get boxFreeSlotsTodayTitle;

  /// No description provided for @boxFreeSlotsTodayEmpty.
  ///
  /// In de, this message translates to:
  /// **'Heute keine freien Slots'**
  String get boxFreeSlotsTodayEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
