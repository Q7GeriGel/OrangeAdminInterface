import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/kunde.dart';

class KundenApi {
  final http.Client _client;
  KundenApi({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri([String path = '']) => Uri.parse('${AppConfig.apiBaseUrl}/api/kunden$path');

  Future<List<Kunde>> alle() async {
    final res = await _client.get(_uri(), headers: {'Accept': 'application/json'}).timeout(
      const Duration(seconds: 10),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API kunden alle failed (${res.statusCode}): ${res.body}');
    }

    final data = jsonDecode(res.body);
    if (data is! List) return [];
    return data.map((e) => Kunde.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<Kunde> create(Kunde k) async {
    final res = await _client
        .post(
          _uri(),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(k.toJson()..remove('id')),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API kunden create failed (${res.statusCode}): ${res.body}');
    }

    final data = jsonDecode(res.body);
    return Kunde.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<Kunde> update(Kunde k) async {
    final id = k.id;
    final res = await _client
        .put(
          _uri('/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(k.toJson()),
        )
        .timeout(const Duration(seconds: 12));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API kunden update failed (${res.statusCode}): ${res.body}');
    }

    final data = jsonDecode(res.body);
    return Kunde.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<void> delete(String id) async {
    final res = await _client.delete(_uri('/$id')).timeout(const Duration(seconds: 12));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API kunden delete failed (${res.statusCode}): ${res.body}');
    }
  }
}