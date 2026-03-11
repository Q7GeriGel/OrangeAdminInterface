import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../controllers/kunden_verwaltung.dart';
import '../models/kunde.dart';
import '../config/staff_config.dart';
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
      context.read<KundenVerwaltung>().sucheSetzen(sucheCtrl.text);
    });
  }

  @override
  void dispose() {
    sucheCtrl.dispose();
    super.dispose();
  }

  Future<Kunde?> _openKundeDialog({
    required List<String> friseure,
    Kunde? initial,
  }) {
    return showDialog<Kunde>(
      context: context,
      barrierDismissible: false,
      builder: (_) => KundeDialog(
        initial: initial,
        friseure: friseure,
      ),
    );
  }

  Future<void> _filterDialog(KundenVerwaltung verwaltung) async {
    final t = AppLocalizations.of(context)!;

    bool? nurStamm = verwaltung.nurStammkunden;
    String? friseur = verwaltung.friseur;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: Text(t.filterTitle),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            t.filterRegularLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<bool?>(
                            value: nurStamm,
                            items: [
                              DropdownMenuItem(value: null, child: Text(t.filterAny)),
                              DropdownMenuItem(value: true, child: Text(t.filterOnlyRegulars)),
                              DropdownMenuItem(value: false, child: Text(t.filterOnlyNonRegulars)),
                            ],
                            onChanged: (v) => setLocal(() => nurStamm = v),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            t.filterEmployeeLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            value: friseur,
                            items: [
                              DropdownMenuItem(value: null, child: Text(t.filterAny)),
                              ...StaffConfig.allEmployees.map(
                                (s) => DropdownMenuItem(value: s, child: Text(s)),
                              ),
                            ],
                            onChanged: (v) => setLocal(() => friseur = v),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(t.cancel),
                ),
                TextButton(
                  onPressed: () {
                    setLocal(() {
                      nurStamm = null;
                      friseur = null;
                    });
                  },
                  child: Text(t.reset),
                ),
                FilledButton(
                  onPressed: () {
                    verwaltung.filterSetzen(nurStammkunden: nurStamm, friseur: friseur);
                    Navigator.pop(ctx);
                  },
                  child: Text(t.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmDelete(Kunde k) async {
    final t = AppLocalizations.of(context)!;

    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.confirmDeleteTitle),
        content: Text(t.confirmDeleteCustomerText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    return res ?? false;
  }

  Future<void> _bearbeiten(KundenVerwaltung v, Kunde k) async {
    final edited = await _openKundeDialog(
      friseure: StaffConfig.allEmployees,
      initial: k,
    );
    if (edited == null) return;
    await v.bearbeiten(edited);
  }

  Future<void> _neu(KundenVerwaltung v) async {
    final neu = await _openKundeDialog(
      friseure: StaffConfig.allEmployees,
    );
    if (neu == null) return;
    await v.hinzufuegen(neu);
  }

  Future<void> _loeschen(KundenVerwaltung v, Kunde k) async {
    final ok = await _confirmDelete(k);
    if (!ok) return;
    await v.loeschen(k.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.deletedCustomer)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final verwaltung = context.watch<KundenVerwaltung>();

    final kunden = verwaltung.kunden;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = Theme.of(context).scaffoldBackgroundColor;
    final panel = isDark ? const Color(0xFF111821) : const Color(0xFF355573);
    final surface = isDark ? const Color(0xFF141D27) : Colors.white;

    return Scaffold(
      backgroundColor: pageBg,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
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
                    color: surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.customersTitle,
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                                ),
                              ),
                              SizedBox(
                                height: topHeight,
                                width: 420,
                                child: TextField(
                                  controller: sucheCtrl,
                                  decoration: InputDecoration(
                                    hintText: t.searchHintCustomers,
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: topHeight,
                                child: OutlinedButton.icon(
                                  onPressed: () => _filterDialog(verwaltung),
                                  icon: const Icon(Icons.filter_alt_outlined),
                                  label: Text(t.filterTitle),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: topHeight,
                                child: FilledButton.icon(
                                  onPressed: () => _neu(verwaltung),
                                  icon: const Icon(Icons.add),
                                  label: Text(t.newCustomer),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: KundenTabelle(
                              kunden: kunden,
                              datumFmt: datumFmt,
                              onBearbeiten: (k) => _bearbeiten(verwaltung, k),
                              onLoeschen: (k) => _loeschen(verwaltung, k),
                              onTermin: (k) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${t.pickNextAppointment}: ${k.name}')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}