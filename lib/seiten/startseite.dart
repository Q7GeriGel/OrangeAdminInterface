import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import 'dashboard.dart';
import 'kunden.dart' as kunden_page;
import 'mitarbeiter.dart' as mitarbeiter_page;
import 'termine_wochenansicht.dart';
import 'statistik.dart' as statistik_page;
import 'einstellung.dart';

class Startseite extends StatefulWidget {
  final String benutzername;
  final bool isAdmin;

  const Startseite({
    super.key,
    required this.benutzername,
    required this.isAdmin,
  });

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(benutzername: widget.benutzername),
      const kunden_page.KundenSeite(),
      mitarbeiter_page.MitarbeiterSeite(
        benutzername: widget.benutzername,
        isAdmin: widget.isAdmin,
      ),
      TermineWochenansicht(
        isAdmin: widget.isAdmin,
        sichtMitarbeiterName: widget.benutzername,
      ),
      statistik_page.StatistikSeite(
        angemeldeterName: widget.benutzername,
        isAdmin: widget.isAdmin,
      ),
      const EinstellungSeite(),
    ];

    return Scaffold(
      body: Row(
        children: [
          _Rail(
            index: _index,
            onChanged: (i) => setState(() => _index = i),
          ),
          Expanded(
            child: pages[_index],
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _Rail({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);

    return Container(
      width: 240,
      color: bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Text(
                t.appTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 6),
            _NavItem(
              icon: Icons.dashboard_outlined,
              text: t.dashboard,
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
            _NavItem(
              icon: Icons.groups_2_outlined,
              text: t.customers,
              selected: index == 1,
              onTap: () => onChanged(1),
            ),
            _NavItem(
              icon: Icons.badge_outlined,
              text: t.employees,
              selected: index == 2,
              onTap: () => onChanged(2),
            ),
            _NavItem(
              icon: Icons.event_available_outlined,
              text: t.schedule,
              selected: index == 3,
              onTap: () => onChanged(3),
            ),
            _NavItem(
              icon: Icons.bar_chart_outlined,
              text: t.statistics,
              selected: index == 4,
              onTap: () => onChanged(4),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              text: t.settings,
              selected: index == 5,
              onTap: () => onChanged(5),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
                icon: const Icon(Icons.logout),
                label: Text(t.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFF57C00).withAlpha(isDark ? 55 : 40)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFFF57C00).withAlpha(110)
                  : border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
