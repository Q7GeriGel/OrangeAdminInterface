// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Friseur Orange';

  @override
  String get login => 'Giriş';

  @override
  String get register => 'Kayıt';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get password => 'Şifre';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get signUp => 'Kayıt ol';

  @override
  String get emptyCredentials => 'Lütfen kullanıcı adı ve şifre gir.';

  @override
  String get wrongCredentials => 'Kullanıcı adı veya şifre yanlış.';

  @override
  String get allowedAccountsHint =>
      'Kullanılabilir hesaplar: serkan / sedat / samet (Şifre: 123)';

  @override
  String get dashboard => 'Panel';

  @override
  String get customers => 'Müşteriler';

  @override
  String get employees => 'Çalışanlar';

  @override
  String get schedule => 'Randevular';

  @override
  String get statistics => 'İstatistik';

  @override
  String get settings => 'Ayarlar';

  @override
  String get logout => 'Çıkış';

  @override
  String get logoutDone => 'Çıkış yapıldı.';

  @override
  String get save => 'Kaydet';

  @override
  String get saved => 'Kaydedildi ✅';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get close => 'Kapat';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get apply => 'Uygula';

  @override
  String get reset => 'Sıfırla';

  @override
  String get undo => 'Geri al';

  @override
  String get ok => 'Tamam';

  @override
  String get minutesShort => 'dk';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get langGerman => 'Almanca';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get welcome => 'Hoş geldin';

  @override
  String get dailyPlan => 'Gün planın:';

  @override
  String get refreshToday => 'Bugünü yenile';

  @override
  String get refreshed => 'Güncellendi ✅';

  @override
  String get newAppointment => 'Yeni Randevu';

  @override
  String get newCustomer => 'Yeni Müşteri';

  @override
  String get customerCreated => 'Müşteri oluşturuldu:';

  @override
  String get successAppointmentSaved => 'Randevu kaydedildi ✅';

  @override
  String get kpiAppointmentsToday => 'Bugünkü randevu';

  @override
  String get kpiNextAppointment => 'Sıradaki randevu';

  @override
  String get kpiFreeSlots => 'Boş slot';

  @override
  String get kpiChanges => 'Değişiklik';

  @override
  String get appointmentsOverview => 'Randevu Görünümü';

  @override
  String get noPermissionAdminOnly => 'Yetki yok (sadece admin).';

  @override
  String get today => 'Bugün';

  @override
  String get prevWeek => 'Önceki hafta';

  @override
  String get nextWeek => 'Sonraki hafta';

  @override
  String get monShort => 'Pzt';

  @override
  String get tueShort => 'Sal';

  @override
  String get wedShort => 'Çar';

  @override
  String get thuShort => 'Per';

  @override
  String get friShort => 'Cum';

  @override
  String get satShort => 'Cmt';

  @override
  String get sunShort => 'Paz';

  @override
  String get customersTitle => 'Müşteriler';

  @override
  String get searchHintCustomers =>
      'İsim, telefon veya tarih ile ara (dd.MM.yyyy)';

  @override
  String get filterTitle => 'Filtre';

  @override
  String get filterActivePrefix => 'Aktif filtre:';

  @override
  String get filterRegularLabel => 'Daimi müşteri:';

  @override
  String get filterEmployeeLabel => 'Berber:';

  @override
  String get filterAny => 'Fark etmez';

  @override
  String get filterOnlyRegulars => 'Sadece daimi';

  @override
  String get filterOnlyNonRegulars => 'Daimi olmayan';

  @override
  String get pickNextAppointment => 'Sonraki randevuyu seç';

  @override
  String get tableName => 'İsim';

  @override
  String get tablePhone => 'Telefon';

  @override
  String get tableLastVisit => 'Son';

  @override
  String get tableNextAppointment => 'Sonraki randevu';

  @override
  String get tableStaff => 'Berber';

  @override
  String get tableActions => 'İşlemler';

  @override
  String get tooltipEdit => 'Düzenle';

  @override
  String get tooltipSetAppointment => 'Randevu belirle';

  @override
  String get tooltipDelete => 'Sil';

  @override
  String get confirmDeleteTitle => 'Silinsin mi?';

  @override
  String get confirmDeleteCustomerText =>
      'Bu müşteriyi gerçekten silmek istiyor musun?';

  @override
  String get deletedCustomer => 'Müşteri silindi.';

  @override
  String get confirmDeleteAppointmentText =>
      'Bu randevuyu gerçekten silmek istiyor musun?';

  @override
  String get deletedAppointment => 'Randevu silindi.';

  @override
  String get employeesSubtitle => 'İç sistem • Ekip & Notlar';

  @override
  String get account => 'Hesap';

  @override
  String get accountPanelHint =>
      'Görünüm; Panel / Randevular / İstatistik ekranlarını filtreler.';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleStaff => 'Personel';

  @override
  String get freeSlotsToday => 'Bugün boş saatler';

  @override
  String get notesTitle => 'Notlar';

  @override
  String get notesHint => 'Notlar…';

  @override
  String get notesDefaultTemplate =>
      'Ne oldu?\nHangi müşteriler gelmedi?\nNe iyi/kötü gitti?\nYarın ne hazırlanmalı?';

  @override
  String get notesSaved => 'Notlar kaydedildi ✅';

  @override
  String get noteSavedSnack => 'Not kaydedildi ✅';

  @override
  String get free => 'boş';

  @override
  String get booked => 'dolu';

  @override
  String get statisticsTitle => 'İstatistik';

  @override
  String get team => 'Ekip';

  @override
  String get onlyMe => 'Sadece ben';

  @override
  String get forMe => 'benim için';

  @override
  String get forTeam => 'ekip';

  @override
  String get revenueTrendWeekTitle => 'Ciro trendi (hafta)';

  @override
  String get idleHeatmapTitle => 'Boşluk ısı haritası (gün/saat)';

  @override
  String get idleHeatmapFor => 'Şunun için:';

  @override
  String get legendIdle => 'Boş (müsait)';

  @override
  String get legendBooked => 'Dolu';

  @override
  String get metricWeekRevenue => 'Toplam ciro (hafta)';

  @override
  String get metricTodayRevenue => 'Bugünün cirosu';

  @override
  String get metricIdleToday => 'Bugün boş süre';

  @override
  String get metricUtilToday => 'Bugün doluluk';

  @override
  String get freeSlotsTop => 'Bugün boş slotlar (Top)';

  @override
  String get adminToolsLater => 'Admin araçları (sonra)';

  @override
  String get adminToolsDesc =>
      'Dışa aktarım / gelişmiş filtreler / ekip raporları';

  @override
  String get createAppointmentTitle => 'Yeni randevu';

  @override
  String get customerName => 'Müşteri';

  @override
  String get customerHintExample => 'örn. Lara Demir';

  @override
  String get employee => 'Çalışan';

  @override
  String get date => 'Tarih';

  @override
  String get startTime => 'Başlangıç';

  @override
  String get durationMinutes => 'Süre (dk)';

  @override
  String get status => 'Durum';

  @override
  String get statusOpen => 'Açık';

  @override
  String get statusConfirmed => 'Onaylı';

  @override
  String get statusCancelled => 'İptal';

  @override
  String get create => 'Oluştur';

  @override
  String get invalidDay => 'Pazar günü randevu oluşturulamaz.';

  @override
  String get invalidTimeRange => 'Randevu 20:00\'dan sonra bitemez.';

  @override
  String get invalidWorkHours => 'Randevular 08:00–20:00 arasında olmalı.';

  @override
  String get customerRequired => 'Lütfen müşteri adını gir.';

  @override
  String get appointmentDetailsTitle => 'Randevu Detayları';

  @override
  String get details => 'Detaylar';

  @override
  String get moveTime => 'Saati değiştir';

  @override
  String get changeDuration => 'Süre';

  @override
  String get durationChangeTitle => 'Süreyi değiştir';

  @override
  String get toggleStatus => 'Durum';

  @override
  String get cancelAppointment => 'İptal et';

  @override
  String get viewOnlyNoEdit => 'Sadece görüntüleme (düzenleme yok)';

  @override
  String get boxCurrentChangesTitle => 'Güncel Değişiklikler';

  @override
  String get boxCurrentChangesEmpty => 'Henüz değişiklik yok';

  @override
  String get boxUpcomingCustomersTitle => 'Yaklaşan Müşteriler';

  @override
  String get boxUpcomingCustomersEmpty => 'Bugün başka randevu yok';

  @override
  String get boxFreeSlotsTodayTitle => 'Bugün Boş Zamanlar';

  @override
  String get boxFreeSlotsTodayEmpty => 'Bugün boş slot yok';
}
