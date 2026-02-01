import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../widgets/kalender/weekly_header.dart';
import '../widgets/kalender/weekly_grid.dart';
import '../widgets/kalender/termin_details_dialog.dart';

class TermineWochenansicht extends StatelessWidget {
  const TermineWochenansicht({super.key});

  static const _pageBg = Color(0xFFF4F4F4);
  static const _panelBlue = Color(0xFF355573);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();

    return Container(
      color: _pageBg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header (statt AppBar -> wirkt im Layout mit Sidebar viel sauberer)
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Terminübersicht',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              WeeklyHeader(
                monday: ctrl.currentWeekMonday,
                onPrev: ctrl.prevWeek,
                onToday: ctrl.goToday,
                onNext: ctrl.nextWeek,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Panel wie bei Kunden (premium feel)
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _panelBlue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Material(
                    color: Colors.white,
                    child: ctrl.loading
                        ? const Center(child: CircularProgressIndicator())
                        : WeeklyGrid(
                            monday: ctrl.currentWeekMonday,
                            appointments: ctrl.termine,
                            startHour: 8,
                            endHour: 20,
                            onTapEmptySlot: (slot) => ctrl.createTerminAt(slot),
                            onDoubleTapTermin: (Termin t) async {
                              await showTerminDetailsDialog(
                                context: context,
                                termin: t,
                                onMove: (newTime) {
                                  final newStart = DateTime(
                                    t.start.year,
                                    t.start.month,
                                    t.start.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                  ctrl.moveTermin(t.id, newStart);
                                },
                                onChangeDuration: (minutes) =>
                                    ctrl.updateDuration(t.id, minutes),
                                onToggleStatus: () => ctrl.toggleStatus(t.id),
                                onCancel: () => ctrl.cancelTermin(t.id),
                                onDelete: () => ctrl.deleteTermin(t.id),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
