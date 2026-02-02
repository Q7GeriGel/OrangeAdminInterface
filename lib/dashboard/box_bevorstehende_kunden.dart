import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../models/termin.dart';
import '../widgets/kalender/termin_details_dialog.dart';

class BevorstehendeKundenBox extends StatelessWidget {
  const BevorstehendeKundenBox({super.key});

  static const _panelBlue = Color(0xFF355573);
  static const _orange = Color(0xFFCC5C4C);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TerminplanController>();
    final list = ctrl.kommendeHeute(limit: 6);

    Future<void> openDetails(Termin t) async {
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
    }

    return SizedBox(
      height: 360,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _panelBlue,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.person, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Bevorstehende Kunden',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.white,
                    child: ctrl.loading
                        ? const Center(child: CircularProgressIndicator())
                        : (list.isEmpty)
                            ? const _EmptyState()
                            : ListView.separated(
                                padding: const EdgeInsets.all(12),
                                itemCount: list.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, i) {
                                  final t = list[i];
                                  final time = DateFormat('HH:mm').format(t.start);
                                  final color = t.color ?? Theme.of(context).colorScheme.primary;
                                  final statusColor = _statusColor(t.status);

                                  return InkWell(
                                    onTap: () => openDetails(t),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: Colors.black.withAlpha(18)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: color.withAlpha(180),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  t.kundeName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${t.mitarbeiterName} • $time',
                                                  style: TextStyle(
                                                    color: Colors.black.withAlpha(150),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: statusColor.withAlpha(25),
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(color: statusColor.withAlpha(80)),
                                            ),
                                            child: Text(
                                              t.status,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case Termin.statusBestaetigt:
        return const Color(0xFF2E7D32);
      case Termin.statusAbgesagt:
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF1565C0);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withAlpha(18)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFCC5C4C).withAlpha(200),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Keine Termine mehr heute',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
