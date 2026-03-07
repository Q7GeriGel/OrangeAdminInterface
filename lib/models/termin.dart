import 'package:flutter/material.dart';

class Termin {
  static const String statusOffen = 'Offen';
  static const String statusBestaetigt = 'Bestätigt';
  static const String statusAbgesagt = 'Abgesagt';

  final String id;
  final DateTime start;
  final DateTime end;
  final String kundeName;
  final String mitarbeiterName;

  /// 'Offen' | 'Bestätigt' | 'Abgesagt'
  final String status;

  final String? service;
  final double? price;
  final String? notes;
  final int? mitarbeiterId;
  final Color? color;

  const Termin({
    required this.id,
    required this.start,
    required this.end,
    required this.kundeName,
    required this.mitarbeiterName,
    required this.status,
    this.service,
    this.price,
    this.notes,
    this.mitarbeiterId,
    this.color,
  });

  Termin copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    String? kundeName,
    String? mitarbeiterName,
    String? status,
    String? service,
    double? price,
    String? notes,
    int? mitarbeiterId,
    Color? color,
  }) {
    return Termin(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      kundeName: kundeName ?? this.kundeName,
      mitarbeiterName: mitarbeiterName ?? this.mitarbeiterName,
      status: status ?? this.status,
      service: service ?? this.service,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      mitarbeiterId: mitarbeiterId ?? this.mitarbeiterId,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'kundeName': kundeName,
        'mitarbeiterName': mitarbeiterName,
        'status': status,
        'service': service,
        'price': price,
        'notes': notes,
        'mitarbeiterId': mitarbeiterId,
        'color': color?.value,
      };

  static Termin fromJson(Map<String, dynamic> j) {
    final colorVal = j['color'];
    return Termin(
      id: (j['id'] ?? '').toString(),
      start: DateTime.parse(j['start'] as String),
      end: DateTime.parse(j['end'] as String),
      kundeName: (j['kundeName'] ?? '').toString(),
      mitarbeiterName: (j['mitarbeiterName'] ?? '').toString(),
      status: (j['status'] ?? statusOffen).toString(),
      service: j['service']?.toString(),
      price: (j['price'] is num) ? (j['price'] as num).toDouble() : double.tryParse('${j['price']}'),
      notes: j['notes']?.toString(),
      mitarbeiterId: (j['mitarbeiterId'] is int) ? j['mitarbeiterId'] as int : int.tryParse('${j['mitarbeiterId']}'),
      color: (colorVal is int) ? Color(colorVal) : null,
    );
  }
}