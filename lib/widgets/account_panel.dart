import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

class AccountPanel extends StatelessWidget {
  final bool isAdmin;
  final String selected;
  final ValueChanged<String> onChanged;

  final List<String> accounts;

  const AccountPanel({
    super.key,
    required this.isAdmin,
    required this.selected,
    required this.onChanged,
    this.accounts = const ['serkan', 'sedat', 'samet'],
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
    if (!isAdmin) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final border = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final text = isDark ? Colors.white : Colors.black;

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
            _t(l, 'Konto', (x) => x.account),
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: text),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: accounts.map((a) {
              final sel = a.toLowerCase() == selected.toLowerCase();
              return ChoiceChip(
                selected: sel,
                label: Text(a),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: sel ? Colors.white : text,
                ),
                selectedColor: const Color(0xFFF57C00),
                onSelected: (_) => onChanged(a),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            _t(l, 'Ansicht filtert Dashboard / Termine / Statistik.', (x) => x.accountPanelHint),
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}