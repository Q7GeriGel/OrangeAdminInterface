import 'package:flutter/foundation.dart';

@immutable
class WorkDay {
  final int startHour;
  final int endHour;
  const WorkDay({required this.startHour, required this.endHour});

  int get minutes => (endHour - startHour) * 60;
}

class ArbeitszeitPlan {
  static const Map<String, Map<int, WorkDay>> plan = {
    'Serkan': {
      1: WorkDay(startHour: 10, endHour: 18),
      2: WorkDay(startHour: 12, endHour: 20),
      3: WorkDay(startHour: 8, endHour: 16),
      4: WorkDay(startHour: 10, endHour: 20),
      5: WorkDay(startHour: 8, endHour: 14),
      6: WorkDay(startHour: 9, endHour: 15),
    },
    'Samet': {
      1: WorkDay(startHour: 8, endHour: 16),
      2: WorkDay(startHour: 8, endHour: 16),
      3: WorkDay(startHour: 12, endHour: 20),
      4: WorkDay(startHour: 12, endHour: 20),
      5: WorkDay(startHour: 10, endHour: 18),
      6: WorkDay(startHour: 8, endHour: 14),
    },
    'Sedad': {
      1: WorkDay(startHour: 8, endHour: 20),
      2: WorkDay(startHour: 8, endHour: 20),
      3: WorkDay(startHour: 8, endHour: 20),
      4: WorkDay(startHour: 8, endHour: 20),
      5: WorkDay(startHour: 8, endHour: 20),
      6: WorkDay(startHour: 8, endHour: 20),
    },
  };

  static WorkDay? of(String name, int weekday) => plan[name]?[weekday];

  static int workMinutesForWeek(String name, DateTime monday) {
    int total = 0;
    for (int i = 0; i < 6; i++) {
      final day = monday.add(Duration(days: i));
      final w = of(name, day.weekday);
      if (w != null) total += w.minutes;
    }
    return total;
  }
}
