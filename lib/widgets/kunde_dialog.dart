import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kunde.dart';

class KundeDialog extends StatefulWidget {
  final Kunde? initial;
  final List<String> friseure;

  const KundeDialog({super.key, required this.initial, required this.friseure});

  @override
  State<KundeDialog> createState() => _KundeDialogState();
}

class _KundeDialogState extends State<KundeDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController telCtrl;
  late TextEditingController letzterCtrl;
  late TextEditingController naechsterCtrl;
  bool stamm = false;
  String friseur = '';

  final datum = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    nameCtrl = TextEditingController(text: i?.name ?? '');
    telCtrl = TextEditingController(text: i?.telefonnummer ?? '');
    stamm = i?.stammkunde ?? false;
    friseur = i?.bevorzugterFriseur ?? '';
    letzterCtrl = TextEditingController(
        text: i?.letzterHaarschnitt == null ? '' : datum.format(i!.letzterHaarschnitt!));
    naechsterCtrl = TextEditingController(
        text: i?.naechsterTermin == null ? '' : datum.format(i!.naechsterTermin!));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    telCtrl.dispose();
    letzterCtrl.dispose();
    naechsterCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick(TextEditingController target, DateTime? initial) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      target.text = datum.format(picked);
    }
  }

  DateTime? _parse(String s) {
    if (s.trim().isEmpty) return null;
    try {
      return datum.parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final istBearbeiten = widget.initial != null;
    return AlertDialog(
      title: Text(istBearbeiten ? 'Kunde bearbeiten' : 'Neuen Kunden anlegen'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(
              controller: telCtrl,
              decoration: const InputDecoration(labelText: 'Telefonnummer'),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Checkbox(value: stamm, onChanged: (v) => setState(() => stamm = v ?? false)),
              const Text('Stammkunde'),
            ]),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: friseur.isEmpty ? null : friseur,
              items: widget.friseure
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => friseur = v ?? ''),
              decoration: const InputDecoration(labelText: 'Bevorzugter Friseur'),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: letzterCtrl,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Letzter Haarschnitt (dd.MM.yyyy)'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _pick(letzterCtrl, _parse(letzterCtrl.text)),
                icon: const Icon(Icons.event),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: naechsterCtrl,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Nächster Termin (dd.MM.yyyy)'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _pick(naechsterCtrl, _parse(naechsterCtrl.text)),
                icon: const Icon(Icons.event_available),
              ),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
        FilledButton(
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty) return;
            final k = Kunde(
              id: widget.initial?.id ??
                  DateTime.now().microsecondsSinceEpoch.toString(),
              name: nameCtrl.text.trim(),
              telefonnummer: telCtrl.text.trim(),
              stammkunde: stamm,
              bevorzugterFriseur: friseur,
              letzterHaarschnitt: _parse(letzterCtrl.text),
              naechsterTermin: _parse(naechsterCtrl.text),
            );
            Navigator.pop(context, k);
          },
          child: Text(istBearbeiten ? 'Speichern' : 'Anlegen'),
        ),
      ],
    );
  }
}
