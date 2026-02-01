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
  }) =>
      Termin(
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
