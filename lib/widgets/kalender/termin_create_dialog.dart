import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/termin.dart';
import '../../controllers/terminplan_controller.dart';
import '../../controllers/kunden_verwaltung.dart';
import '../../l10n/gen/app_localizations.dart';

class TerminCreateResult {
  final DateTime start;
  final int durationMinutes;
  final String kundeName;
  final String mitarbeiterName;
  final String status;

  const TerminCreateResult({
    required this.start,
    required this.durationMinutes,
    required this.kundeName,
    required this.mitarbeiterName,
    required this.status,
  });

  DateTime get end => start.add(Duration(minutes: durationMinutes));
}

/// Öffnet den Dialog und gibt nur das Result zurück (UI-only).
Future<TerminCreateResult?> showCreateTerminDialog({
  required BuildContext context,
  DateTime? initialStart,
  String initialMitarbeiter = 'Serkan',
  String initialStatus = Termin.statusOffen,
}) async {
  final t = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final locale = Localizations.localeOf(context);

  // ✅ Kunden-Liste aus Provider (für Autocomplete)
  final kundenNames = context
      .read<KundenVerwaltung>()
      .kunden
      .map((k) => k.name.trim())
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  DateTime roundToNext30(DateTime d) {
    final base = DateTime(d.year, d.month, d.day, d.hour, d.minute);
    final m = base.minute;
    final add = (m == 0 || m == 30) ? 0 : (m < 30 ? (30 - m) : (60 - m));
    final r = base.add(Duration(minutes: add));
    return DateTime(r.year, r.month, r.day, r.hour, r.minute >= 30 ? 30 : 0);
  }

  DateTime start = initialStart ?? roundToNext30(now);
  int duration = 30;

  // ✅ Nur diese 3 Mitarbeiter
  const mitarbeiterList = ['Serkan', 'Samet', 'Sedat'];

  String normalizeMitarbeiter(String input) {
    final low = input.trim().toLowerCase();
    for (final m in mitarbeiterList) {
      if (m.toLowerCase() == low) return m;
    }
    return mitarbeiterList.first; // fallback Serkan
  }

  String mitarbeiter = normalizeMitarbeiter(initialMitarbeiter);
  String status = initialStatus;

  const durationOptions = [30, 45, 60, 90, 120];
  const statusOptions = [
    Termin.statusOffen,
    Termin.statusBestaetigt,
    Termin.statusAbgesagt,
  ];

  String statusLabel(String s) {
    if (s == Termin.statusBestaetigt) return t.statusConfirmed;
    if (s == Termin.statusAbgesagt) return t.statusCancelled;
    return t.statusOpen;
  }

  bool isSunday(DateTime d) => d.weekday == DateTime.sunday;

  bool withinHours(DateTime s) {
    final h = s.hour;
    final m = s.minute;
    final afterOpen = (h > 8) || (h == 8 && m >= 0);
    final beforeClose = (h < 20) || (h == 20 && m == 0);
    return afterOpen && beforeClose;
  }

  bool endBefore20(DateTime s, int minutes) {
    final end = s.add(Duration(minutes: minutes));
    final limit = DateTime(s.year, s.month, s.day, 20, 0);
    return !end.isAfter(limit);
  }

  TextEditingController? kundeCtrlRef;

  return showDialog<TerminCreateResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: start,
              firstDate: DateTime(now.year - 1),
              lastDate: DateTime(now.year + 2),
              locale: locale,
            );
            if (picked == null) return;
            setState(() {
              start = DateTime(picked.year, picked.month, picked.day, start.hour, start.minute);
            });
          }

          Future<void> pickTime() async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: TimeOfDay(hour: start.hour, minute: start.minute),
            );
            if (picked == null) return;

            // Guard: nur 0/30
            final m = picked.minute >= 30 ? 30 : 0;

            setState(() {
              start = DateTime(start.year, start.month, start.day, picked.hour, m);
            });
          }

          final dateText = DateFormat('dd.MM.yyyy').format(start);
          final timeText = DateFormat('HH:mm').format(start);

          return AlertDialog(
            title: Text(t.createAppointmentTitle),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Kunde auswählen (Autocomplete)
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue value) {
                      final q = value.text.trim().toLowerCase();
                      if (q.isEmpty) return const Iterable<String>.empty();
                      return kundenNames.where((n) => n.toLowerCase().contains(q));
                    },
                    onSelected: (sel) {
                      if (kundeCtrlRef != null) kundeCtrlRef!.text = sel;
                    },
                    fieldViewBuilder: (context, textCtrl, focusNode, onFieldSubmitted) {
                      kundeCtrlRef = textCtrl;
                      return TextField(
                        controller: textCtrl,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: t.customerName,
                          hintText: t.customerHintExample,
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: mitarbeiter,
                          items: mitarbeiterList
                              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                              .toList(),
                          onChanged: (v) => setState(() => mitarbeiter = v ?? mitarbeiter),
                          decoration: InputDecoration(
                            labelText: t.employee,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: duration,
                          items: durationOptions
                              .map((d) => DropdownMenuItem(value: d, child: Text('$d ${t.minutesShort}')))
                              .toList(),
                          onChanged: (v) => setState(() => duration = v ?? duration),
                          decoration: InputDecoration(
                            labelText: t.durationMinutes,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: pickDate,
                          icon: const Icon(Icons.date_range),
                          label: Text(dateText),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: pickTime,
                          icon: const Icon(Icons.access_time),
                          label: Text(timeText),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: status,
                    items: statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(statusLabel(s))))
                        .toList(),
                    onChanged: (v) => setState(() => status = v ?? status),
                    decoration: InputDecoration(
                      labelText: t.status,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.cancel),
              ),
              FilledButton.icon(
                onPressed: () {
                  final name = (kundeCtrlRef?.text ?? '').trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(t.customerRequired)));
                    return;
                  }

                  final fixedMinute = start.minute >= 30 ? 30 : 0;
                  final fixedStart = DateTime(start.year, start.month, start.day, start.hour, fixedMinute);

                  if (isSunday(fixedStart)) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(t.invalidDay)));
                    return;
                  }
                  if (!withinHours(fixedStart)) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(t.invalidWorkHours)));
                    return;
                  }
                  if (!endBefore20(fixedStart, duration)) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(t.invalidTimeRange)));
                    return;
                  }

                  Navigator.pop(
                    ctx,
                    TerminCreateResult(
                      start: fixedStart,
                      durationMinutes: duration,
                      kundeName: name,
                      mitarbeiterName: mitarbeiter,
                      status: status,
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: Text(t.save),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Ultra-clean Flow: öffnet Dialog + speichert direkt im Controller.
Future<void> openCreateTerminFlow({
  required BuildContext context,
  required TerminplanController ctrl,
  DateTime? presetStart,
  String initialMitarbeiter = 'Serkan',
  String initialStatus = Termin.statusOffen,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  Color colorForMitarbeiter(String name) {
    switch (name.trim().toLowerCase()) {
      case 'serkan':
        return const Color(0xFFC95B4C);
      case 'samet':
        return const Color(0xFF3A6EA5);
      case 'sedat':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFFC95B4C);
    }
  }

  final res = await showCreateTerminDialog(
    context: context,
    initialStart: presetStart,
    initialMitarbeiter: initialMitarbeiter,
    initialStatus: initialStatus,
  );

  if (res == null) return;

  await ctrl.createTerminManual(
    start: res.start,
    minutes: res.durationMinutes,
    kundeName: res.kundeName,
    mitarbeiterName: res.mitarbeiterName,
    status: res.status,
    serviceName: null,
    notes: null,
    color: colorForMitarbeiter(res.mitarbeiterName),
  );

  messenger.showSnackBar(SnackBar(content: Text(t.successAppointmentSaved)));
}