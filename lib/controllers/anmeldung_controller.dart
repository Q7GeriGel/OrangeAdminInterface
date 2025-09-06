import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnmeldungController extends ChangeNotifier {
  String _anzeigeName = 'Benutzer';
  String get anzeigeName => _anzeigeName;

  Future<void> lade() async {
    final sp = await SharedPreferences.getInstance();
    _anzeigeName = sp.getString('benutzer_name') ?? 'Benutzer';
    notifyListeners();
  }

  Future<void> setzeAnzeigeName(String name) async {
    final sp = await SharedPreferences.getInstance();
    _anzeigeName = (name.trim().isEmpty) ? 'Benutzer' : name.trim();
    await sp.setString('benutzer_name', _anzeigeName);
    notifyListeners();
  }
}
