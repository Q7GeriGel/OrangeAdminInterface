import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../widgets/kalender/weekly_header.dart';
import '../widgets/kalender/weekly_grid.dart';
import '../widgets/kalender/termin_details_dialog.dart';
import '../widgets/kalender/termin_create_dialog.dart';

class TermineWochenansicht extends StatelessWidget {
  const TermineWochenansicht({super.key});

  static const _pageBg = Color(0xFFF4F4F4);
  static const _panelBlue = Color(0xFF355573);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Terminübersicht',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => openCreateTerminFlow(context: context, ctrl: ctrl),
                    icon: const Icon(Icons.add),
                    label: const Text('Neuer Termin'),
                  ),
                  const SizedBox(width: 12),
                  WeeklyHeader(
                    monday: ctrl.currentWeekMonday,
                    onPrev: ctrl.prevWeek,
                    onToday: ctrl.goToday,
                    onNext: ctrl.nextWeek,
                  ),
                ],
              ),
              const SizedBox(height: 12),

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
                                onTapEmptySlot: (slot) => openCreateTerminFlow(
                                  context: context,
                                  ctrl: ctrl,
                                  presetStart: slot,
                                ),
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
                                    onChangeDuration: (minutes) => ctrl.updateDuration(t.id, minutes),
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
        ),
      ),
    );
  }
}
