import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import 'box_shared.dart';

class AktuelleAenderungenBox extends StatelessWidget {
  const AktuelleAenderungenBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();

    final entries = ctrl.aenderungen.isEmpty
        ? const [DashboardEntry('Noch keine Änderungen')]
        : ctrl.aenderungen.take(8).map((s) {
            // optional: kleine Farb-Logik (wenn du willst)
            Color? accent;
            final lower = s.toLowerCase();
            if (lower.contains('storniert') || lower.contains('cancel')) {
              accent = Colors.redAccent;
            } else if (lower.contains('verschoben') || lower.contains('move')) {
              accent = Colors.orangeAccent;
            } else if (lower.contains('neu') || lower.contains('new')) {
              accent = Colors.green;
            }

            return DashboardEntry(s, accent: accent);
          }).toList();

    return DashboardBox(
      icon: Icons.refresh,
      titel: 'Aktuelle Änderungen',
      eintraege: entries,
      maxHeight: 220,
    );
  }
}
