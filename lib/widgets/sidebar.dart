import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int ausgewaehlterIndex;
  final Function(int) beimAuswaehlen;

  const Sidebar({
    super.key,
    required this.ausgewaehlterIndex,
    required this.beimAuswaehlen,
  });

  // Zentrale Definition der Menüpunkte (Reihenfolge = Index)
  static const _eintraege = <({IconData icon, String label})>[
    (icon: Icons.dashboard,        label: 'Dashboard'),
    (icon: Icons.people,           label: 'Kunden'),
    (icon: Icons.badge,            label: 'Mitarbeiter'),
    (icon: Icons.calendar_today,   label: 'Terminübersicht'),
    (icon: Icons.bar_chart,        label: 'Statistik'),
    (icon: Icons.settings,         label: 'Einstellungen'), // 👈 hinzugefügt
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 40),

              // Logo (nur anzeigen, wenn vorhanden)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 50),

              // Menüeinträge
              for (int i = 0; i < _eintraege.length; i++) ...[
                _SidebarEintrag(
                  icon: _eintraege[i].icon,
                  label: _eintraege[i].label,
                  ausgewaehlt: ausgewaehlterIndex == i,
                  onTap: () => beimAuswaehlen(i),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarEintrag extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool ausgewaehlt;
  final VoidCallback onTap;

  const _SidebarEintrag({
    required this.icon,
    required this.label,
    required this.ausgewaehlt,
    required this.onTap,
  });

  @override
  State<_SidebarEintrag> createState() => _SidebarEintragState();
}

class _SidebarEintragState extends State<_SidebarEintrag> {
  bool istHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => istHover = true),
      onExit: (_) => setState(() => istHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: istHover
                ? Colors.grey[300]
                : (widget.ausgewaehlt ? Colors.grey[400] : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.black),
              const SizedBox(width: 10),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }
}
