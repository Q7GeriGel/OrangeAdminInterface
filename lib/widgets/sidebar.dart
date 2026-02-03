import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';

class Sidebar extends StatelessWidget {
  final int ausgewaehlterIndex;
  final ValueChanged<int> beimAuswaehlen;

  const Sidebar({
    super.key,
    required this.ausgewaehlterIndex,
    required this.beimAuswaehlen,
  });

  @override
  Widget build(BuildContext context) {
    // Sidebar darf ruhig dunkel bleiben, passt zu deinem Look
    const bg = Color(0xFF0B0E14);

    final items = <_SideItem>[
      _SideItem("Dashboard", Icons.dashboard_outlined),
      _SideItem("Kunden", Icons.people_alt_outlined),
      _SideItem("Mitarbeiter", Icons.badge_outlined),
      _SideItem("Termine", Icons.calendar_month_outlined),
      _SideItem("Statistik", Icons.query_stats_outlined),
      _SideItem("Einstellungen", Icons.settings_outlined),
    ];

    return Container(
      width: 270,
      color: bg,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.orangeSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.content_cut, color: AppColors.orange),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Friseur Orange",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final selected = i == ausgewaehlterIndex;
                return _SideButton(
                  label: items[i].label,
                  icon: items[i].icon,
                  selected: selected,
                  onTap: () => beimAuswaehlen(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SideItem {
  final String label;
  final IconData icon;
  _SideItem(this.label, this.icon);
}

class _SideButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SideButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF171B22) : const Color(0xFF0F131B);
    final border = selected ? AppColors.orange : Colors.white10;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: selected ? 1.4 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.orange : Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
