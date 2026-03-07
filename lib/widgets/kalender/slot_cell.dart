import 'package:flutter/material.dart';
import '../../models/termin.dart';
import 'appointment_block.dart';

class SlotCell extends StatelessWidget {
  const SlotCell({
    super.key,
    required this.width,
    required this.slotStart,
    required this.appointments,
    required this.onTapEmpty,
    required this.onOpenDetails,
  });

  final double width;
  final DateTime slotStart;
  final List<Termin> appointments;
  final void Function(DateTime) onTapEmpty;
  final void Function(Termin) onOpenDetails;

  bool _coversSlot(Termin a, DateTime slot) {
    // Slot ist innerhalb [start, end)
    return (a.start.isBefore(slot) || a.start.isAtSameMomentAs(slot)) &&
        slot.isBefore(a.end);
  }

  bool _startsHere(Termin a, DateTime slot) {
    return a.start.isAtSameMomentAs(slot);
  }

  @override
  Widget build(BuildContext context) {
    final covering = appointments.where((a) => _coversSlot(a, slotStart)).toList();
    final startingHere = covering.where((a) => _startsHere(a, slotStart)).toList();

    // Wenn mehrere starten: wir zeigen den ersten + Badge
    final Termin? main = startingHere.isNotEmpty ? startingHere.first : null;
    final int extraCount = startingHere.length > 1 ? (startingHere.length - 1) : 0;

    final gridLine = BorderSide(color: Colors.black.withAlpha(18), width: 1);

    return InkWell(
      onTap: covering.isEmpty ? () => onTapEmpty(slotStart) : null,
      onDoubleTap: covering.isNotEmpty ? () => onOpenDetails(covering.first) : null,
      child: Container(
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border(
            right: gridLine,
            bottom: gridLine,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: Builder(
          builder: (_) {
            if (covering.isEmpty) return const SizedBox.shrink();

            // Termin läuft weiter, aber startet nicht hier -> nur Spur (kein Text, kein Overflow)
            if (main == null) {
              final a = covering.first;
              final color = a.color ?? Theme.of(context).colorScheme.primary;

              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 6,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: color.withAlpha(110),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: AppointmentBlock(
                    a: main,
                    onDoubleTap: onOpenDetails,
                  ),
                ),
                if (extraCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '+$extraCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
