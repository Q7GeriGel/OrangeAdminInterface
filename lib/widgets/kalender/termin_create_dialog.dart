import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/staff_config.dart';
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
    return DateTime(
      clean.year,
      clean.month,
      clean.day,
      clean.hour,
      clean.minute,
    );
  }

  final addMinutes = 30 - remainder;
  return clean.add(Duration(minutes: addMinutes));
}

DateTime _normalizeInitialStart(DateTime value) {
  final snapped = _snapToHalfHour(value);
  final latest = DateTime(snapped.year, snapped.month, snapped.day, 19, 30);

  if (snapped.isAfter(latest)) {
    return latest;
  }

  return snapped;
}

Future<TimeOfDay?> _pickHalfHourTime({
  required BuildContext context,
  required TimeOfDay initial,
  required AppLocalizations t,
}) async {
  int selectedHour = initial.hour;
  int selectedMinute = initial.minute >= 30 ? 30 : 0;

  return showDialog<TimeOfDay>(
    context: context,
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (dialogCtx, setState) {
          return AlertDialog(
            title: Text(t.startTime),
            content: SizedBox(
              width: 340,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: selectedHour,
                      items: List.generate(
                        24,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(i.toString().padLeft(2, '0')),
                        ),
                      ),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => selectedHour = v);
                      },
                      decoration: InputDecoration(
                        labelText: 'HH',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: selectedMinute,
                      items: const [0, 30]
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.toString().padLeft(2, '0')),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => selectedMinute = v);
                      },
                      decoration: InputDecoration(
                        labelText: 'MM',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text(t.cancel),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    dialogCtx,
                    TimeOfDay(hour: selectedHour, minute: selectedMinute),
                  );
                },
                child: Text(t.ok),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<TerminCreateResult?> showCreateTerminDialog({
  required BuildContext context,
  DateTime? presetStart,
  String? initialMitarbeiter,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  DateTime start = _normalizeInitialStart(presetStart ?? DateTime.now());
  int duration = 30;

  final mitarbeiterList = StaffConfig.allEmployees;
  String mitarbeiter = StaffConfig.normalizeEmployee(initialMitarbeiter ?? '');

  if (!mitarbeiterList.contains(mitarbeiter)) {
    mitarbeiter = mitarbeiterList.first;
  }

  String status = Termin.statusOffen;

  final kunden = context.read<KundenVerwaltung>();
  final kundenNamen = kunden.kundenNamen;

  final kundeCtrl = TextEditingController();

  final dateFmt = DateFormat('dd.MM.yyyy');
  final timeFmt = DateFormat('HH:mm');

  const durationOptions = <int>[15, 30, 45, 60, 75, 90, 105, 120];
  const statusOptions = <String>[
    Termin.statusOffen,
    Termin.statusBestaetigt,
    Termin.statusAbgesagt,
  ];

  String statusLabel(String s) {
    switch (s) {
      case Termin.statusBestaetigt:
        return t.statusConfirmed;
      case Termin.statusAbgesagt:
        return t.statusCancelled;
      default:
        return t.statusOpen;
    }
  }

  bool saving = false;

  try {
    final result = await showDialog<TerminCreateResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: dialogCtx,
                initialDate: start,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked == null) return;

              setState(() {
                start = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  start.hour,
                  start.minute,
                );
              });
            }

            Future<void> pickTime() async {
              final picked = await _pickHalfHourTime(
                context: dialogCtx,
                initial: TimeOfDay(hour: start.hour, minute: start.minute),
                t: t,
              );
              if (picked == null) return;

              setState(() {
                start = DateTime(
                  start.year,
                  start.month,
                  start.day,
                  picked.hour,
                  picked.minute,
                );
              });
            }

            Future<void> save() async {
              final kundeName = kundeCtrl.text.trim();
              if (kundeName.isEmpty) {
                messenger.showSnackBar(
                  SnackBar(content: Text(t.customerRequired)),
                );
                return;
              }

              start = _snapToHalfHour(start);

              final startMinutes = start.hour * 60 + start.minute;
              final endMinutes = startMinutes + duration;
              if (startMinutes < 8 * 60 || endMinutes > 20 * 60) {
                messenger.showSnackBar(
                  SnackBar(content: Text(t.invalidWorkHours)),
                );
                return;
              }

              setState(() => saving = true);
              await Future<void>.delayed(const Duration(milliseconds: 140));
              if (!dialogCtx.mounted) return;
              setState(() => saving = false);

              Navigator.pop(
                dialogCtx,
                TerminCreateResult(
                  start: start,
                  durationMinutes: duration,
                  kundeName: kundeName,
                  mitarbeiterName: StaffConfig.normalizeEmployee(mitarbeiter),
                  status: status,
                ),
              );
            }

            return AlertDialog(
              title: Text(t.newAppointment),
              content: SizedBox(
                width: 560,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickDate,
                            icon: const Icon(Icons.event),
                            label: Text(dateFmt.format(start)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickTime,
                            icon: const Icon(Icons.schedule),
                            label: Text(timeFmt.format(start)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Autocomplete<String>(
                      optionsBuilder: (value) {
                        final q = value.text.trim().toLowerCase();
                        if (q.isEmpty) return const Iterable<String>.empty();
                        return kundenNamen
                            .where((n) => n.toLowerCase().contains(q))
                            .take(10);
                      },
                      onSelected: (s) => kundeCtrl.text = s,
                      fieldViewBuilder: (ctx, textCtrl, focusNode, onSubmit) {
                        textCtrl.text = kundeCtrl.text;
                        textCtrl.addListener(() => kundeCtrl.text = textCtrl.text);
                        return TextField(
                          controller: textCtrl,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: t.customerName,
                            hintText: t.customerHintExample,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: duration,
                      items: durationOptions
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text('$m${t.minutesShort}'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => duration = v ?? duration),
                      decoration: InputDecoration(
                        labelText: t.duration,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: mitarbeiter,
                      items: mitarbeiterList
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(
                        () => mitarbeiter = StaffConfig.normalizeEmployee(
                          v ?? mitarbeiter,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: t.employee,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      items: statusOptions
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(statusLabel(s)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => status = v ?? status),
                      decoration: InputDecoration(
                        labelText: t.status,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.pop(dialogCtx),
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  onPressed: saving ? null : save,
                  child: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(t.save),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  } finally {
    kundeCtrl.dispose();
  }
}

Future<void> openCreateTerminFlow({
  required BuildContext context,
  required TerminplanController ctrl,
  DateTime? presetStart,
  String? initialMitarbeiter,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final kundenVerwaltung = context.read<KundenVerwaltung>();

  final res = await showCreateTerminDialog(
    context: context,
    presetStart: presetStart,
    initialMitarbeiter: initialMitarbeiter,
  );
  if (res == null) return;

  try {
    await ctrl.createTerminManual(
      start: res.start,
      minutes: res.durationMinutes,
      kundeName: res.kundeName,
      mitarbeiterName: StaffConfig.normalizeEmployee(res.mitarbeiterName),
      status: res.status,
    );

    await kundenVerwaltung.erstelleKundeFallsFehlt(
      name: res.kundeName,
      bevorzugterFriseur: StaffConfig.normalizeEmployee(res.mitarbeiterName),
      naechsterTermin: res.start,
    );

    messenger.showSnackBar(
      SnackBar(content: Text(t.successAppointmentSaved)),
    );
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}