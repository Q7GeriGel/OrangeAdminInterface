import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../widgets/kalender/termin_details_dialog.dart';
import 'box_shared.dart';

class BevorstehendeKundenBox extends StatelessWidget {
  const BevorstehendeKundenBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();
    final list = ctrl.kommendeHeute(limit: 6);

    Future<void> openDetails(Termin t) async {
      await showTerminDetailsDialog(
        context: context,
        termin: t,
        onMove: (newTime) {
          final newStart = DateTime(
            t.start.year,
            t.start.month,
            t.start.day,
            newTime.hour,
            newTime.minute,
          );
          ctrl.moveTermin(t.id, newStart);
        },
        onChangeDuration: (minutes) => ctrl.updateDuration(t.id, minutes),
        onToggleStatus: () => ctrl.toggleStatus(t.id),
        onCancel: () => ctrl.cancelTermin(t.id),
        onDelete: () => ctrl.deleteTermin(t.id),
      );
    }

    final entries = list.map((t) {
      final time = DateFormat('HH:mm').format(t.start);
      final statusColor = _statusColor(t.status);
      final accent = (t.color ?? statusColor).withAlpha(200);

      return DashboardEntry(
        t.kundeName,
        subtitle: '${t.mitarbeiterName} • $time',
        accent: accent,
        trailing: _StatusChip(status: t.status, color: statusColor),
        onTap: () => openDetails(t),
      );
    }).toList();

    return DashboardBox(
      icon: Icons.person,
      titel: 'Bevorstehende Kunden',
      eintraege: entries,
      height: 360,
      loading: ctrl.loading,
      emptyText: 'Keine Termine mehr heute',
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case Termin.statusBestaetigt:
        return const Color(0xFF2E7D32);
      case Termin.statusAbgesagt:
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF1565C0);
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
