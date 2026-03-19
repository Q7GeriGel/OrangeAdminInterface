import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

class WeeklyHeader extends StatelessWidget {
  const WeeklyHeader({
    super.key,
    required this.monday,
    required this.onPrev,
    required this.onToday,
    required this.onNext,
  });

  final DateTime monday;
  final VoidCallback onPrev;
  final VoidCallback onToday;
  final VoidCallback onNext;

  static const _orange = Color(0xFFF57C00);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final rangeStart = DateFormat('dd.MM').format(monday);
    final rangeEnd = DateFormat('dd.MM').format(monday.add(const Duration(days: 5)));
    final rangeText = '$rangeStart – $rangeEnd';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : Colors.black.withAlpha(25);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconChip(onTap: onPrev, icon: Icons.chevron_left, borderColor: borderColor),
        const SizedBox(width: 8),

        TextButton(
          onPressed: onToday,
          style: TextButton.styleFrom(
            foregroundColor: _orange,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: const StadiumBorder(),
          ),
          child: Text(t.today, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),

        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(rangeText, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),

        _IconChip(onTap: onNext, icon: Icons.chevron_right, borderColor: borderColor),
      ],
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.onTap,
    required this.icon,
    required this.borderColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}