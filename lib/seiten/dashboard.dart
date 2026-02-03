import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../controllers/kunden_verwaltung.dart';
import '../models/kunde.dart';

import '../dashboard/box_bevorstehende_kunden.dart';
import '../dashboard/box_aktuelle_aenderung.dart';
import '../dashboard/box_freie_zeitfenster.dart';

import '../widgets/kalender/termin_create_dialog.dart';
import '../widgets/kunde_dialog.dart';

class DashboardPage extends StatelessWidget {
  final String benutzername;

  const DashboardPage({super.key, required this.benutzername});

  static const _bg = Color(0xFFF4F4F4);
  static const _orange = Color(0xFFCC5C4C);
  static const _blue = Color(0xFF335776);
  static const _violet = Color(0xFF6E61A8);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();
    final todayText =
        DateFormat('EEEE, dd.MM.yyyy', 'de_DE').format(DateTime.now());

    final messenger = ScaffoldMessenger.of(context);

    Future<void> openNewKunde() async {
      final verwaltung = context.read<KundenVerwaltung>();

      final res = await showDialog<Kunde>(
        context: context,
        barrierDismissible: false,
        builder: (c) => KundeDialog(
          initial: null,
          friseure: verwaltung.friseure,
        ),
      );

      if (res == null) return;

      verwaltung.hinzufuegen(res);
      messenger.showSnackBar(
        SnackBar(content: Text('Kunde erstellt: ${res.name}')),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------------
                  // Header / Actions
                  // ----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _WelcomeHeader(benutzername: benutzername)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.black.withAlpha(18)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.today, size: 18, color: _orange),
                                const SizedBox(width: 8),
                                Text(
                                  todayText,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => openCreateTerminFlow(
                                  context: context,
                                  ctrl: ctrl,
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Neuer Termin'),
                              ),
                              FilledButton.icon(
                                onPressed: openNewKunde,
                                icon: const Icon(Icons.person_add),
                                label: const Text('Neuer Kunde'),
                              ),
                              IconButton(
                                tooltip: 'Heute aktualisieren',
                                onPressed: () {
                                  ctrl.goToday();
                                  messenger.showSnackBar(
                                    const SnackBar(content: Text('Aktualisiert ✅')),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Hier ist dein Tagesplan:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),

                  const SizedBox(height: 14),

                  // ----------------
                  // KPI GRID (stabil, sauber)
                  // ----------------
                  LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth;
                      const gap = 12.0;

                      int cols;
                      if (w >= 980) {
                        cols = 4;
                      } else if (w >= 560) {
                        cols = 2;
                      } else {
                        cols = 1;
                      }

                      final itemWidth = (w - gap * (cols - 1)) / cols;

                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: _KpiCard(
                              icon: Icons.event_available,
                              label: 'Termine heute',
                              value: ctrl.termineHeuteTotal().toString(),
                              accent: _orange,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _KpiCard(
                              icon: Icons.schedule,
                              label: 'Nächster Termin',
                              value: ctrl.naechsterTerminHeuteLabel(),
                              accent: _blue,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _KpiCard(
                              icon: Icons.timer,
                              label: 'Freie Slots',
                              value: ctrl.freie.length.toString(),
                              accent: _violet,
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _KpiCard(
                              icon: Icons.sync,
                              label: 'Änderungen',
                              value: ctrl.aenderungen.length.toString(),
                              accent: const Color(0xFF2E7DDB),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ----------------
                  // DASHBOARD BOX GRID (3 Panels, exakt gleiche Breiten)
                  // ----------------
                  LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth;
                      const gap = 18.0;

                      int cols;
                      if (w >= 1100) {
                        cols = 3;
                      } else if (w >= 780) {
                        cols = 2;
                      } else {
                        cols = 1;
                      }

                      final itemWidth = (w - gap * (cols - 1)) / cols;

                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          SizedBox(width: itemWidth, child: const BevorstehendeKundenBox()),
                          SizedBox(width: itemWidth, child: const AktuelleAenderungenBox()),
                          SizedBox(width: itemWidth, child: const BoxFreieZeitfenster()),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final String benutzername;
  const _WelcomeHeader({required this.benutzername});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
          color: Colors.black,
        );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Willkommen", style: baseStyle),
            TextSpan(
              text: ", $benutzername!",
              style: baseStyle?.copyWith(color: const Color(0xFFcc5c4c)),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86, // ✅ gleiche Höhe = geordnet
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withAlpha(150),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
