import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kunde.dart';

/// Tabelle ohne Render-Overflow:
/// - Spalten nutzen FLEX anstatt fixer Pixelbreiten (passt sich der verfügbaren Breite an)
/// - Einheitliche Höhen: Header und Zeilen
/// - Icons kompakt und innerhalb fester Breite, damit nichts übersteht
/// - Bei langen Texten: ellipsis
class KundenTabelle extends StatelessWidget {
  final List<Kunde> kunden;
  final DateFormat datumFmt;
  final void Function(Kunde) onBearbeiten;
  final void Function(Kunde) onLoeschen;
  final void Function(Kunde) onTermin;
  final int minLinien;

  const KundenTabelle({
    super.key,
    required this.kunden,
    required this.datumFmt,
    required this.onBearbeiten,
    required this.onLoeschen,
    required this.onTermin,
    this.minLinien = 12,
  });

  static const double _rowHeight = 36;     // fixe Zeilenhöhe
  static const double _headerHeight = 48;  // fixe Headerhöhe

  String _fmt(DateTime? d) => d == null ? '' : datumFmt.format(d);

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          height: 1.2,
        );

    // Wieviele leere Linien für "Papierlinien"-Look?
    final rows = kunden;
    final filler = (minLinien - rows.length).clamp(0, 999);

    return Column(
      children: [
        // ---------- HEADER ----------
        SizedBox(
          height: _headerHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                _HeaderCell(text: 'Name', flex: 3),
                _HeaderCell(text: 'Telefonnummer', flex: 3),
                _HeaderCell(text: 'Stammkunde', flex: 2, center: true),
                _HeaderCell(text: 'Bevorzugter Friseur', flex: 3),
                _HeaderCell(text: 'Letzter', flex: 2),
                _HeaderCell(text: 'Nächster Termin', flex: 3),
                _HeaderCell(text: 'Aktionen', flex: 2, end: true),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

        // ---------- ZEILEN ----------
        Expanded(
          child: ListView.builder(
            itemCount: rows.length + filler,
            itemBuilder: (context, i) {
              if (i >= rows.length) {
                // Leere Linie mit fixer Höhe
                return const _EmptyLine(height: _rowHeight);
              }

              final k = rows[i];
              return Column(
                children: [
                  SizedBox(
                    height: _rowHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Name
                          Expanded(
                            flex: 3,
                            child: Text(
                              k.name,
                              style: bodyStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Telefon
                          Expanded(
                            flex: 3,
                            child: Text(
                              k.telefonnummer,
                              style: bodyStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Stammkunde (zentriert)
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: k.stammkunde,
                                  onChanged: (_) {},
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Friseur
                          Expanded(
                            flex: 3,
                            child: Text(
                              k.bevorzugterFriseur,
                              style: bodyStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Letzter
                          Expanded(
                            flex: 2,
                            child: Text(
                              _fmt(k.letzterHaarschnitt),
                              style: bodyStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Nächster
                          Expanded(
                            flex: 3,
                            child: Text(
                              _fmt(k.naechsterTermin),
                              style: bodyStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Aktionen (rechtsbündig, kompakt)
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 96, // genug Platz für 3 kompakte Buttons
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _iconBtn(
                                      icon: Icons.edit,
                                      tip: 'Bearbeiten',
                                      onTap: () => onBearbeiten(k),
                                    ),
                                    _iconBtn(
                                      icon: Icons.calendar_today,
                                      tip: 'Termin',
                                      onTap: () => onTermin(k),
                                      size: 16,
                                    ),
                                    _iconBtn(
                                      icon: Icons.delete,
                                      tip: 'Löschen',
                                      onTap: () => onLoeschen(k),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget _iconBtn({
    required IconData icon,
    required String tip,
    required VoidCallback onTap,
    double size = 18,
  }) {
    return IconButton(
      tooltip: tip,
      onPressed: onTap,
      icon: Icon(icon, size: size),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      visualDensity: VisualDensity.compact,
      splashRadius: 18,
    );
  }
}

/// Header-Zelle mit Flex, optional zentriert/rechtsbündig
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool center;
  final bool end;

  const _HeaderCell({
    required this.text,
    required this.flex,
    this.center = false,
    this.end = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black.withValues(alpha: 0.08),
        );

    Alignment align = Alignment.centerLeft;
    if (center) align = Alignment.center;
    if (end) align = Alignment.centerRight;

    return Expanded(
      flex: flex,
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Leere Linie in Tabellenhöhe für die "Papierlinien"-Optik
class _EmptyLine extends StatelessWidget {
  final double height;
  const _EmptyLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
      ),
    );
  }
}
