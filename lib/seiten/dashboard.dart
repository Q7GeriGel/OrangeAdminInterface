import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../dashboard/box_bevorstehende_kunden.dart';
import '../dashboard/box_aktuelle_aenderung.dart';
import '../dashboard/box_freie_zeitfenster.dart';

class DashboardPage extends StatelessWidget {
  final String benutzername;

  const DashboardPage({super.key, required this.benutzername});

  static const _bg = Color(0xFFF4F4F4);
  static const _orange = Color(0xFFCC5C4C);

  @override
  Widget build(BuildContext context) {
    // live count (weil Provider sowieso vorhanden ist – BoxFreieZeitfenster nutzt ihn auch)
    final freieCount = context.select<TerminplanController, int>((c) => c.freie.length);
    final todayText = DateFormat('EEEE, dd.MM.yyyy', 'de_DE').format(DateTime.now());

    void toast(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
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
                  // --- TOP HEADER (macht direkt “App-Feeling”) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _WelcomeHeader(benutzername: benutzername)),
                      const SizedBox(width: 12),
                      // Rechts: Datum + Quick Actions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                                onPressed: () => toast('Quick Action kommt gleich 😄'),
                                icon: const Icon(Icons.add),
                                label: const Text('Neuer Termin'),
                              ),
                              FilledButton.icon(
                                onPressed: () => toast('Quick Action kommt gleich 😄'),
                                icon: const Icon(Icons.person_add),
                                label: const Text('Neuer Kunde'),
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

                  // --- MINI STATS (macht’s lebendig, ohne DB) ---
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _MiniStat(
                        icon: Icons.timer,
                        label: 'Freie Slots',
                        value: freieCount.toString(),
                        accent: _orange,
                      ),
                      _MiniStat(
                        icon: Icons.sync,
                        label: 'Status',
                        value: 'bereit',
                        accent: const Color(0xFF335776),
                      ),
                      _MiniStat(
                        icon: Icons.wb_sunny,
                        label: 'Heute',
                        value: DateFormat('dd.MM').format(DateTime.now()),
                        accent: const Color(0xFF6E61A8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // --- 2 BOXEN OBEN (responsive) ---
                  LayoutBuilder(
                    builder: (context, c) {
                      final isNarrow = c.maxWidth < 900;

                      if (isNarrow) {
                        return Column(
                          children: const [
                            BevorstehendeKundenBox(),
                            SizedBox(height: 18),
                            AktuelleAenderungenBox(),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(child: BevorstehendeKundenBox()),
                          SizedBox(width: 22),
                          Expanded(child: AktuelleAenderungenBox()),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 26),

                  // --- Freie Zeitfenster ---
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: const BoxFreieZeitfenster(),
                    ),
                  ),
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
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
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.black.withAlpha(160))),
                const SizedBox(height: 2),
                Text(
                  value,
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
