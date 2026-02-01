import 'package:flutter/material.dart';
import '../../models/termin.dart';

class AppointmentBlock extends StatelessWidget {
  const AppointmentBlock({
    super.key,
    required this.a,
    required this.onDoubleTap,
  });

  final Termin a;
  final void Function(Termin) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final color = a.color ?? Theme.of(context).colorScheme.primary;
    final minutes = a.end.difference(a.start).inMinutes;
    final durText = minutes > 30 ? ' (${minutes}m)' : '';

    return GestureDetector(
      onDoubleTap: () => onDoubleTap(a),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withAlpha(35),
          border: Border.all(color: color.withAlpha(220), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            '${a.kundeName} — bei ${a.mitarbeiterName}$durText',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
