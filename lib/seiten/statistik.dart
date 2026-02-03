import 'package:flutter/material.dart';
import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';

class StatistikSeite extends StatefulWidget {
  const StatistikSeite({super.key});

  @override
  State<StatistikSeite> createState() => _StatistikSeiteState();
}

enum Zeitraum { woche, monat, jahr }

class _StatistikSeiteState extends State<StatistikSeite> {
  Zeitraum _zeitraum = Zeitraum.woche;

  // Mock-Daten (später Provider/DB)
  // Umsatz je Tag (7 Tage)
  final List<double> _umsatzWoche = const [820, 760, 910, 540, 1120, 980, 640];

  // Monatswerte (12 Balken)
  final List<double> _umsatzMonat = const [7200, 6800, 7900, 6100, 8800, 9400, 8700, 7600, 9900, 10200, 9200, 8400];

  // Jahreswerte (5 Jahre Trend)
  final List<double> _umsatzJahr = const [85000, 92000, 98000, 105000, 112000];

  // Service-Mix
  final Map<String, double> _services = const {
    "Haarschnitt": 0.42,
    "Bart": 0.18,
    "Farbe": 0.22,
    "Styling": 0.10,
    "Sonstiges": 0.08,
  };

  // Mitarbeiter KPI
  final List<_MitarbeiterStat> _team = const [
    _MitarbeiterStat("Sinan", 34, 0.82, 2),
    _MitarbeiterStat("Alperen", 29, 0.76, 1),
    _MitarbeiterStat("Emre", 25, 0.71, 3),
    _MitarbeiterStat("Muhammed", 21, 0.64, 2),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final panelBg = isDark ? const Color(0xFF151A21) : Colors.white;
    final panelBorder = isDark ? Colors.white10 : Colors.black12;
    final textMain = isDark ? Colors.white : Colors.black;
    final textSub = isDark ? Colors.white70 : Colors.black54;

    return AppPage(
      title: "Statistik",
      actions: [
        _ZeitraumSwitch(
          value: _zeitraum,
          onChanged: (z) => setState(() => _zeitraum = z),
        ),
      ],
      child: Column(
        children: [
          // KPIs
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 1050;
              final cols = wide ? 4 : 2;

              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppGaps.s18,
                mainAxisSpacing: AppGaps.s18,
                childAspectRatio: wide ? 2.6 : 2.4,
                children: [
                  _KpiCard(
                    bg: panelBg,
                    border: panelBorder,
                    title: "Termine",
                    value: _zeitraum == Zeitraum.woche ? "178" : _zeitraum == Zeitraum.monat ? "734" : "8.940",
                    subtitle: "gebucht",
                    icon: Icons.event_available_outlined,
                    valueColor: AppColors.orange,
                    textMain: textMain,
                    textSub: textSub,
                  ),
                  _KpiCard(
                    bg: panelBg,
                    border: panelBorder,
                    title: "Auslastung",
                    value: _zeitraum == Zeitraum.woche ? "78%" : _zeitraum == Zeitraum.monat ? "74%" : "71%",
                    subtitle: "Durchschnitt",
                    icon: Icons.speed_outlined,
                    valueColor: const Color(0xFF22C55E),
                    textMain: textMain,
                    textSub: textSub,
                  ),
                  _KpiCard(
                    bg: panelBg,
                    border: panelBorder,
                    title: "No-Shows",
                    value: _zeitraum == Zeitraum.woche ? "11" : _zeitraum == Zeitraum.monat ? "39" : "410",
                    subtitle: "nicht erschienen",
                    icon: Icons.person_off_outlined,
                    valueColor: const Color(0xFFF97316),
                    textMain: textMain,
                    textSub: textSub,
                  ),
                  _KpiCard(
                    bg: panelBg,
                    border: panelBorder,
                    title: "Umsatz",
                    value: _formatEuro(_aktuellerUmsatz()),
                    subtitle: _zeitraum == Zeitraum.woche ? "letzte 7 Tage" : _zeitraum == Zeitraum.monat ? "12 Monate" : "5 Jahre",
                    icon: Icons.payments_outlined,
                    valueColor: const Color(0xFF60A5FA),
                    textMain: textMain,
                    textSub: textSub,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppGaps.s18),

          // Charts + Service Mix
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Umsatz-Verlauf
                Expanded(
                  flex: 2,
                  child: _Panel(
                    bg: panelBg,
                    border: panelBorder,
                    title: "Umsatz-Verlauf",
                    subtitle: "Trend nach Zeitraum",
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _BarChart(
                        values: _chartValues(),
                        labelCount: _labelCount(),
                        barColor: AppColors.orange,
                        textColor: textSub,
                        axisColor: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppGaps.s18),

                // Service Mix + Team
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: _Panel(
                          bg: panelBg,
                          border: panelBorder,
                          title: "Service-Mix",
                          subtitle: "Anteil nach Leistung",
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _services.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final key = _services.keys.elementAt(i);
                              final v = _services.values.elementAt(i);
                              return _ServiceRow(
                                label: key,
                                value: v,
                                textMain: textMain,
                                textSub: textSub,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppGaps.s18),
                      Expanded(
                        child: _Panel(
                          bg: panelBg,
                          border: panelBorder,
                          title: "Mitarbeiter",
                          subtitle: "Termine • Auslastung • No-Shows",
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _team.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final m = _team[i];
                              return _TeamTile(
                                stat: m,
                                textMain: textMain,
                                textSub: textSub,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _aktuellerUmsatz() {
    switch (_zeitraum) {
      case Zeitraum.woche:
        return _umsatzWoche.fold(0, (a, b) => a + b);
      case Zeitraum.monat:
        // hier: Summe der 12 Monatswerte
        return _umsatzMonat.fold(0, (a, b) => a + b);
      case Zeitraum.jahr:
        // hier: letzter Jahreswert
        return _umsatzJahr.isNotEmpty ? _umsatzJahr.last : 0;
    }
  }

  List<double> _chartValues() {
    switch (_zeitraum) {
      case Zeitraum.woche:
        return _umsatzWoche;
      case Zeitraum.monat:
        return _umsatzMonat;
      case Zeitraum.jahr:
        return _umsatzJahr;
    }
  }

  int _labelCount() {
    switch (_zeitraum) {
      case Zeitraum.woche:
        return 7;
      case Zeitraum.monat:
        return 12;
      case Zeitraum.jahr:
        return 5;
    }
  }

  String _formatEuro(double v) {
    // Simple: später Intl
    final rounded = v.round();
    final s = rounded.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return "${buf.toString()} €";
  }
}

class _ZeitraumSwitch extends StatelessWidget {
  final Zeitraum value;
  final ValueChanged<Zeitraum> onChanged;

  const _ZeitraumSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Zeitraum>(
      segments: const [
        ButtonSegment(value: Zeitraum.woche, label: Text("Woche")),
        ButtonSegment(value: Zeitraum.monat, label: Text("Monat")),
        ButtonSegment(value: Zeitraum.jahr, label: Text("Jahr")),
      ],
      selected: {value},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}

class _Panel extends StatelessWidget {
  final Color bg;
  final Color border;
  final String title;
  final String subtitle;
  final Widget child;

  const _Panel({
    required this.bg,
    required this.border,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r22),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(AppRadii.r22),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final Color bg;
  final Color border;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color valueColor;
  final Color textMain;
  final Color textSub;

  const _KpiCard({
    required this.bg,
    required this.border,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.valueColor,
    required this.textMain,
    required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r22),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(AppRadii.r22),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: valueColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: textSub)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> values;
  final int labelCount;
  final Color barColor;
  final Color textColor;
  final Color axisColor;

  const _BarChart({
    required this.values,
    required this.labelCount,
    required this.barColor,
    required this.textColor,
    required this.axisColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final v in values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      height: (v / maxV) * 220,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: axisColor),
        const SizedBox(height: 10),
        Text(
          "Skala: 0 – ${maxV.round()}",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String label;
  final double value;
  final Color textMain;
  final Color textSub;

  const _ServiceRow({
    required this.label,
    required this.value,
    required this.textMain,
    required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: TextStyle(color: textMain, fontWeight: FontWeight.w800)),
            ),
            Text("$pct%", style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: const Color.fromARGB(25, 0, 0, 0),
            color: AppColors.orange,
          ),
        ),
      ],
    );
  }
}

class _TeamTile extends StatelessWidget {
  final _MitarbeiterStat stat;
  final Color textMain;
  final Color textSub;

  const _TeamTile({
    required this.stat,
    required this.textMain,
    required this.textSub,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (stat.auslastung * 100).round();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.orangeSoft,
            child: const Icon(Icons.person, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stat.name, style: TextStyle(color: textMain, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text("${stat.termine} Termine • $pct% Auslastung", style: TextStyle(color: textSub, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(20, 0, 0, 0),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              "No-Shows: ${stat.noShows}",
              style: TextStyle(color: textSub, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _MitarbeiterStat {
  final String name;
  final int termine;
  final double auslastung; // 0..1
  final int noShows;

  const _MitarbeiterStat(this.name, this.termine, this.auslastung, this.noShows);
}
