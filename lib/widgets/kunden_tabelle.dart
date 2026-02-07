import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/kunde.dart';
import '../l10n/gen/app_localizations.dart';

class KundenTabelle extends StatefulWidget {
  const KundenTabelle({
    super.key,
    required this.kunden,
    required this.datumFmt,
    required this.onBearbeiten,
    required this.onLoeschen,
    required this.onTermin,
    this.minLinien = 12,
  });

  final List<Kunde> kunden;
  final DateFormat datumFmt;

  final void Function(Kunde) onBearbeiten;
  final void Function(Kunde) onLoeschen;
  final void Function(Kunde) onTermin;

  final int minLinien;

  @override
  State<KundenTabelle> createState() => _KundenTabelleState();
}

class _KundenTabelleState extends State<KundenTabelle> {
  final _vCtrl = ScrollController();
  final _hCtrl = ScrollController();

  @override
  void dispose() {
    _vCtrl.dispose();
    _hCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) => d == null ? '—' : widget.datumFmt.format(d);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    const nameW = 220.0;
    const telW = 220.0;
    const stammW = 120.0;
    const friseurW = 180.0;
    const letzterW = 120.0;
    const nextW = 140.0;
    const actionsW = 120.0;

    const rowH = 56.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    // ✅ Farben (schwarze Schrift -> weiß im Dark; "weiß" -> dunkler / nicer)
    final headerBg = isDark ? const Color(0xFF0F131B) : const Color(0xFFF2F4F7);
    final rowBg = isDark ? const Color(0xFF141D27) : Colors.white;
    final rowAltBg = isDark ? const Color(0xFF111821) : const Color(0xFFF9FAFB);

    final headerStyle = TextStyle(
      color: isDark ? Colors.white.withAlpha(235) : Colors.black.withAlpha(210),
      fontWeight: FontWeight.w900,
      fontSize: 13,
    );

    final cellStyle = TextStyle(
      color: isDark ? Colors.white.withAlpha(235) : Colors.black.withAlpha(210),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    final subStyle = TextStyle(
      color: isDark ? Colors.white.withAlpha(180) : Colors.black.withAlpha(150),
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );

    final divider = isDark ? Colors.white.withAlpha(14) : Colors.black.withAlpha(14);
    final headerDivider = isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(16);

    final totalRows = math.max(widget.kunden.length, widget.minLinien);

    return LayoutBuilder(
      builder: (context, c) {
        final minTableWidth = nameW + telW + stammW + friseurW + letzterW + nextW + actionsW;
        final tableWidth = math.max(c.maxWidth, minTableWidth);

        Widget headerCell(String text, double w, {Alignment a = Alignment.centerLeft}) {
          return SizedBox(width: w, child: Align(alignment: a, child: Text(text, style: headerStyle)));
        }

        Widget dataCell(Widget child, double w, {Alignment a = Alignment.centerLeft}) {
          return SizedBox(width: w, child: Align(alignment: a, child: child));
        }

        Widget rowLine() => Divider(height: 1, thickness: 1, color: divider);

        final bodyList = ListView.builder(
          controller: _vCtrl,
          itemCount: totalRows,
          itemBuilder: (context, i) {
            final bool hasData = i < widget.kunden.length;
            final Kunde? k = hasData ? widget.kunden[i] : null;
            final bg = (i % 2 == 0) ? rowBg : rowAltBg;

            return Column(
              children: [
                Container(
                  height: rowH,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: bg,
                  child: Row(
                    children: [
                      dataCell(Text(k?.name ?? '', style: cellStyle), nameW),
                      dataCell(Text(k?.telefonnummer ?? '', style: cellStyle), telW),
                      dataCell(
                        k == null
                            ? const SizedBox.shrink()
                            : Icon(
                                k.stammkunde ? Icons.check_box : Icons.check_box_outline_blank,
                                size: 20,
                                color: k.stammkunde
                                    ? const Color(0xFF2E7D32)
                                    : (isDark ? Colors.white.withAlpha(140) : Colors.black.withAlpha(120)),
                              ),
                        stammW,
                        a: Alignment.center,
                      ),
                      dataCell(Text(k?.bevorzugterFriseur ?? '', style: subStyle), friseurW),
                      dataCell(Text(k == null ? '' : _fmtDate(k.letzterHaarschnitt), style: subStyle), letzterW),
                      dataCell(Text(k == null ? '' : _fmtDate(k.naechsterTermin), style: subStyle), nextW),
                      SizedBox(
                        width: actionsW,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: k == null
                              ? const SizedBox.shrink()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: t.tooltipEdit,
                                      onPressed: () => widget.onBearbeiten(k),
                                      icon: Icon(Icons.edit, size: 20, color: scheme.onSurface.withAlpha(220)),
                                    ),
                                    IconButton(
                                      tooltip: t.tooltipSetAppointment,
                                      onPressed: () => widget.onTermin(k),
                                      icon: Icon(Icons.calendar_month, size: 20, color: scheme.onSurface.withAlpha(220)),
                                    ),
                                    IconButton(
                                      tooltip: t.tooltipDelete,
                                      onPressed: () => widget.onLoeschen(k),
                                      icon: Icon(Icons.delete, size: 20, color: scheme.onSurface.withAlpha(220)),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                rowLine(),
              ],
            );
          },
        );

        final table = SizedBox(
          width: tableWidth,
          child: Column(
            children: [
              Container(
                height: rowH,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: headerBg,
                  border: Border(bottom: BorderSide(color: headerDivider)),
                ),
                child: Row(
                  children: [
                    headerCell(t.tableName, nameW),
                    headerCell(t.tablePhone, telW),
                    headerCell(t.filterRegularLabel.replaceAll(':', ''), stammW, a: Alignment.center),
                    headerCell(t.tableStaff, friseurW),
                    headerCell(t.tableLastVisit, letzterW),
                    headerCell(t.tableNextAppointment, nextW),
                    headerCell(t.tableActions, actionsW, a: Alignment.centerRight),
                  ],
                ),
              ),
              Expanded(
                child: kIsWeb
                    ? bodyList
                    : Scrollbar(
                        controller: _vCtrl,
                        thumbVisibility: true,
                        child: bodyList,
                      ),
              ),
            ],
          ),
        );

        return Scrollbar(
          controller: _hCtrl,
          thumbVisibility: tableWidth > c.maxWidth,
          notificationPredicate: (n) => n.depth == 0,
          child: SingleChildScrollView(
            controller: _hCtrl,
            scrollDirection: Axis.horizontal,
            child: table,
          ),
        );
      },
    );
  }
}
