import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/termin.dart';
import '../../l10n/gen/app_localizations.dart';

Future<void> showTerminDetailsDialog({
  required BuildContext context,
  required Termin termin,
  required ValueChanged<TimeOfDay> onMove,
  required ValueChanged<int> onChangeDuration,
  required VoidCallback onToggleStatus,
  required VoidCallback onCancel,
  required VoidCallback onDelete,
  bool canEdit = true,
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

  String _statusLabel(AppLocalizations t, String status) {
    if (status == Termin.statusBestaetigt) return t.statusConfirmed;
    if (status == Termin.statusAbgesagt) return t.statusCancelled;
    return t.statusOpen;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final startTxt = DateFormat('dd.MM.yyyy • HH:mm').format(termin.start);
    final endTxt = DateFormat('HH:mm').format(termin.end);
    final minutes = termin.end.difference(termin.start).inMinutes;

    return AlertDialog(
      title: Text(t.appointmentDetailsTitle),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row(t.customerName, termin.kundeName),
            _row(t.employee, termin.mitarbeiterName),
            _row(t.startTime, '$startTxt – $endTxt ($minutes ${t.minutesShort})'),
            _row(t.status, _statusLabel(t, termin.status)),
            if (termin.service != null) _row('Service', termin.service!), // optional, wenn du willst -> später l10n key
            if (termin.price != null) _row('Preis', '€ ${termin.price!.toStringAsFixed(0)}'), // optional
            if (!canEdit)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  t.viewOnlyNoEdit,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(160), fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.close),
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
            child: Text(t.moveTime),
          ),
          TextButton(
            onPressed: () async {
              final newMin = await _pickDuration(context, t, minutes);
              if (newMin != null) onChangeDuration(newMin);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(t.changeDuration),
          ),
          TextButton(
            onPressed: () {
              onToggleStatus();
              Navigator.pop(context);
            },
            child: Text(t.toggleStatus),
          ),
          TextButton(
            onPressed: () {
              onCancel();
              Navigator.pop(context);
            },
            child: Text(t.cancelAppointment),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Text(t.delete),
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
            width: 130,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Future<int?> _pickDuration(BuildContext context, AppLocalizations t, int current) async {
    final options = [30, 45, 60, 90, 120];
    int selected = options.contains(current) ? current : 30;

    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.durationChangeTitle),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<int>(
              value: selected,
              isExpanded: true,
              items: options
                  .map((m) => DropdownMenuItem(value: m, child: Text('$m ${t.minutesShort}')))
                  .toList(),
              onChanged: (v) => setState(() => selected = v ?? selected),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, selected), child: Text(t.ok)),
        ],
      ),
    );
  }
}
