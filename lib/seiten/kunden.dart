import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/kunden_verwaltung.dart';
import '../models/kunde.dart';
import '../widgets/kunden_tabelle.dart';
import '../widgets/kunde_dialog.dart';

class KundenSeite extends StatefulWidget {
  const KundenSeite({super.key});

  @override
  State<KundenSeite> createState() => _KundenSeiteState();
}

class _KundenSeiteState extends State<KundenSeite> {
  final sucheCtrl = TextEditingController();
  final datumFmt = DateFormat('dd.MM.yyyy');

  static const double topHeight = 44;

  @override
  void initState() {
    super.initState();
    sucheCtrl.addListener(() {
      // ✅ globaler Provider
      context.read<KundenVerwaltung>().sucheSetzen(sucheCtrl.text);
    });
  }

  @override
  void dispose() {
    sucheCtrl.dispose();
    super.dispose();
  }

  Future<void> _filterDialog() async {
    final verwaltung = context.read<KundenVerwaltung>();

    bool? nurStamm = verwaltung.nurStammkunden;
    String? friseur = verwaltung.friseur;

    await showDialog(
      context: context,
      builder: (c) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Filter'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      const SizedBox(width: 90, child: Text('Stammkunde:')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<bool?>(
                          value: nurStamm,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Egal')),
                            DropdownMenuItem(value: true, child: Text('Nur Stammkunden')),
                            DropdownMenuItem(value: false, child: Text('Nur Nicht-Stammkunden')),
                          ],
                          onChanged: (v) => setLocalState(() => nurStamm = v),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      const SizedBox(width: 90, child: Text('Friseur:')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<String?>(
                          value: friseur,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Egal')),
                            ...verwaltung.friseure.map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            ),
                          ],
                          onChanged: (v) => setLocalState(() => friseur = v),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    setLocalState(() {
                      nurStamm = null;
                      friseur = null;
                    });
                  },
                  child: const Text('Zurücksetzen'),
                ),
                FilledButton(
                  onPressed: () {
                    verwaltung.filterSetzen(nurStammkunden: nurStamm, friseur: friseur);
                    Navigator.pop(context);
                  },
                  child: const Text('Übernehmen'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _dialogHinzufuegenBearbeiten({Kunde? bearbeiten}) async {
    final verwaltung = context.read<KundenVerwaltung>();

    final result = await showDialog<Kunde>(
      context: context,
      barrierDismissible: false,
      builder: (c) => KundeDialog(initial: bearbeiten, friseure: verwaltung.friseure),
    );
    if (result == null) return;

    if (bearbeiten == null) {
      verwaltung.hinzufuegen(result);
    } else {
      verwaltung.bearbeiten(result);
    }
  }

  Future<void> _naechstenTerminWaehlen(Kunde k) async {
    final verwaltung = context.read<KundenVerwaltung>();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: k.naechsterTermin ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      final u = k.kopie()..naechsterTermin = picked;
      verwaltung.bearbeiten(u);
    }
  }

  String? _activeFilterText(KundenVerwaltung verwaltung) {
    final parts = <String>[];

    final stamm = verwaltung.nurStammkunden;
    if (stamm == true) parts.add('Nur Stammkunden');
    if (stamm == false) parts.add('Nur Nicht-Stammkunden');

    final fr = verwaltung.friseur;
    if (fr != null && fr.trim().isNotEmpty) parts.add('Friseur: $fr');

    if (parts.isEmpty) return null;
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final verwaltung = context.watch<KundenVerwaltung>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? const Color(0xFF0B0F14) : const Color(0xFFECEDEE);
    final panel = isDark ? const Color(0xFF111821) : const Color(0xFF355573);
    final surface = isDark ? const Color(0xFF141D27) : Colors.white;

    final activeFilters = _activeFilterText(verwaltung);

    return Container(
      color: pageBg,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kunden',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 40 : 10),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: topHeight,
                                decoration: BoxDecoration(
                                  color: surface,
                                  borderRadius: BorderRadius.circular(topHeight / 2),
                                  border: Border.all(
                                    color: isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Icon(Icons.search, size: 20, color: isDark ? Colors.white70 : Colors.black54),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: sucheCtrl,
                                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                        decoration: InputDecoration(
                                          hintText: 'Suche bei Name, Telefonnummer oder Datum (dd.MM.yyyy)',
                                          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: topHeight,
                              height: topHeight,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.white.withAlpha(isDark ? 18 : 35),
                                  child: IconButton(
                                    tooltip: 'Filter',
                                    onPressed: _filterDialog,
                                    icon: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: () => _dialogHinzufuegenBearbeiten(),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFCC5C4C),
                                minimumSize: const Size(0, topHeight),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(Icons.person_add),
                              label: const Text('Neuer Kunde'),
                            ),
                          ],
                        ),
                        if (activeFilters != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Filter aktiv: $activeFilters',
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 12),
                        ],
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(10),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: DataTableTheme(
                                data: DataTableThemeData(
                                  dataTextStyle: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  headingTextStyle: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  dividerThickness: 0.6,
                                ),
                                child: KundenTabelle(
                                  kunden: verwaltung.kunden,
                                  datumFmt: datumFmt,
                                  onBearbeiten: (k) => _dialogHinzufuegenBearbeiten(bearbeiten: k),
                                  onLoeschen: (k) => verwaltung.loeschen(k.id),
                                  onTermin: _naechstenTerminWaehlen,
                                  minLinien: 14,
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}