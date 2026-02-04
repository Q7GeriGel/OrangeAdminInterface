import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import 'box_shared.dart';

class BoxFreieZeitfenster extends StatefulWidget {
  const BoxFreieZeitfenster({super.key});

  @override
  State<BoxFreieZeitfenster> createState() => _BoxFreieZeitfensterState();
}

class _BoxFreieZeitfensterState extends State<BoxFreieZeitfenster> {
  @override
  void initState() {
    super.initState();
    final terminplan = context.read<TerminplanController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      terminplan.aktualisiere(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TerminplanController>();

    // ✅ statt DashboardUi.panelBlue -> Theme Secondary (bei dir blau)
    final accentBlue = Theme.of(context).colorScheme.secondary;

    final entries = p.freie.map((f) {
      return DashboardEntry(
        f.beschriftung,
        accent: accentBlue,
        trailing: const DashboardPill(text: 'frei'),
      );
    }).toList();

    return DashboardBox(
      icon: Icons.timer,
      titel: 'Freie Zeitfenster heute',
      eintraege: entries,
      height: 360,
      loading: p.lade, // lass ich wie bei dir (Controller-Property)
      emptyText: 'Heute keine freien Slots',
    );
  }
}
