// (zu lang für 1 Chat-Nachricht? Nein – ich gebe dir trotzdem FULL FILE)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';

class StatistikSeite extends StatefulWidget {
  final String angemeldeterName;
  final bool isAdmin;

  const StatistikSeite({
    super.key,
    required this.angemeldeterName,
    required this.isAdmin,
  });

  @override
  State<StatistikSeite> createState() => _StatistikSeiteState();
}

class _StatistikSeiteState extends State<StatistikSeite> {
  bool _teamView = false;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _sameName(String a, String b) => a.trim().toLowerCase() == b.trim().toLowerCase();

  double _mockPriceForMinutes(int minutes) {
    if (minutes >= 120) return 45;
    if (minutes >= 90) return 35;
    if (minutes >= 60) return 25;
    if (minutes >= 45) return 20;
    return 15;
  }

  List<Termin> _scopeTermine(TerminplanController ctrl) {
    if (widget.isAdmin && _teamView) return ctrl.termine;
    return ctrl.termine.where((t) => _sameName(t.mitarbeiterName, widget.angemeldeterName)).toList();
  }

  List<FreiesZeitfenster> _calcFreeSlotsForDay(List<Termin> scope, DateTime day) {
    const startHour = 8;
    const endHour = 20;
    const slotMinutes = 30;

    final d0 = DateTime(day.year, day.month, day.day);
    final dayStart = DateTime(d0.year, d0.month, d0.day, startHour, 0);
    final dayEnd = DateTime(d0.year, d0.month, d0.day, endHour, 0);

    bool overlaps(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
      return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
    }

    final dayTermine = scope.where((t) => _sameDay(t.start, d0) && t.status != Termin.statusAbgesagt).toList();

    final res = <FreiesZeitfenster>[];
    DateTime slot = dayStart;

    while (slot.isBefore(dayEnd)) {
      final slotEnd = slot.add(const Duration(minutes: slotMinutes));
      final busy = dayTermine.any((t) => overlaps(t.start, t.end, slot, slotEnd));
      if (!busy) res.add(FreiesZeitfenster(slot, slotEnd));
      slot = slotEnd;
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ctrl = context.watch<TerminplanController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? const Color(0xFF0B0E14) : const Color(0xFFF4F4F4);
    final cardBg = isDark ? const Color(0xFF121826) : Colors.white;
    final border = isDark ? Colors.white10 : Colors.black12;
    final textMain = isDark ? Colors.white : Colors.black;
    final textSub = isDark ? Colors.white70 : Colors.black54;

    final scope = _scopeTermine(ctrl);

    final monday = ctrl.currentWeekMonday;
    final days = List.generate(6, (i) => DateTime(monday.year, monday.month, monday.day + i));

    final List<double> revByDay = days.map((d) {
      final list = scope.where((x) => _sameDay(x.start, d) && x.status != Termin.statusAbgesagt).toList();
      return list.fold<double>(0, (sum, x) {
        final m = x.end.difference(x.start).inMinutes;
        return sum + (x.price ?? _mockPriceForMinutes(m));
      });
    }).toList();

    final weekRevenue = revByDay.fold<double>(0, (a, b) => a + b);

    final today = DateTime.now();
    final todayList = scope.where((x) => _sameDay(x.start, today) && x.status != Termin.statusAbgesagt).toList();
    final todayRevenue = todayList.fold<double>(0, (sum, x) {
      final m = x.end.difference(x.start).inMinutes;
      return sum + (x.price ?? _mockPriceForMinutes(m));
    });

    const totalSlots = 24; // 08:00–20:00 in 30min
    final freieHeute = _calcFreeSlotsForDay(scope, today);
    final freeSlots = freieHeute.length;
    final busySlots = (totalSlots - freeSlots).clamp(0, totalSlots);
    final idleMinutes = freeSlots * 30;
    final occupancyPct = totalSlots == 0 ? 0 : ((busySlots / totalSlots) * 100).round();

    Widget content(double maxW) {
      final wide = maxW >= 1100;

      final left = _LeftPanel(
        t: t,
        isDark: isDark,
        cardBg: cardBg,
        border: border,
        textMain: textMain,
        textSub: textSub,
        revByDay: revByDay,
        days: days,
        scopeTermine: scope,
        headlineName: widget.isAdmin && _teamView ? t.team : widget.angemeldeterName,
      );

      final right = _RightPanel(
        t: t,
        isDark: isDark,
        cardBg: cardBg,
        border: border,
        textMain: textMain,
        textSub: textSub,
        weekRevenue: weekRevenue,
        todayRevenue: todayRevenue,
        idleMinutes: idleMinutes,
        occupancyPct: occupancyPct,
        busySlots: busySlots,
        totalSlots: totalSlots,
        freieHeute: freieHeute,
        isAdmin: widget.isAdmin,
        teamMode: widget.isAdmin && _teamView,
      );

      if (wide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: left),
            const SizedBox(width: 18),
            Expanded(flex: 4, child: right),
          ],
        );
      }

      return Column(
        children: [
          left,
          const SizedBox(height: 18),
          right,
        ],
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: LayoutBuilder(
            builder: (context, c) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopBar(
                    t: t,
                    title: t.statisticsTitle,
                    name: widget.angemeldeterName,
                    isAdmin: widget.isAdmin,
                    isDark: isDark,
                    teamValue: _teamView,
                    onTeamChanged: widget.isAdmin ? (v) => setState(() => _teamView = v) : null,
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      child: content(c.maxWidth),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final AppLocalizations t;
  final String title;
  final String name;
  final bool isAdmin;
  final bool isDark;

  final bool teamValue;
  final ValueChanged<bool>? onTeamChanged;

  const _TopBar({
    required this.t,
    required this.title,
    required this.name,
    required this.isAdmin,
    required this.isDark,
    required this.teamValue,
    required this.onTeamChanged,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark ? Colors.white12 : Colors.black12;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        if (onTeamChanged != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Text(
                  teamValue ? t.team : t.onlyMe,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Switch.adaptive(
                  value: teamValue,
                  onChanged: onTeamChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black12,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                isAdmin ? Icons.verified_user : Icons.person,
                size: 18,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                '$name${isAdmin ? ' (${t.roleAdmin})' : ''}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeftPanel extends StatelessWidget {
  final AppLocalizations t;
  final bool isDark;
  final Color cardBg;
  final Color border;
  final Color textMain;
  final Color textSub;

  final List<double> revByDay;
  final List<DateTime> days;
  final List<Termin> scopeTermine;
  final String headlineName;

  const _LeftPanel({
    required this.t,
    required this.isDark,
    required this.cardBg,
    required this.border,
    required this.textMain,
    required this.textSub,
    required this.revByDay,
    required this.days,
    required this.scopeTermine,
    required this.headlineName,
  });

  bool _busyAt(DateTime slotStart, DateTime slotEnd) {
    return scopeTermine.any((x) => x.start.isBefore(slotEnd) && x.end.isAfter(slotStart) && x.status != Termin.statusAbgesagt);
  }

  @override
  Widget build(BuildContext context) {
    final maxRev = revByDay.isEmpty ? 0.0 : revByDay.reduce((a, b) => a > b ? a : b);

    final times = List.generate(24, (i) {
      final h = 8 + (i ~/ 2);
      final m = (i % 2) * 30;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    });

    final barColor = const Color(0xFFCC5C4C).withOpacity(isDark ? 0.92 : 0.95);

    final dayLabels = [t.monShort, t.tueShort, t.wedShort, t.thuShort, t.friShort, t.satShort];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.revenueTrendWeekTitle,
            style: TextStyle(fontWeight: FontWeight.w900, color: textMain, fontSize: 16),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(6, (i) {
                final v = revByDay[i];
                final h = (maxRev <= 0) ? 0.0 : (v / maxRev);
                final barH = (h * 100).clamp(0.0, 100.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barH < 8 ? 8 : barH,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          dayLabels[i],
                          style: TextStyle(color: textSub, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 18),
          Divider(color: isDark ? Colors.white10 : Colors.black12),
          const SizedBox(height: 14),

          Text(
            t.idleHeatmapTitle,
            style: TextStyle(fontWeight: FontWeight.w900, color: textMain, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text('${t.idleHeatmapFor} $headlineName', style: TextStyle(color: textSub, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _LegendDot(label: t.legendIdle, color: const Color(0xFFCC5C4C).withOpacity(0.8), textColor: textSub),
              _LegendDot(label: t.legendBooked, color: const Color(0xFF2E7DDB).withOpacity(0.8), textColor: textSub),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 58),
                      ...List.generate(6, (i) {
                        final txt = dayLabels[i];
                        return SizedBox(
                          width: 44,
                          child: Center(
                            child: Text(txt, style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...List.generate(times.length, (r) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 58,
                            child: Text(times[r], style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
                          ),
                          ...List.generate(6, (c) {
                            final d = days[c];
                            final slotStart = DateTime(d.year, d.month, d.day, 8 + (r ~/ 2), (r % 2) * 30);
                            final slotEnd = slotStart.add(const Duration(minutes: 30));

                            final busy = _busyAt(slotStart, slotEnd);

                            final color = busy
                                ? const Color(0xFF2E7DDB).withOpacity(0.75)
                                : const Color(0xFFCC5C4C).withOpacity(0.75);

                            return Container(
                              width: 44,
                              height: 18,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _LegendDot({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  final AppLocalizations t;
  final bool isDark;
  final Color cardBg;
  final Color border;
  final Color textMain;
  final Color textSub;

  final double weekRevenue;
  final double todayRevenue;
  final int idleMinutes;
  final int occupancyPct;
  final int busySlots;
  final int totalSlots;

  final List<FreiesZeitfenster> freieHeute;
  final bool isAdmin;
  final bool teamMode;

  const _RightPanel({
    required this.t,
    required this.isDark,
    required this.cardBg,
    required this.border,
    required this.textMain,
    required this.textSub,
    required this.weekRevenue,
    required this.todayRevenue,
    required this.idleMinutes,
    required this.occupancyPct,
    required this.busySlots,
    required this.totalSlots,
    required this.freieHeute,
    required this.isAdmin,
    required this.teamMode,
  });

  String euro(double v) => '€ ${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _MetricTile(
        title: t.metricWeekRevenue,
        value: euro(weekRevenue),
        icon: Icons.payments_outlined,
      ),
      _MetricTile(
        title: t.metricTodayRevenue,
        value: euro(todayRevenue),
        icon: Icons.calendar_today_outlined,
      ),
      _MetricTile(
        title: t.metricIdleToday,
        value: '$idleMinutes min',
        subtitle: teamMode ? t.forTeam : t.forMe,
        icon: Icons.timer_outlined,
      ),
      _MetricTile(
        title: t.metricUtilToday,
        value: '$occupancyPct%',
        subtitle: '$busySlots/$totalSlots',
        icon: Icons.pie_chart_outline,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tiles.map((x) => Padding(padding: const EdgeInsets.only(bottom: 12), child: x)),

          const SizedBox(height: 8),
          Divider(color: isDark ? Colors.white10 : Colors.black12),
          const SizedBox(height: 10),

          Text(
            t.freeSlotsTop,
            style: TextStyle(color: textMain, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 10),

          ...freieHeute.take(4).map((f) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, color: isDark ? Colors.white70 : Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f.beschriftung,
                        style: TextStyle(color: textMain, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCC5C4C).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        t.free,
                        style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          if (isAdmin) ...[
            const SizedBox(height: 8),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            const SizedBox(height: 10),
            Text(
              t.adminToolsLater,
              style: TextStyle(color: textMain, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              t.adminToolsDesc,
              style: TextStyle(color: textSub, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Colors.white10 : Colors.black.withAlpha(8);
    final border = isDark ? Colors.white12 : Colors.black12;

    final textMain = isDark ? Colors.white : Colors.black;
    final textSub = isDark ? Colors.white70 : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Icon(icon, color: textMain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(color: textMain, fontWeight: FontWeight.w900, fontSize: 18)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: TextStyle(color: textSub, fontWeight: FontWeight.w800)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
