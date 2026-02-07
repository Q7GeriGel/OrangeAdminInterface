import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/termin.dart';
import '../../controllers/terminplan_controller.dart';
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
  String initialMitarbeiter = 'Aylin',
  String initialStatus = Termin.statusOffen,
}) async {
  final t = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final locale = Localizations.localeOf(context);

  DateTime roundToNext30(DateTime d) {
    final base = DateTime(d.year, d.month, d.day, d.hour, d.minute);
    final m = base.minute;
    final add = (m == 0 || m == 30) ? 0 : (m < 30 ? (30 - m) : (60 - m));
    final r = base.add(Duration(minutes: add));
    return DateTime(r.year, r.month, r.day, r.hour, r.minute >= 30 ? 30 : 0);
  }

  DateTime start = initialStart ?? roundToNext30(now);
  int duration = 30;

  final kundenCtrl = TextEditingController(text: '');
  String mitarbeiter = initialMitarbeiter;
  String status = initialStatus;

  const mitarbeiterList = ['Aylin', 'Kaan', 'Selin', 'Mert'];
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
                  TextField(
                    controller: kundenCtrl,
                    decoration: InputDecoration(
                      labelText: t.customerName,
                      hintText: t.customerHintExample,
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
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
                  final name = kundenCtrl.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(t.customerRequired)));
                    return;
                  }

                  // Guard: nur 0/30
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
  String initialMitarbeiter = 'Aylin',
  String initialStatus = Termin.statusOffen,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  Color colorForMitarbeiter(String name) {
    switch (name) {
      case 'Aylin':
        return const Color(0xFF2E7DDB);
      case 'Kaan':
        return const Color(0xFFFF9800);
      case 'Selin':
        return const Color(0xFF00A7A7);
      default:
        return const Color(0xFF7E57C2);
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
