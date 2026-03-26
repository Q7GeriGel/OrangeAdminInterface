import 'package:flutter/material.dart';

import '../config/staff_config.dart';
import '../models/termin.dart';
import '../repositories/terminquelle.dart';

class TerminplanService {
  final Terminquelle quelle;

  TerminplanService({required this.quelle});

  Future<List<Termin>> ladeWoche(DateTime monday) => quelle.ladeWoche(monday);

  Future<void> speichereWoche(DateTime monday, List<Termin> termine) =>
      quelle.speichereWoche(monday, termine);

  DateTime mondayOf(DateTime d) {
    final dd = DateTime(d.year, d.month, d.day);
    final diff = dd.weekday - DateTime.monday;
    return dd.subtract(Duration(days: diff));
  }

  DateTime _snapToHalfHour(DateTime value) {
    final clean = DateTime(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
    );
    final remainder = clean.minute % 30;

    if (remainder == 0) {
      return clean;
    }

    return clean.add(Duration(minutes: 30 - remainder));
  }

  bool _overlaps(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }

  bool _hasConflict({
    required List<Termin> termine,
    required DateTime start,
    required DateTime end,
    required String mitarbeiterName,
    String? ignoreId,
  }) {
    final normalizedMitarbeiter = StaffConfig.normalizeEmployee(mitarbeiterName);

    return termine.any((t) {
      if (ignoreId != null && t.id == ignoreId) return false;
      if (t.status == Termin.statusAbgesagt) return false;

      final terminMitarbeiter = StaffConfig.normalizeEmployee(t.mitarbeiterName);
      if (terminMitarbeiter != normalizedMitarbeiter) return false;

      return _overlaps(start, end, t.start, t.end);
    });
  }

  void _throwIfConflict({
    required List<Termin> termine,
    required DateTime start,
    required DateTime end,
    required String mitarbeiterName,
    String? ignoreId,
  }) {
    if (_hasConflict(
      termine: termine,
      start: start,
      end: end,
      mitarbeiterName: mitarbeiterName,
      ignoreId: ignoreId,
    )) {
      throw 'Dieser Slot ist bereits belegt.';
    }
  }

  Future<Termin> createTerminAt(
    DateTime slotStart, {
    int minutes = 30,
    String kundeName = 'Neuer Kunde',
    String mitarbeiterName = 'Serkan',
    String status = Termin.statusOffen,
    String? service,
    double? price,
    String? notes,
    Color? color,
  }) async {
    final normalizedStart = _snapToHalfHour(slotStart);
    final monday = mondayOf(normalizedStart);
    final list = await ladeWoche(monday);

    final normalizedMitarbeiter = StaffConfig.normalizeEmployee(mitarbeiterName);
    final newEnd = normalizedStart.add(Duration(minutes: minutes));

    _throwIfConflict(
      termine: list,
      start: normalizedStart,
      end: newEnd,
      mitarbeiterName: normalizedMitarbeiter,
    );

    final id = 'new_${DateTime.now().millisecondsSinceEpoch}';
    final t = Termin(
      id: id,
      start: normalizedStart,
      end: newEnd,
      kundeName: kundeName,
      mitarbeiterName: normalizedMitarbeiter,
      status: status,
      service: service,
      price: price,
      notes: notes,
      color: color ?? StaffConfig.colorOf(normalizedMitarbeiter),
    );

    list.add(t);
    list.sort((a, b) => a.start.compareTo(b.start));

    await speichereWoche(monday, list);
    return t;
  }

  Future<void> deleteTermin(String id, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    list.removeWhere((t) => t.id == id);
    await speichereWoche(monday, list);
  }

  Future<void> moveTermin(String id, DateTime newStart, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final old = list[idx];
    final dur = old.end.difference(old.start);
    final normalizedMitarbeiter = StaffConfig.normalizeEmployee(old.mitarbeiterName);
    final newEnd = newStart.add(dur);

    _throwIfConflict(
      termine: list,
      start: newStart,
      end: newEnd,
      mitarbeiterName: normalizedMitarbeiter,
      ignoreId: id,
    );

    list[idx] = old.copyWith(
      start: newStart,
      end: newEnd,
      mitarbeiterName: normalizedMitarbeiter,
      color: old.color ?? StaffConfig.colorOf(normalizedMitarbeiter),
    );

    list.sort((a, b) => a.start.compareTo(b.start));
    await speichereWoche(monday, list);
  }

  Future<void> updateDuration(String id, int minutes, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final old = list[idx];
    final normalizedMitarbeiter = StaffConfig.normalizeEmployee(old.mitarbeiterName);
    final newEnd = old.start.add(Duration(minutes: minutes));

    _throwIfConflict(
      termine: list,
      start: old.start,
      end: newEnd,
      mitarbeiterName: normalizedMitarbeiter,
      ignoreId: id,
    );

    list[idx] = old.copyWith(
      end: newEnd,
      mitarbeiterName: normalizedMitarbeiter,
      color: old.color ?? StaffConfig.colorOf(normalizedMitarbeiter),
    );

    list.sort((a, b) => a.start.compareTo(b.start));
    await speichereWoche(monday, list);
  }

  Future<void> updateStatus(String id, String status, DateTime anyDate) async {
    final monday = mondayOf(anyDate);
    final list = await ladeWoche(monday);
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final old = list[idx];
    list[idx] = old.copyWith(status: status);

    list.sort((a, b) => a.start.compareTo(b.start));
    await speichereWoche(monday, list);
  }

  Future<void> cancelTermin(String id, DateTime anyDate) async {
    await updateStatus(id, Termin.statusAbgesagt, anyDate);
  }
}