import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotizenController extends ChangeNotifier {
  String _text = '';
  String get text => _text;

  String _key(DateTime d) => 'notiz_${d.year}_${d.month}_${d.day}';

  Future<void> lade(DateTime tag) async {
    final sp = await SharedPreferences.getInstance();
    _text = sp.getString(_key(tag)) ?? '';
    notifyListeners();
  }

  Future<void> speichere(DateTime tag, String wert) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key(tag), wert);
    _text = wert;
    notifyListeners();
  }
}
