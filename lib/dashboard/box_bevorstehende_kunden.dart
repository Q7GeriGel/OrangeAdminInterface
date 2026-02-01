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
    final List<Termin> list = ctrl.kommendeHeute(limit: 6);

    final entries = list.isEmpty
        ? const [DashboardEntry('Keine Termine mehr heute')]
        : list.map((t) {
            final time = DateFormat('HH:mm').format(t.start);

            return DashboardEntry(
              '${t.kundeName} • $time',
              accent: t.color,
              onTap: () async {
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
              },
            );
          }).toList();

    return DashboardBox(
      icon: Icons.person,
      titel: 'Bevorstehende Kunden',
      eintraege: entries,
      maxHeight: 220,
    );
  }
}
