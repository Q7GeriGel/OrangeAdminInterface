import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.onLogout,
  });

  String _t(AppLocalizations? l, String fallback, String Function(AppLocalizations x) pick) {
    if (l == null) return fallback;
    try {
      final v = pick(l);
      return v.trim().isEmpty ? fallback : v;
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0E1420) : const Color(0xFFF3F4F6);
    final border = isDark ? Colors.white12 : Colors.black12;

    final items = [
      (_t(l, 'Dashboard', (x) => x.dashboard), Icons.dashboard_outlined),
      (_t(l, 'Kunden', (x) => x.customers), Icons.groups_2_outlined),
      (_t(l, 'Mitarbeiter', (x) => x.employees), Icons.badge_outlined),
      (_t(l, 'Termine', (x) => x.schedule), Icons.event_available_outlined),
      (_t(l, 'Statistik', (x) => x.statistics), Icons.bar_chart_outlined),
      (_t(l, 'Einstellungen', (x) => x.settings), Icons.settings_outlined),
    ];

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),
              const Text(
                'Friseur Orange',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const SizedBox(height: 14),

              ...List.generate(items.length, (i) {
                final (label, icon) = items[i];
                final selected = i == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onSelectIndex(i),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFC95B4C).withAlpha(isDark ? 55 : 40)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? const Color(0xFFC95B4C).withAlpha(90) : border),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: Text(_t(l, 'Abmelden', (x) => x.logout)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
