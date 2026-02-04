import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/termin.dart';

Future<void> showTerminDetailsDialog({
  required BuildContext context,
  required Termin termin,
  required ValueChanged<TimeOfDay> onMove,
  required ValueChanged<int> onChangeDuration,
  required VoidCallback onToggleStatus,
  required VoidCallback onCancel,
  required VoidCallback onDelete,
  bool canEdit = true, // ✅ NEU
}) {
  return showDialog(
    context: context,
    builder: (_) => _TerminDetailsDialog(
      termin: termin,
      onMove: onMove,
      onChangeDuration: onChangeDuration,
      onToggleStatus: onToggleStatus,
      onCancel: onCancel,
      onDelete: onDelete,
      canEdit: canEdit,
    ),
  );
}

class _TerminDetailsDialog extends StatelessWidget {
  final Termin termin;
  final ValueChanged<TimeOfDay> onMove;
  final ValueChanged<int> onChangeDuration;
  final VoidCallback onToggleStatus;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final bool canEdit;

  const _TerminDetailsDialog({
    required this.termin,
    required this.onMove,
    required this.onChangeDuration,
    required this.onToggleStatus,
    required this.onCancel,
    required this.onDelete,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final startTxt = DateFormat('dd.MM.yyyy • HH:mm').format(termin.start);
    final endTxt = DateFormat('HH:mm').format(termin.end);
    final minutes = termin.end.difference(termin.start).inMinutes;

    return AlertDialog(
      title: const Text('Termin Details'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row('Kunde', termin.kundeName),
            _row('Mitarbeiter', termin.mitarbeiterName),
            _row('Zeit', '$startTxt – $endTxt ($minutes min)'),
            _row('Status', termin.status),
            if (termin.service != null) _row('Service', termin.service!),
            if (termin.price != null) _row('Preis', '€ ${termin.price!.toStringAsFixed(0)}'),
            if (!canEdit)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Nur Ansicht (keine Bearbeitung)',
                  style: TextStyle(color: Colors.black.withAlpha(140), fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen'),
        ),

        if (canEdit) ...[
          TextButton(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(termin.start),
              );
              if (picked != null) onMove(picked);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Verschieben'),
          ),
          TextButton(
            onPressed: () async {
              final newMin = await _pickDuration(context, minutes);
              if (newMin != null) onChangeDuration(newMin);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Dauer'),
          ),
          TextButton(
            onPressed: () {
              onToggleStatus();
              Navigator.pop(context);
            },
            child: const Text('Status'),
          ),
          TextButton(
            onPressed: () {
              onCancel();
              Navigator.pop(context);
            },
            child: const Text('Stornieren'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Löschen'),
          ),
        ],
      ],
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Future<int?> _pickDuration(BuildContext context, int current) async {
    final options = [30, 45, 60, 90, 120];
    int selected = options.contains(current) ? current : 30;

    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dauer ändern'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<int>(
              value: selected,
              isExpanded: true,
              items: options
                  .map((m) => DropdownMenuItem(value: m, child: Text('$m Minuten')))
                  .toList(),
              onChanged: (v) => setState(() => selected = v ?? selected),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, selected), child: const Text('OK')),
        ],
      ),
    );
  }
}
