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
}

Future<TerminCreateResult?> showCreateTerminDialog({
  required BuildContext context,
  DateTime? presetStart,
  String? initialMitarbeiter,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  DateTime start = presetStart ?? DateTime.now();
  int duration = 30;

  const mitarbeiterList = KundenVerwaltung.allowedMitarbeiter;
  String mitarbeiter = initialMitarbeiter != null && mitarbeiterList.contains(initialMitarbeiter)
      ? initialMitarbeiter
      : mitarbeiterList.first;

  String status = Termin.statusOffen;

  final kunden = context.read<KundenVerwaltung>();
  final kundenNamen = kunden.kundenNamen;

  final kundeCtrl = TextEditingController();

  final dateFmt = DateFormat('dd.MM.yyyy');
  final timeFmt = DateFormat('HH:mm');

  const durationOptions = <int>[15, 30, 45, 60, 75, 90, 105, 120];
  const statusOptions = <String>[Termin.statusOffen, Termin.statusBestaetigt, Termin.statusAbgesagt];

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
                start = DateTime(picked.year, picked.month, picked.day, start.hour, start.minute);
              });
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: dialogCtx,
                initialTime: TimeOfDay(hour: start.hour, minute: start.minute),
              );
              if (picked == null) return;
              setState(() {
                start = DateTime(start.year, start.month, start.day, picked.hour, picked.minute);
              });
            }

            Future<void> save() async {
              final kundeName = kundeCtrl.text.trim();
              if (kundeName.isEmpty) {
                messenger.showSnackBar(SnackBar(content: Text(t.customerRequired)));
                return;
              }

              final startMinutes = start.hour * 60 + start.minute;
              final endMinutes = startMinutes + duration;
              if (startMinutes < 8 * 60 || endMinutes > 20 * 60) {
                messenger.showSnackBar(SnackBar(content: Text(t.invalidWorkHours)));
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
                  mitarbeiterName: mitarbeiter,
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
                        return kundenNamen.where((n) => n.toLowerCase().contains(q)).take(10);
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: duration,
                      items: durationOptions
                          .map((m) => DropdownMenuItem(value: m, child: Text('${m}${t.minutesShort}')))
                          .toList(),
                      onChanged: (v) => setState(() => duration = v ?? duration),
                      decoration: InputDecoration(
                        labelText: t.duration,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: mitarbeiterList.contains(mitarbeiter) ? mitarbeiter : mitarbeiterList.first,
                      items: mitarbeiterList
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => mitarbeiter = v ?? mitarbeiter),
                      decoration: InputDecoration(
                        labelText: t.employee,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
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

  final res = await showCreateTerminDialog(
    context: context,
    presetStart: presetStart,
    initialMitarbeiter: initialMitarbeiter,
  );
  if (res == null) return;

  await ctrl.createTerminManual(
    start: res.start,
    minutes: res.durationMinutes,
    kundeName: res.kundeName,
    mitarbeiterName: res.mitarbeiterName,
    status: res.status,
  );

  if (!context.mounted) return;

  await context.read<KundenVerwaltung>().erstelleKundeFallsFehlt(
        name: res.kundeName,
        bevorzugterFriseur: res.mitarbeiterName,
        naechsterTermin: res.start,
      );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(t.successAppointmentSaved)),
  );
}