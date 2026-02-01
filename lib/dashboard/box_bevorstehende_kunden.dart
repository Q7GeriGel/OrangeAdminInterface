import 'package:flutter/material.dart';
import 'box_shared.dart';

class BevorstehendeKundenBox extends StatelessWidget {
  const BevorstehendeKundenBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardBox(
      icon: Icons.person,
      titel: 'Bevorstehende Kunden',
      eintraege: [
        DashboardEntry('Kunde A • 10:00'),
        DashboardEntry('Kunde B • 11:30'),
        DashboardEntry('Kunde C • 13:00'),
        DashboardEntry('Kunde D • 15:00'),
      ],
    );
  }
}
