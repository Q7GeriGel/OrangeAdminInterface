/// Zentrale App-Konfiguration.
///
/// ⚠️ Für PROD niemals Credentials im Flutter-Code speichern.
/// Flutter spricht immer nur mit deiner REST-API.
/// Die REST-API verbindet sich dann mit MySQL (Aiven).
class AppConfig {
  /// API Base URL (z.B. http://localhost:5088 oder https://dein-api-host.tld)
  ///
  /// Setzen via:
  /// flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5088
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5088');

  /// Toggle: API an/aus (für Offline-Test mit Mock-Daten)
  ///
  /// flutter run -d chrome --dart-define=USE_API=false
  static const bool useApi = bool.fromEnvironment('USE_API', defaultValue: true);
}