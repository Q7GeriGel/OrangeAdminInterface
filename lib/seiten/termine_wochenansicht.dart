import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../l10n/gen/app_localizations.dart';

import '../widgets/kalender/weekly_header.dart';
import '../widgets/kalender/weekly_grid.dart';
import '../widgets/kalender/termin_details_dialog.dart';
import '../widgets/kalender/termin_create_dialog.dart';

class TermineWochenansicht extends StatelessWidget {
  final bool isAdmin;

  const TermineWochenansicht({
    super.key,
    required this.isAdmin,
  });

  void _noPerm(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.noPermissionAdminOnly)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ctrl = context.watch<TerminplanController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = Theme.of(context).scaffoldBackgroundColor;
    final panel = isDark ? const Color(0xFF111821) : const Color(0xFF355573);
    final inner = isDark ? const Color(0xFF141D27) : Colors.white;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.appointmentsOverview,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                  ),

                  OutlinedButton.icon(
                    onPressed: isAdmin
                        ? () => openCreateTerminFlow(context: context, ctrl: ctrl)
                        : () => _noPerm(context),
                    icon: const Icon(Icons.add),
                    label: Text(l.newAppointment),
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
                    color: panel,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Material(
                        color: inner,
                        child: ctrl.loading
                            ? const Center(child: CircularProgressIndicator())
                            : WeeklyGrid(
                                monday: ctrl.currentWeekMonday,
                                appointments: ctrl.termine,
                                startHour: 8,
                                endHour: 20,

                                onTapEmptySlot: (slot) => isAdmin
                                    ? openCreateTerminFlow(
                                        context: context,
                                        ctrl: ctrl,
                                        presetStart: slot,
                                      )
                                    : _noPerm(context),

                                onDoubleTapTermin: (Termin t) async {
                                  await showTerminDetailsDialog(
                                    context: context,
                                    termin: t,
                                    canEdit: isAdmin,
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
