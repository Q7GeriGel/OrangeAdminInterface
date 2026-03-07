import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/terminplan_controller.dart';
import '../l10n/gen/app_localizations.dart';
import 'box_shared.dart';

class AktuelleAenderungenBox extends StatelessWidget {
  const AktuelleAenderungenBox({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ctrl = context.watch<TerminplanController>();

    final entries = ctrl.aenderungen.take(8).map((s) {
      Color? accent;
      final lower = s.toLowerCase();

      // DE + EN + TR Keywords
      final isCancel = lower.contains('storniert') ||
          lower.contains('abgesagt') ||
          lower.contains('cancel') ||
          lower.contains('iptal') ||
          lower.contains('iptal edildi') ||
          lower.contains('cancelled');

      final isMove = lower.contains('verschoben') ||
          lower.contains('move') ||
          lower.contains('moved') ||
          lower.contains('ertelendi') ||
          lower.contains('taşındı') ||
          lower.contains('degistir');

      final isNew = lower.contains('neu') ||
          lower.contains('new') ||
          lower.contains('yeni') ||
          lower.contains('eklendi') ||
          lower.contains('created');

      final isDelete = lower.contains('gelöscht') ||
          lower.contains('deleted') ||
          lower.contains('remove') ||
          lower.contains('silindi') ||
          lower.contains('kaldır');

      if (isCancel) {
        accent = Colors.redAccent;
      } else if (isMove) {
        accent = Colors.orangeAccent;
      } else if (isNew) {
        accent = const Color(0xFF2E7D32);
      } else if (isDelete) {
        accent = const Color(0xFFB71C1C);
      }

      return DashboardEntry(s, accent: accent);
    }).toList();

    return DashboardBox(
      icon: Icons.refresh,
      titel: t.boxCurrentChangesTitle,
      eintraege: entries,
      height: 360,
      emptyText: t.boxCurrentChangesEmpty,
    );
  }
}
