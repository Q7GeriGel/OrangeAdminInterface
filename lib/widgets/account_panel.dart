import 'package:flutter/material.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

class AccountPanel extends StatelessWidget {
  final bool isAdmin;
  final String selected;
  final ValueChanged<String> onChanged;

  const AccountPanel({
    super.key,
    required this.isAdmin,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) return const SizedBox.shrink(); // ✅ nur Admin/Sedat

    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF111821) : const Color(0xFFF6F7FB);
    final bg2 = isDark ? const Color(0xFF141D27) : Colors.white;
    final border = isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(18);
    const orange = Color(0xFFCC5C4C);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 35 : 18),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.account,
            style: TextStyle(
              color: isDark ? Colors.white.withAlpha(210) : Colors.black.withAlpha(160),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person, color: orange, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selected,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: orange.withAlpha(90)),
                ),
                child: Text(
                  t.roleAdmin,
                  style: const TextStyle(color: orange, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            padding: const EdgeInsets.all(6),
            child: SegmentedButton<String>(
              showSelectedIcon: true,
              segments: const [
                ButtonSegment(value: 'serkan', label: Text('serkan')),
                ButtonSegment(value: 'sedat', label: Text('sedat')),
                ButtonSegment(value: 'samet', label: Text('samet')),
              ],
              selected: {selected},
              onSelectionChanged: (set) => onChanged(set.first),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return orange.withAlpha(35);
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return isDark ? Colors.white : Colors.black;
                  return (isDark ? Colors.white : Colors.black).withAlpha(170);
                }),
                side: WidgetStateProperty.all(const BorderSide(color: Colors.transparent)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
