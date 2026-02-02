import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static const _orange = Color(0xFFCC5C4C);

  @override
  Widget build(BuildContext context) {
    final rangeStart = DateFormat('dd.MM').format(monday);
    final rangeEnd = DateFormat('dd.MM').format(monday.add(const Duration(days: 5)));
    final rangeText = '$rangeStart – $rangeEnd';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconChip(onTap: onPrev, icon: Icons.chevron_left),
        const SizedBox(width: 8),

        TextButton(
          onPressed: onToday,
          style: TextButton.styleFrom(
            foregroundColor: _orange,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: const StadiumBorder(),
          ),
          child: const Text('Heute', style: TextStyle(fontWeight: FontWeight.w800)),
        ),

        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withAlpha(25)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(rangeText, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),

        _IconChip(onTap: onNext, icon: Icons.chevron_right),
      ],
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.onTap, required this.icon});

  final VoidCallback onTap;
  final IconData icon;

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
            border: Border.all(color: Colors.black.withAlpha(25)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}
