import 'dart:async';
import '../models/app_settings.dart';

/// Simpler In-Memory Store (später hier DB/REST/WebAPI einhängen)
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  AppSettings _current = AppSettings();
  final _controller = StreamController<AppSettings>.broadcast();

  Future<AppSettings> load() async {
    return _current;
  }

  Future<void> save(AppSettings updated) async {
    _current = updated;
    _controller.add(_current);
  }

  Stream<AppSettings> watch() => _controller.stream;
}
