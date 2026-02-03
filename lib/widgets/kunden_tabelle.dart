import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kunde.dart';

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
    const nameW = 220.0;
    const telW = 220.0;
    const stammW = 120.0;
    const friseurW = 180.0;
    const letzterW = 120.0;
    const nextW = 140.0;
    const actionsW = 120.0;

    const rowH = 56.0;

    final headerStyle = TextStyle(
      color: Colors.black.withAlpha(210),
      fontWeight: FontWeight.w900,
      fontSize: 13,
    );

    final cellStyle = TextStyle(
      color: Colors.black.withAlpha(210),
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    final subStyle = TextStyle(
      color: Colors.black.withAlpha(150),
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );

    final totalRows = math.max(widget.kunden.length, widget.minLinien);

    return LayoutBuilder(
      builder: (context, c) {
        final minTableWidth =
            nameW + telW + stammW + friseurW + letzterW + nextW + actionsW;

        final tableWidth = math.max(c.maxWidth, minTableWidth);

        Widget headerCell(String text, double w, {Alignment a = Alignment.centerLeft}) {
          return SizedBox(
            width: w,
            child: Align(alignment: a, child: Text(text, style: headerStyle)),
          );
        }

        Widget dataCell(Widget child, double w, {Alignment a = Alignment.centerLeft}) {
          return SizedBox(width: w, child: Align(alignment: a, child: child));
        }

        Widget rowLine() => Divider(height: 1, thickness: 1, color: Colors.black.withAlpha(14));

        final bodyList = ListView.builder(
          controller: _vCtrl,
          itemCount: totalRows,
          itemBuilder: (context, i) {
            final bool hasData = i < widget.kunden.length;
            final Kunde? k = hasData ? widget.kunden[i] : null;

            return Column(
              children: [
                Container(
                  height: rowH,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    : Colors.black.withAlpha(120),
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
                                      tooltip: 'Bearbeiten',
                                      onPressed: () => widget.onBearbeiten(k),
                                      icon: const Icon(Icons.edit, size: 20),
                                    ),
                                    IconButton(
                                      tooltip: 'Termin setzen',
                                      onPressed: () => widget.onTermin(k),
                                      icon: const Icon(Icons.calendar_month, size: 20),
                                    ),
                                    IconButton(
                                      tooltip: 'Löschen',
                                      onPressed: () => widget.onLoeschen(k),
                                      icon: const Icon(Icons.delete, size: 20),
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
                  color: const Color(0xFFF6F7F9),
                  border: Border(bottom: BorderSide(color: Colors.black.withAlpha(16))),
                ),
                child: Row(
                  children: [
                    headerCell('Name', nameW),
                    headerCell('Telefonnummer', telW),
                    headerCell('Stammkunde', stammW, a: Alignment.center),
                    headerCell('Bevorzugter Friseur', friseurW),
                    headerCell('Letzter', letzterW),
                    headerCell('Nächster Termin', nextW),
                    headerCell('Aktionen', actionsW, a: Alignment.centerRight),
                  ],
                ),
              ),

              Expanded(
                // ✅ WEB: keine Flutter-Scrollbar (Browser macht das schon) -> wirkt cleaner
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

        // Horizontal scroll nur wenn nötig
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
