import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../l10n/gen/app_localizations.dart';
import '../widgets/kalender/termin_details_dialog.dart';
import 'box_shared.dart';

class BevorstehendeKundenBox extends StatelessWidget {
  const BevorstehendeKundenBox({super.key});

  String _statusLabel(AppLocalizations t, String status) {
    if (status == Termin.statusBestaetigt) return t.statusConfirmed;
    if (status == Termin.statusAbgesagt) return t.statusCancelled;
    return t.statusOpen;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ctrl = context.watch<TerminplanController>();
    final messenger = ScaffoldMessenger.of(context);
    final list = ctrl.kommendeHeute(limit: 6);

    Future<void> openDetails(Termin x) async {
      await showTerminDetailsDialog(
        context: context,
        termin: x,
        canEdit: true,
        onMove: (newTime) async {
          try {
            final newStart = DateTime(
              x.start.year,
              x.start.month,
              x.start.day,
              newTime.hour,
              newTime.minute,
            );
            await ctrl.moveTermin(x.id, newStart);
          } catch (e) {
            if (!context.mounted) return;
            messenger.showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        onChangeDuration: (minutes) async {
          try {
            await ctrl.updateDuration(x.id, minutes);
          } catch (e) {
            if (!context.mounted) return;
            messenger.showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        onToggleStatus: () => ctrl.toggleStatus(x.id),
        onCancel: () => ctrl.cancelTermin(x.id),
        onDelete: () => ctrl.deleteTermin(x.id),
      );
    }

    final entries = list.map((x) {
      final time = DateFormat('HH:mm').format(x.start);
      final statusColor = _statusColor(x.status);
      final accent = (x.color ?? statusColor).withAlpha(200);

      return DashboardEntry(
        x.kundeName,
        subtitle: '${x.mitarbeiterName} • $time',
        accent: accent,
        trailing: _StatusChip(
          status: _statusLabel(t, x.status),
          color: statusColor,
        ),
        onTap: () => openDetails(x),
      );
    }).toList();

    return DashboardBox(
      icon: Icons.person,
      titel: t.boxUpcomingCustomersTitle,
      eintraege: entries,
      height: 360,
      loading: ctrl.loading,
      emptyText: t.boxUpcomingCustomersEmpty,
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case Termin.statusBestaetigt:
        return const Color(0xFFFFB74D);
      case Termin.statusAbgesagt:
        return const Color(0xFFC62828);
      default:
        return const Color(0xFFF57C00);
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