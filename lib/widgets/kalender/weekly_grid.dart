import 'package:flutter/material.dart';
import '../../models/termin.dart';
import 'slot_cell.dart';

class WeeklyGrid extends StatefulWidget {
  const WeeklyGrid({
    super.key,
    required this.monday,
    required this.appointments,
    this.startHour = 8,
    this.endHour = 20, // exclusive
    this.slotMinutes = 30,
    this.slotHeight = 44,
    this.timeGutterWidth = 72,
    this.dayColumnMinWidth = 190,
    this.headerHeight = 48,
    required this.onTapEmptySlot,
    required this.onDoubleTapTermin,
  });

  final DateTime monday;
  final List<Termin> appointments;
  final int startHour;
  final int endHour; // exclusive
  final int slotMinutes; // 30
  final double slotHeight;
  final double timeGutterWidth;
  final double dayColumnMinWidth;
  final double headerHeight;
  final void Function(DateTime) onTapEmptySlot;
  final void Function(Termin) onDoubleTapTermin;

  @override
  State<WeeklyGrid> createState() => _WeeklyGridState();
}

class _WeeklyGridState extends State<WeeklyGrid> {
  late final ScrollController _vertical;

  @override
  void initState() {
    super.initState();
    _vertical = ScrollController();

    // Beim Öffnen grob zur aktuellen Zeit scrollen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      if (now.hour >= widget.startHour && now.hour < widget.endHour) {
        final slotsPerHour = 60 ~/ widget.slotMinutes;
        final fromStart =
            (now.hour - widget.startHour) * slotsPerHour + (now.minute >= 30 ? 1 : 0);
        final px = fromStart * widget.slotHeight;

        if (_vertical.hasClients) {
          _vertical.jumpTo(px.clamp(0, _vertical.position.maxScrollExtent));
        }
      }
    });
  }

  @override
  void dispose() {
    _vertical.dispose();
    super.dispose();
  }

  List<DateTime> _daysMoSa(DateTime monday) =>
      List.generate(6, (i) => DateTime(monday.year, monday.month, monday.day + i));

  @override
  Widget build(BuildContext context) {
    final days = _daysMoSa(widget.monday);
    final slotsPerHour = 60 ~/ widget.slotMinutes;
    final totalSlots = (widget.endHour - widget.startHour) * slotsPerHour;

    final gridLine = BorderSide(color: Colors.black.withAlpha(18), width: 1);

    // Header: Tageslabels (Mo–Sa)
    final header = Container(
      height: widget.headerHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border(bottom: gridLine),
      ),
      child: Row(
        children: [
          SizedBox(width: widget.timeGutterWidth),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((d) {
                  final label =
                      '${['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][d.weekday - 1]} '
                      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
                  return ConstrainedBox(
                    constraints: BoxConstraints(minWidth: widget.dayColumnMinWidth),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.headerHeight,
                      decoration: BoxDecoration(
                        border: Border(right: gridLine),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    // Grid: jede Row = eine Zeitreihe (Gutter + 6 Tag-Zellen)
    final grid = Expanded(
      child: Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        radius: const Radius.circular(999),
        child: ListView.builder(
          controller: _vertical,
          itemCount: totalSlots,
          itemBuilder: (ctx, slotIndex) {
            final hour = widget.startHour + (slotIndex ~/ slotsPerHour);
            final minute = (slotIndex % slotsPerHour) * widget.slotMinutes;

            return SizedBox(
              height: widget.slotHeight,
              child: Row(
                children: [
                  // Zeit-Gutter (links)
                  Container(
                    width: widget.timeGutterWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFBFB),
                      border: Border(
                        right: gridLine,
                        bottom: gridLine,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: minute == 0 ? 13 : 11,
                            fontWeight: minute == 0 ? FontWeight.w700 : FontWeight.w500,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tageszellen (rechts)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: widget.dayColumnMinWidth * days.length,
                        child: Row(
                          children: [
                            for (int dayIndex = 0; dayIndex < days.length; dayIndex++)
                              SlotCell(
                                width: widget.dayColumnMinWidth,
                                slotStart: days[dayIndex].add(
                                  Duration(hours: hour, minutes: minute),
                                ),
                                appointments: widget.appointments,
                                onTapEmpty: widget.onTapEmptySlot,
                                onOpenDetails: widget.onDoubleTapTermin,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    return Column(children: [header, grid]);
  }
}
