import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/termin.dart';

Future<void> showTerminDetailsDialog({
  required BuildContext context,
  required Termin termin,
  required void Function(TimeOfDay newTime) onMove,
  required void Function(int minutes) onChangeDuration,
  required VoidCallback onToggleStatus,
  required VoidCallback onCancel,
  required VoidCallback onDelete,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final nav = Navigator.of(context);

  int duration = termin.end.difference(termin.start).inMinutes;
  duration = duration <= 0 ? 30 : duration;

  const durationOptions = [30, 45, 60, 90, 120];

  String fmt(DateTime d) => DateFormat('dd.MM.yyyy').format(d);
  String fmtTime(DateTime d) => DateFormat('HH:mm').format(d);

  TimeOfDay toTimeOfDay(DateTime d) => TimeOfDay(hour: d.hour, minute: d.minute);

  int roundMinuteTo30(int m) => (m >= 30) ? 30 : 0;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> pickMoveTime() async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: toTimeOfDay(termin.start),
            );
            if (picked == null) return;

            final fixed = TimeOfDay(hour: picked.hour, minute: roundMinuteTo30(picked.minute));
            onMove(fixed);

            messenger.showSnackBar(
              SnackBar(content: Text('Termin verschoben auf ${fixed.hour.toString().padLeft(2, '0')}:${fixed.minute.toString().padLeft(2, '0')}')),
            );
          }

          Future<void> confirmDelete() async {
            final ok = await showDialog<bool>(
              context: ctx,
              builder: (c2) {
                return AlertDialog(
                  title: const Text('Termin löschen?'),
                  content: Text('Willst du den Termin von "${termin.kundeName}" wirklich löschen?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c2, false), child: const Text('Nein')),
                    FilledButton(
                      onPressed: () => Navigator.pop(c2, true),
                      child: const Text('Löschen'),
                    ),
                  ],
                );
              },
            );

            if (ok == true) {
              onDelete();
              nav.pop(); // close details dialog
            }
          }

          final color = termin.color ?? Theme.of(context).colorScheme.primary;

          return AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 10,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withAlpha(200),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    termin.kundeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoRow(label: 'Datum', value: fmt(termin.start)),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Zeit',
                    value: '${fmtTime(termin.start)} – ${fmtTime(termin.end)}',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Mitarbeiter', value: termin.mitarbeiterName),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Status', value: termin.status),
                  if (termin.service != null && termin.service!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Service', value: termin.service!),
                  ],
                  if (termin.notes != null && termin.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Notiz', value: termin.notes!),
                  ],
                  const SizedBox(height: 14),

                  // Actions row: Move + Duration
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: pickMoveTime,
                          icon: const Icon(Icons.drive_file_move),
                          label: const Text('Verschieben'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: durationOptions.contains(duration) ? duration : 30,
                          items: durationOptions
                              .map((m) => DropdownMenuItem(value: m, child: Text('$m min')))
                              .toList(),
                          onChanged: (v) {
                            final val = v ?? 30;
                            setState(() => duration = val);
                            onChangeDuration(val);
                            messenger.showSnackBar(
                              SnackBar(content: Text('Dauer geändert: ${val}m')),
                            );
                          },
                          decoration: const InputDecoration(
                            labelText: 'Dauer',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Status actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onToggleStatus,
                          icon: const Icon(Icons.sync),
                          label: const Text('Status wechseln'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Absagen'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => nav.pop(),
                child: const Text('Schließen'),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: confirmDelete,
                icon: const Icon(Icons.delete),
                label: const Text('Löschen'),
              ),
            ],
          );
        },
      );
    },
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withAlpha(150),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
