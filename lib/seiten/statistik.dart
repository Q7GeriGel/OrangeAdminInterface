import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../widgets/app_card.dart';
import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';

enum StatsRange { week, month, year }

class StatistikSeite extends StatefulWidget {
  const StatistikSeite({super.key});

  @override
  State<StatistikSeite> createState() => _StatistikSeiteState();
}

class _StatistikSeiteState extends State<StatistikSeite> {
  StatsRange _range = StatsRange.week;

  // Accent (wie in deinen Screens)
  static const _accent = Color(0xFFC95B4C);

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Statistik',
      actions: [
        SegmentedButton<StatsRange>(
          segments: const [
            ButtonSegment(value: StatsRange.week, label: Text('Woche')),
            ButtonSegment(value: StatsRange.month, label: Text('Monat')),
            ButtonSegment(value: StatsRange.year, label: Text('Jahr')),
          ],
          selected: {_range},
          onSelectionChanged: (s) => setState(() => _range = s.first),
        ),
      ],

      // ✅ WICHTIG: ListView => KEIN Overflow mehr
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 1100;

          final kpi = _mockKpis(_range);
          final revenueByDay = _mockRevenueByDay(_range);
          final totalRevenue = revenueByDay.fold<double>(0, (a, b) => a + b);

          final idle = _mockIdleByDay(_range); // Minuten pro Tag
          final idleTotalMin = idle.fold<int>(0, (a, b) => a + b);

          final left = Column(
            children: [
              // KPI Row (wie dein Original)
              Row(
                children: [
                  Expanded(child: _kpiCard(icon: Icons.event_available, title: 'Termine', value: '${kpi.termine}', sub: 'gebucht')),
                  const SizedBox(width: 16),
                  Expanded(child: _kpiCard(icon: Icons.speed, title: 'Auslastung', value: '${kpi.auslastung}%', sub: 'Durchschnitt', valueColor: Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(child: _kpiCard(icon: Icons.person_off, title: 'No-Shows', value: '${kpi.noShows}', sub: 'nicht erschienen', valueColor: Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _kpiCard(icon: Icons.payments_outlined, title: 'Umsatz', value: _eur(kpi.umsatz), sub: _rangeLabel(_range))),
                ],
              ),

              const SizedBox(height: 18),

              // Umsatz-Verlauf (wie vorher) + "Gesamt" oben rechts (ohne Layout zu zerstören)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Umsatz-Verlauf', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              SizedBox(height: 6),
                              Text('Trend nach Zeitraum', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: _accent.withValues(alpha: 0.35)),
                            color: _accent.withValues(alpha: 0.10),
                          ),
                          child: Text(
                            'Gesamt: ${_eur(totalRevenue)}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // kleiner als vorher + immer safe
                    SizedBox(
                      height: 240,
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 26,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
                                  final i = value.toInt();
                                  if (i < 0 || i > 6) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(days[i], style: const TextStyle(fontWeight: FontWeight.w700)),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(7, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: revenueByDay[i],
                                  width: 26,
                                  borderRadius: BorderRadius.circular(10),
                                  color: _accent.withValues(alpha: 0.85),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Leerlaufanalyse ordentlich (Diplomarbeit-relevant)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Leerlaufanalyse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(
                      'Gesamter Leerlauf im Zeitraum: ${_hm(idleTotalMin)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 160,
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
                                  final i = value.toInt();
                                  if (i < 0 || i > 6) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(days[i], style: const TextStyle(fontWeight: FontWeight.w700)),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(7, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: (idle[i] / 60.0), // Stunden
                                  width: 20,
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey.withValues(alpha: 0.55),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // kurze “Interpretation” fürs Diplomarbeit-Feeling
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: const Text(
                        'Interpretation (Mock): Hoher Leerlauf an bestimmten Tagen/Zeitslots deutet auf Optimierungspotenzial hin '
                        '(z.B. Personalplanung, Termin-Slots bündeln, Aktionen in schwachen Zeiten).',
                        style: TextStyle(fontWeight: FontWeight.w600, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final right = Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Service-Mix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('Anteil nach Leistung', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    _serviceRow('Haarschnitt', 0.42),
                    const SizedBox(height: 12),
                    _serviceRow('Bart', 0.18),
                    const SizedBox(height: 12),
                    _serviceRow('Farbe', 0.22),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mitarbeiter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('Termine · Auslastung · No-Shows (Mock)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    _staffTile('Sinan', '34 Termine · 82%', 'No-Shows: 2'),
                    const SizedBox(height: 12),
                    _staffTile('Alperen', '28 Termine · 76%', 'No-Shows: 1'),
                    const SizedBox(height: 12),
                    _staffTile('Emre', '31 Termine · 79%', 'No-Shows: 2'),
                  ],
                ),
              ),
            ],
          );

          return ListView(
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 18),
                    SizedBox(width: 420, child: right),
                  ],
                )
              else
                Column(
                  children: [
                    left,
                    const SizedBox(height: 18),
                    right,
                  ],
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _kpiCard({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
    Color? valueColor,
  }) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _accent.withValues(alpha: 0.12),
              border: Border.all(color: _accent.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: _accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: valueColor)),
                Text(sub, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceRow(String name, double pct) {
    return Row(
      children: [
        Expanded(
          child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(_accent.withValues(alpha: 0.85)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text('${(pct * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _staffTile(String name, String left, String right) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _accent.withValues(alpha: 0.12),
              border: Border.all(color: _accent.withValues(alpha: 0.25)),
            ),
            child: Icon(Icons.person, color: _accent.withValues(alpha: 0.85)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(left, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(right, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // ---- MOCKS (später ersetzt du das easy mit echten Daten) ----

  _Kpis _mockKpis(StatsRange r) {
    switch (r) {
      case StatsRange.week:
        return const _Kpis(termine: 178, auslastung: 78, noShows: 11, umsatz: 5770);
      case StatsRange.month:
        return const _Kpis(termine: 712, auslastung: 74, noShows: 41, umsatz: 22140);
      case StatsRange.year:
        return const _Kpis(termine: 8420, auslastung: 71, noShows: 390, umsatz: 268400);
    }
  }

  List<double> _mockRevenueByDay(StatsRange r) {
    // sieht so aus wie in deinem Original-Screen
    if (r == StatsRange.week) return [820, 760, 900, 520, 1120, 980, 670];
    if (r == StatsRange.month) return [3100, 2800, 3600, 2400, 4200, 3900, 3140];
    return [12000, 9800, 14500, 11000, 16800, 15200, 12500];
  }

  List<int> _mockIdleByDay(StatsRange r) {
    // Minuten (Leerlauf) – bewusst “realistisch”: Montag/Mittwoch besser, Do/SO mehr Leerlauf
    if (r == StatsRange.week) return [120, 160, 90, 210, 80, 110, 240];
    if (r == StatsRange.month) return [520, 640, 430, 780, 410, 560, 900];
    return [6200, 7100, 5400, 8200, 5100, 6900, 9400];
  }

  String _rangeLabel(StatsRange r) {
    switch (r) {
      case StatsRange.week:
        return 'letzte 7 Tage';
      case StatsRange.month:
        return 'letzte 30 Tage';
      case StatsRange.year:
        return 'dieses Jahr';
    }
  }

  String _eur(num n) {
    final s = n.toStringAsFixed(0);
    final withDots = s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '$withDots €';
  }

  String _hm(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }
}

class _Kpis {
  final int termine;
  final int auslastung;
  final int noShows;
  final int umsatz;

  const _Kpis({
    required this.termine,
    required this.auslastung,
    required this.noShows,
    required this.umsatz,
  });
}
