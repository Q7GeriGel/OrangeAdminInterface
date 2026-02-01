import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int ausgewaehlterIndex;
  final Function(int) beimAuswaehlen;

  const Sidebar({
    super.key,
    required this.ausgewaehlterIndex,
    required this.beimAuswaehlen,
  });

  static const _eintraege = <({IconData icon, String label})>[
    (icon: Icons.dashboard, label: 'Dashboard'),
    (icon: Icons.people, label: 'Kunden'),
    (icon: Icons.badge, label: 'Mitarbeiter'),
    (icon: Icons.calendar_today, label: 'Terminübersicht'),
    (icon: Icons.bar_chart, label: 'Statistik'),
    (icon: Icons.settings, label: 'Einstellungen'),
  ];

  static const _orange = Color(0xFFCC5C4C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFFF1F1F1),
      child: Column(
        children: [
          // ✅ alles weiter runter + oben fix Platz für Logo/Header
          const SizedBox(height: 0),

          // ✅ reservierter Headerbereich (Logo kommt später)
          Container(
            height: 140,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/logo.png',
              width: 110,
              height: 110,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Menü scrollbar, falls Screen klein ist
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _eintraege.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _SidebarEintrag(
                icon: _eintraege[i].icon,
                label: _eintraege[i].label,
                ausgewaehlt: ausgewaehlterIndex == i,
                onTap: () => beimAuswaehlen(i),
              ),
            ),
          ),

          const SizedBox(height: 12),
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

  static const _orange = Color(0xFFCC5C4C);

  @override
  State<_SidebarEintrag> createState() => _SidebarEintragState();
}

class _SidebarEintragState extends State<_SidebarEintrag> {
  bool istHover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.ausgewaehlt
        ? const Color(0xFFE8E8E8)
        : (istHover ? const Color(0xFFEFEFEF) : Colors.transparent);

    final iconColor =
        widget.ausgewaehlt ? _SidebarEintrag._orange : Colors.black87;
    final textColor = widget.ausgewaehlt ? Colors.black : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => istHover = true),
      onExit: (_) => setState(() => istHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Active Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: 4,
                height: 26,
                decoration: BoxDecoration(
                  color: widget.ausgewaehlt
                      ? _SidebarEintrag._orange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),

              Icon(widget.icon, color: iconColor, size: 22),
              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontWeight:
                        widget.ausgewaehlt ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
