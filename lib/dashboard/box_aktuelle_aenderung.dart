import 'package:flutter/material.dart';
import 'box_shared.dart';

class AktuelleAenderungenBox extends StatelessWidget {
  const AktuelleAenderungenBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardBox(
      icon: Icons.refresh,
      titel: 'Aktuelle Änderungen',
      eintraege: [
        DashboardEntry('Max • verschoben • 12:00'),
        DashboardEntry('Sarah • storniert • 14:00'),
        DashboardEntry('Ali • neu • 15:30'),
      ],
    );
  }
}
