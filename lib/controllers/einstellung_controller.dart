import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/settings_service.dart';

class EinstellungController extends ChangeNotifier {
  final _service = SettingsService.instance;
  AppSettings? _settings;
  AppSettings get settings => _settings ?? AppSettings();

  bool get loaded => _settings != null;

  Future<void> init() async {
    _settings = await _service.load();
    notifyListeners();
    _service.watch().listen((s) {
      _settings = s;
      notifyListeners();
    });
  }

  Future<void> update(void Function(AppSettings) updater) async {
    final copy = settings.copyWith();
    updater(copy);
    await _service.save(copy);
  }
}
