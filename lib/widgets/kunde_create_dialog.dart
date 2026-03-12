import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/kunden_verwaltung.dart';
import '../models/kunde.dart';
import '../config/staff_config.dart';
import '../l10n/gen/app_localizations.dart';

class KundeCreateResult {
  final String name;
  final String? telefon;
  final bool stammkunde;
  final String bevorzugterFriseur;

  const KundeCreateResult({
    required this.name,
    this.telefon,
    required this.stammkunde,
    required this.bevorzugterFriseur,
  });
}

Future<KundeCreateResult?> showCreateKundeDialog({
  required BuildContext context,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  final nameCtrl = TextEditingController();
  final telCtrl = TextEditingController();

  bool saving = false;
  bool stamm = false;
  final mitarbeiter = StaffConfig.allEmployees;
  String friseur = mitarbeiter.first;

  try {
    final res = await showDialog<KundeCreateResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setState) {
            Future<void> save() async {
              final name = nameCtrl.text.trim();
              final tel = telCtrl.text.trim();

              if (name.isEmpty) {
                messenger.showSnackBar(SnackBar(content: Text(t.customerRequired)));
                return;
              }

              setState(() => saving = true);
              await Future<void>.delayed(const Duration(milliseconds: 120));
              if (!dialogCtx.mounted) return;
              setState(() => saving = false);

              Navigator.pop(
                dialogCtx,
                KundeCreateResult(
                  name: name,
                  telefon: tel.isEmpty ? null : tel,
                  stammkunde: stamm,
                  bevorzugterFriseur: friseur,
                ),
              );
            }

            return AlertDialog(
              title: Text(t.newCustomer),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: t.customerName,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: telCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: t.phoneOptional,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: friseur,
                      items: mitarbeiter
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => friseur = v ?? friseur),
                      decoration: InputDecoration(
                        labelText: t.preferredEmployee,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: stamm,
                      onChanged: (v) => setState(() => stamm = v),
                      title: Text(t.regularCustomer),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.pop(dialogCtx),
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  onPressed: saving ? null : save,
                  child: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(t.save),
                ),
              ],
            );
          },
        );
      },
    );

    return res;
  } finally {
    nameCtrl.dispose();
    telCtrl.dispose();
  }
}

Future<void> openCreateKundeFlow({
  required BuildContext context,
}) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);

  final res = await showCreateKundeDialog(context: context);
  if (res == null) return;
  if (!context.mounted) return;

  try {
    final verwaltung = context.read<KundenVerwaltung>();

    final kunde = Kunde(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: res.name,
      telefonnummer: res.telefon ?? '',
      stammkunde: res.stammkunde,
      bevorzugterFriseur: res.bevorzugterFriseur,
    );

    await verwaltung.hinzufuegen(kunde);
    if (!context.mounted) return;

    messenger.showSnackBar(
      SnackBar(content: Text('${res.name} ${t.saved}')),
    );
  } catch (e) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Kunden-Provider fehlt. In main.dart ChangeNotifierProvider<KundenVerwaltung> hinzufügen.',
        ),
      ),
    );
  }
}