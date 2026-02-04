import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import 'account_panel.dart';

class Sidebar extends StatelessWidget {
  final int ausgewaehlterIndex;
  final ValueChanged<int> beimAuswaehlen;

  final bool isAdmin;
  final String aktiverAccount;
  final ValueChanged<String> onAccountChanged;

  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.ausgewaehlterIndex,
    required this.beimAuswaehlen,
    required this.isAdmin,
    required this.aktiverAccount,
    required this.onAccountChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B0F14) : Colors.white;
    final border = isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15);
    const orange = Color(0xFFCC5C4C);

    Widget navItem({
      required int index,
      required IconData icon,
      required String label,
    }) {
      final selected = index == ausgewaehlterIndex;

      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => beimAuswaehlen(index),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? orange.withAlpha(isDark ? 28 : 18) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? orange.withAlpha(90) : Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? orange : (isDark ? Colors.white70 : Colors.black54)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: selected ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 285,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          right: BorderSide(color: border),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: orange.withAlpha(isDark ? 28 : 18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: orange.withAlpha(90)),
                    ),
                    child: const Icon(Icons.content_cut, color: orange),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Friseur Orange",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Nav
              navItem(index: 0, icon: Icons.grid_view_rounded, label: t.dashboard),
              const SizedBox(height: 10),
              navItem(index: 1, icon: Icons.people_alt_rounded, label: t.customers),
              const SizedBox(height: 10),
              navItem(index: 2, icon: Icons.badge_rounded, label: t.employees),
              const SizedBox(height: 10),
              navItem(index: 3, icon: Icons.calendar_month_rounded, label: t.schedule),
              const SizedBox(height: 10),
              navItem(index: 4, icon: Icons.query_stats_rounded, label: t.statistics),
              const SizedBox(height: 10),
              navItem(index: 5, icon: Icons.settings_rounded, label: t.settings),

              const Spacer(),

              // ✅ Hesap nur für Admin/Sedat
              AccountPanel(
                isAdmin: isAdmin,
                selected: aktiverAccount,
                onChanged: onAccountChanged,
              ),

              const SizedBox(height: 12),

              // Logout
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text(t.logout),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: orange,
                    side: BorderSide(color: orange.withAlpha(120)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
