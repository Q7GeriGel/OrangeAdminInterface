import 'package:flutter/material.dart';
import '../../models/termin.dart';

Future<void> showTerminDetailsDialog({
  required BuildContext context,
  required Termin termin,
  required void Function(TimeOfDay newTime) onMove,
  required void Function(int minutes) onChangeDuration, // NEU
  required VoidCallback onToggleStatus,
  required VoidCallback onCancel,
  required VoidCallback onDelete, // NEU
}) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      final durationMin = termin.end.difference(termin.start).inMinutes;

      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.event, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(termin.kundeName)),
            Chip(label: Text(termin.status)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zeit: ${TimeOfDay.fromDateTime(termin.start).format(ctx)} – '
              '${TimeOfDay.fromDateTime(termin.end).format(ctx)}',
            ),
            Text('Dauer: $durationMin Minuten'),
            Text('Mitarbeiter/in: ${termin.mitarbeiterName}'),
            if (termin.service != null) Text('Leistung: ${termin.service}'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          // Linke Seite: Löschen
          TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Löschen'),
          ),

          // Rechte Seite: Aktionen
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dauer 30/60
              OutlinedButton(
                onPressed: () => onChangeDuration(30),
                child: const Text('30 Min'),
              ),
              const SizedBox(width: 6),
              OutlinedButton(
                onPressed: () => onChangeDuration(60),
                child: const Text('60 Min'),
              ),
              const SizedBox(width: 8),

              // Verschieben
              OutlinedButton(
                onPressed: () async {
                  final pick = await showTimePicker(
                    context: ctx,
                    initialTime: TimeOfDay.fromDateTime(termin.start),
                  );
                  if (pick != null) onMove(pick);
                },
                child: const Text('Verschieben'),
              ),
              const SizedBox(width: 8),

              // Status
              FilledButton(
                onPressed: onToggleStatus,
                child: const Text('Status wechseln'),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: onCancel,
                child: const Text('Abbrechen'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
