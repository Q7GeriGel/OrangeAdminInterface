import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/termin.dart';
import 'appointment_block.dart';

class WeeklyGrid extends StatefulWidget {
  const WeeklyGrid({
    super.key,
    required this.monday,
    required this.appointments,
    this.startHour = 8,
    this.endHour = 20, // exclusive
    this.slotMinutes = 30,
    this.slotHeight = 40,
    this.timeGutterWidth = 72,
    this.dayColumnMinWidth = 190,
    this.headerHeight = 48,
    required this.onTapEmptySlot,
    required this.onDoubleTapTermin,
  });

  final DateTime monday;
  final List<Termin> appointments;
  final int startHour;
  final int endHour;
  final int slotMinutes;
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
    final totalSlots = ((widget.endHour - widget.startHour) * 60) ~/ widget.slotMinutes;
    final totalHeight = totalSlots * widget.slotHeight;

    final borderSide = Divider.createBorderSide(context);

    // Header
    final header = SizedBox(
      height: widget.headerHeight,
      child: Row(
        children: [
          SizedBox(width: widget.timeGutterWidth),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((d) {
                  final label =
                      '${['Mo','Di','Mi','Do','Fr','Sa'][d.weekday - 1]} '
                      '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}';
                  return ConstrainedBox(
                    constraints: BoxConstraints(minWidth: widget.dayColumnMinWidth),
                    child: Container(
                      alignment: Alignment.center,
                      height: widget.headerHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: borderSide,
                          right: borderSide,
                        ),
                      ),
                      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    // Body (vertikal scrollt alles gemeinsam)
    final body = Expanded(
      child: SingleChildScrollView(
        controller: _vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zeit-Gutter
            SizedBox(
              width: widget.timeGutterWidth,
              height: totalHeight,
              child: Column(
                children: List.generate(totalSlots, (i) {
                  final minutesFromStart = i * widget.slotMinutes;
                  final hour = widget.startHour + (minutesFromStart ~/ 60);
                  final minute = minutesFromStart % 60;

                  return Container(
                    height: widget.slotHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        right: borderSide,
                        bottom: borderSide,
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}',
                      style: TextStyle(
                        fontSize: minute == 0 ? 13 : 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Tage (horizontal scroll)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: days.map((day) {
                    final dayStart = DateTime(day.year, day.month, day.day, widget.startHour, 0);
                    final dayEnd = DateTime(day.year, day.month, day.day, widget.endHour, 0);

                    final dayTermine = widget.appointments.where((t) {
                      final s = t.start;
                      return s.year == day.year && s.month == day.month && s.day == day.day;
                    }).toList()
                      ..sort((a, b) => a.start.compareTo(b.start));

                    final laidOut = _layoutDay(dayTermine);

                    return SizedBox(
                      width: widget.dayColumnMinWidth,
                      height: totalHeight,
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          // Background grid + empty slot taps
                          Column(
                            children: List.generate(totalSlots, (i) {
                              final slotStart = dayStart.add(Duration(minutes: i * widget.slotMinutes));
                              final slotEnd = slotStart.add(Duration(minutes: widget.slotMinutes));

                              final busy = dayTermine.any((t) =>
                                  t.start.isBefore(slotEnd) && t.end.isAfter(slotStart));

                              return InkWell(
                                onTap: busy ? null : () => widget.onTapEmptySlot(slotStart),
                                child: Container(
                                  height: widget.slotHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: borderSide,
                                      bottom: borderSide,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          // Appointment overlays (echte Blöcke)
                          for (final x in laidOut)
                            Positioned(
                              top: _topFor(x.t.start, dayStart),
                              left: 6 + x.lane * _laneWidth(x.lanes),
                              width: _laneWidth(x.lanes) - 6,
                              height: _heightFor(x.t.start, x.t.end, dayStart, dayEnd),
                              child: AppointmentBlock(
                                a: x.t,
                                onDoubleTap: widget.onDoubleTapTermin,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(children: [header, body]);
  }

  double _topFor(DateTime start, DateTime dayStart) {
    final min = start.difference(dayStart).inMinutes;
    final slots = min / widget.slotMinutes;
    return (slots * widget.slotHeight).clamp(0, double.infinity);
  }

  double _heightFor(DateTime start, DateTime end, DateTime dayStart, DateTime dayEnd) {
    final s = start.isBefore(dayStart) ? dayStart : start;
    final e = end.isAfter(dayEnd) ? dayEnd : end;
    final minutes = e.difference(s).inMinutes;
    final h = (minutes / widget.slotMinutes) * widget.slotHeight;
    return h < widget.slotHeight ? widget.slotHeight : h;
  }

  double _laneWidth(int lanes) => (widget.dayColumnMinWidth - 12) / lanes;

  // ---------------------------
  // Overlap-Layout pro Tag
  // ---------------------------
  List<_LaidTermin> _layoutDay(List<Termin> list) {
    if (list.isEmpty) return [];

    // Gruppen (überlappende Bereiche)
    final sorted = List<Termin>.from(list)..sort((a, b) => a.start.compareTo(b.start));

    final groups = <List<Termin>>[];
    var current = <Termin>[];
    DateTime currentEnd = sorted.first.end;

    for (final t in sorted) {
      if (current.isEmpty) {
        current = [t];
        currentEnd = t.end;
        continue;
      }
      // overlap?
      if (t.start.isBefore(currentEnd)) {
        current.add(t);
        if (t.end.isAfter(currentEnd)) currentEnd = t.end;
      } else {
        groups.add(current);
        current = [t];
        currentEnd = t.end;
      }
    }
    if (current.isNotEmpty) groups.add(current);

    // pro Gruppe Lanes greedy
    final out = <_LaidTermin>[];
    for (final g in groups) {
      final lanesEnd = <DateTime>[];
      final assigned = <Termin, int>{};

      for (final t in g..sort((a, b) => a.start.compareTo(b.start))) {
        int lane = lanesEnd.indexWhere((e) => !e.isAfter(t.start)); // e <= start
        if (lane == -1) {
          lane = lanesEnd.length;
          lanesEnd.add(t.end);
        } else {
          lanesEnd[lane] = t.end;
        }
        assigned[t] = lane;
      }

      final laneCount = lanesEnd.length;
      for (final t in g) {
        out.add(_LaidTermin(t: t, lane: assigned[t]!, lanes: laneCount));
      }
    }
    return out;
  }
}

class _LaidTermin {
  final Termin t;
  final int lane;
  final int lanes;
  _LaidTermin({required this.t, required this.lane, required this.lanes});
}
