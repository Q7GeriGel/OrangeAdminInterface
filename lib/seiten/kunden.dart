import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final verwaltung = KundenVerwaltung();
  final sucheCtrl = TextEditingController();
  final datumFmt = DateFormat('dd.MM.yyyy');

  // Einheitliche Höhe für Suche/Filter/Neuer-Kunde
  static const double topHeight = 44;

  @override
  void initState() {
    super.initState();
    sucheCtrl.addListener(() {
      verwaltung.sucheSetzen(sucheCtrl.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    sucheCtrl.dispose();
    verwaltung.dispose();
    super.dispose();
  }

  Future<void> _filterDialog() async {
    bool? nurStamm = verwaltung.nurStammkunden;
    String? friseur = verwaltung.friseur;

    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Filter'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                const Text('Stammkunde:'),
                const SizedBox(width: 12),
                DropdownButton<bool?>(
                  value: nurStamm,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Egal')),
                    DropdownMenuItem(value: true, child: Text('Nur Stammkunden')),
                    DropdownMenuItem(value: false, child: Text('Nur Nicht‑Stammkunden')),
                  ],
                  onChanged: (v) => nurStamm = v,
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Text('Friseur:'),
                const SizedBox(width: 12),
                DropdownButton<String?>(
                  value: friseur,
                  hint: const Text('Egal'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Egal')),
                    ...verwaltung.friseure
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  ],
                  onChanged: (v) => friseur = v,
                ),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          FilledButton(
            onPressed: () {
              verwaltung.filterSetzen(nurStammkunden: nurStamm, friseur: friseur);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Übernehmen'),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogHinzufuegenBearbeiten({Kunde? bearbeiten}) async {
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
    setState(() {});
  }

  Future<void> _naechstenTerminWaehlen(Kunde k) async {
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageBg = Color(0xFFECEDEE); // hellgrau
    const panelBlau = Color(0xFF355573); // dunkles Blau
    const weiss = Colors.white;

    return Container(
      color: pageBg,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1120),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: panelBlau,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topzeile
                  Row(
                    children: [
                      // Suche
                      Expanded(
                        child: Container(
                          height: topHeight,
                          decoration: BoxDecoration(
                            color: weiss,
                            borderRadius: BorderRadius.circular(topHeight / 2),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(Icons.search, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: sucheCtrl,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Suche bei Name, Telefonnummer oder Datum des letzten Haarschnittes',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter (Kreis)
                      SizedBox(
                        width: topHeight,
                        height: topHeight,
                        child: ClipOval(
                          child: Material(
                            color: weiss.withValues(alpha: 0.2),
                            child: IconButton(
                              tooltip: 'Filter',
                              onPressed: _filterDialog,
                              icon: const Icon(Icons.tune, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Neuer Kunde
                      TextButton.icon(
                        onPressed: () => _dialogHinzufuegenBearbeiten(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF6E61A8),
                          minimumSize: const Size(0, topHeight),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const StadiumBorder(),
                        ),
                        icon: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                        label: const Text('Neuer Kunde'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Weißer Inhalt mit Tabelle
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: weiss,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: KundenTabelle(
                          kunden: verwaltung.kunden,
                          datumFmt: datumFmt,
                          onBearbeiten: (k) =>
                              _dialogHinzufuegenBearbeiten(bearbeiten: k),
                          onLoeschen: (k) => setState(() => verwaltung.loeschen(k.id)),
                          onTermin: _naechstenTerminWaehlen,
                          minLinien: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
