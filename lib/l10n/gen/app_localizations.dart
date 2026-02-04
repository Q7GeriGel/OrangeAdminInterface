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
  /// In tr, this message translates to:
  /// **'Friseur Orange'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş'**
  String get login;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get register;

  /// No description provided for @username.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adı'**
  String get username;

  /// No description provided for @password.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get signUp;

  /// No description provided for @emptyCredentials.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen kullanıcı adı ve şifre girin.'**
  String get emptyCredentials;

  /// No description provided for @wrongCredentials.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adı veya şifre hatalı.'**
  String get wrongCredentials;

  /// No description provided for @usernameTaken.
  ///
  /// In tr, this message translates to:
  /// **'Bu kullanıcı adı zaten kullanılıyor.'**
  String get usernameTaken;

  /// No description provided for @registerSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı. Şimdi giriş yapabilirsin.'**
  String get registerSuccess;

  /// No description provided for @dashboard.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol Paneli'**
  String get dashboard;

  /// No description provided for @customers.
  ///
  /// In tr, this message translates to:
  /// **'Müşteriler'**
  String get customers;

  /// No description provided for @employees.
  ///
  /// In tr, this message translates to:
  /// **'Çalışanlar'**
  String get employees;

  /// No description provided for @schedule.
  ///
  /// In tr, this message translates to:
  /// **'Randevular'**
  String get schedule;

  /// No description provided for @statistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @darkMode.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Mod'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @langGerman.
  ///
  /// In tr, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @langTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @appointmentsOverview.
  ///
  /// In tr, this message translates to:
  /// **'Randevu Görünümü'**
  String get appointmentsOverview;

  /// No description provided for @newAppointment.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Randevu'**
  String get newAppointment;

  /// No description provided for @idleMe.
  ///
  /// In tr, this message translates to:
  /// **'Boş Zaman (Ben)'**
  String get idleMe;

  /// No description provided for @week.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get week;

  /// No description provided for @month.
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get month;

  /// No description provided for @year.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get year;

  /// No description provided for @appointments.
  ///
  /// In tr, this message translates to:
  /// **'Randevular'**
  String get appointments;

  /// No description provided for @utilization.
  ///
  /// In tr, this message translates to:
  /// **'Doluluk'**
  String get utilization;

  /// No description provided for @noShows.
  ///
  /// In tr, this message translates to:
  /// **'No-Show'**
  String get noShows;

  /// No description provided for @revenue.
  ///
  /// In tr, this message translates to:
  /// **'Ciro'**
  String get revenue;

  /// No description provided for @booked.
  ///
  /// In tr, this message translates to:
  /// **'rezervasyon'**
  String get booked;

  /// No description provided for @average.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get average;

  /// No description provided for @notAppeared.
  ///
  /// In tr, this message translates to:
  /// **'gelmedi'**
  String get notAppeared;

  /// No description provided for @last7Days.
  ///
  /// In tr, this message translates to:
  /// **'son 7 gün'**
  String get last7Days;

  /// No description provided for @revenueTrend.
  ///
  /// In tr, this message translates to:
  /// **'Ciro Trend'**
  String get revenueTrend;

  /// No description provided for @trendByRange.
  ///
  /// In tr, this message translates to:
  /// **'Zamana göre trend'**
  String get trendByRange;

  /// No description provided for @total.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @serviceMix.
  ///
  /// In tr, this message translates to:
  /// **'Hizmet Dağılımı'**
  String get serviceMix;

  /// No description provided for @shareByService.
  ///
  /// In tr, this message translates to:
  /// **'Hizmete göre pay'**
  String get shareByService;

  /// No description provided for @haircut.
  ///
  /// In tr, this message translates to:
  /// **'Saç kesimi'**
  String get haircut;

  /// No description provided for @beard.
  ///
  /// In tr, this message translates to:
  /// **'Sakal'**
  String get beard;

  /// No description provided for @color.
  ///
  /// In tr, this message translates to:
  /// **'Boya'**
  String get color;

  /// No description provided for @appointmentsUtilNoShows.
  ///
  /// In tr, this message translates to:
  /// **'Randevular · Doluluk · No-Show'**
  String get appointmentsUtilNoShows;

  /// No description provided for @utilizationShort.
  ///
  /// In tr, this message translates to:
  /// **'Doluluk'**
  String get utilizationShort;

  /// No description provided for @scaleInfo.
  ///
  /// In tr, this message translates to:
  /// **'Skala: 0 – max'**
  String get scaleInfo;

  /// No description provided for @monShort.
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get monShort;

  /// No description provided for @tueShort.
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get tueShort;

  /// No description provided for @wedShort.
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get wedShort;

  /// No description provided for @thuShort.
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get thuShort;

  /// No description provided for @friShort.
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get friShort;

  /// No description provided for @satShort.
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get satShort;

  /// No description provided for @sunShort.
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get sunShort;

  /// No description provided for @createAppointmentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni randevu'**
  String get createAppointmentTitle;

  /// No description provided for @customerName.
  ///
  /// In tr, this message translates to:
  /// **'Müşteri'**
  String get customerName;

  /// No description provided for @employee.
  ///
  /// In tr, this message translates to:
  /// **'Çalışan'**
  String get employee;

  /// No description provided for @date.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get date;

  /// No description provided for @startTime.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get startTime;

  /// No description provided for @durationMinutes.
  ///
  /// In tr, this message translates to:
  /// **'Süre (dk)'**
  String get durationMinutes;

  /// No description provided for @status.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get status;

  /// No description provided for @statusOpen.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get statusOpen;

  /// No description provided for @statusConfirmed.
  ///
  /// In tr, this message translates to:
  /// **'Onaylı'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get statusCancelled;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get create;

  /// No description provided for @invalidDay.
  ///
  /// In tr, this message translates to:
  /// **'Pazar günü randevu oluşturulamaz.'**
  String get invalidDay;

  /// No description provided for @invalidTimeRange.
  ///
  /// In tr, this message translates to:
  /// **'Randevu 20:00\'dan sonra bitemez.'**
  String get invalidTimeRange;

  /// No description provided for @invalidWorkHours.
  ///
  /// In tr, this message translates to:
  /// **'Randevular 08:00–20:00 arasında olmalı.'**
  String get invalidWorkHours;

  /// No description provided for @successAppointmentSaved.
  ///
  /// In tr, this message translates to:
  /// **'Randevu kaydedildi ✅'**
  String get successAppointmentSaved;

  /// No description provided for @allowedAccountsHint.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılabilir hesaplar: serkan / sedat / samet (Şifre: 123)'**
  String get allowedAccountsHint;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get logout;

  /// No description provided for @logoutDone.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapıldı.'**
  String get logoutDone;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @prevWeek.
  ///
  /// In tr, this message translates to:
  /// **'Önceki hafta'**
  String get prevWeek;

  /// No description provided for @nextWeek.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki hafta'**
  String get nextWeek;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @details.
  ///
  /// In tr, this message translates to:
  /// **'Detaylar'**
  String get details;

  /// No description provided for @moveTime.
  ///
  /// In tr, this message translates to:
  /// **'Saati değiştir'**
  String get moveTime;

  /// No description provided for @changeDuration.
  ///
  /// In tr, this message translates to:
  /// **'Süreyi değiştir'**
  String get changeDuration;

  /// No description provided for @toggleStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durumu değiştir'**
  String get toggleStatus;

  /// No description provided for @cancelAppointment.
  ///
  /// In tr, this message translates to:
  /// **'İptal et'**
  String get cancelAppointment;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @customerRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen müşteri adını girin.'**
  String get customerRequired;

  /// No description provided for @totalRevenue.
  ///
  /// In tr, this message translates to:
  /// **'Toplam ciro'**
  String get totalRevenue;

  /// No description provided for @allowedAccountsNote.
  ///
  /// In tr, this message translates to:
  /// **'İzinli hesaplar: serkan / sedat / samet (Şifre: 123)'**
  String get allowedAccountsNote;

  /// No description provided for @account.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get account;

  /// No description provided for @roleAdmin.
  ///
  /// In tr, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleStaff.
  ///
  /// In tr, this message translates to:
  /// **'Personel'**
  String get roleStaff;

  /// No description provided for @employeesSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İç sistem • Ekip & Notlar'**
  String get employeesSubtitle;

  /// No description provided for @freeSlotsToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün boş saatler'**
  String get freeSlotsToday;

  /// No description provided for @notesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get notesTitle;

  /// No description provided for @notesSaved.
  ///
  /// In tr, this message translates to:
  /// **'Notlar kaydedildi ✅'**
  String get notesSaved;

  /// No description provided for @notesHint.
  ///
  /// In tr, this message translates to:
  /// **'Notlar…'**
  String get notesHint;

  /// No description provided for @noPermissionAdminOnly.
  ///
  /// In tr, this message translates to:
  /// **'Yetki yok (sadece admin).'**
  String get noPermissionAdminOnly;

  /// No description provided for @saved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi ✅'**
  String get saved;
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
