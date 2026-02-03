import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import 'box_shared.dart';

class AktuelleAenderungenBox extends StatelessWidget {
  const AktuelleAenderungenBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();

    final entries = ctrl.aenderungen.take(8).map((s) {
      Color? accent;
      final lower = s.toLowerCase();

      if (lower.contains('storniert') || lower.contains('abgesagt') || lower.contains('cancel')) {
        accent = Colors.redAccent;
      } else if (lower.contains('verschoben') || lower.contains('move')) {
        accent = Colors.orangeAccent;
      } else if (lower.contains('neu') || lower.contains('new')) {
        accent = const Color(0xFF2E7D32);
      } else if (lower.contains('gelöscht') || lower.contains('deleted') || lower.contains('remove')) {
        accent = const Color(0xFFB71C1C);
      }

      return DashboardEntry(s, accent: accent);
    }).toList();

    return DashboardBox(
      icon: Icons.refresh,
      titel: 'Aktuelle Änderungen',
      eintraege: entries,
      height: 360,
      emptyText: 'Noch keine Änderungen',
    );
  }
}
