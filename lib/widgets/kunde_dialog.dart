import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/kunde.dart';

class KundeDialog extends StatefulWidget {
  final Kunde? initial;
  final List<String> friseure;

  const KundeDialog({
    super.key,
    required this.initial,
    required this.friseure,
  });

  @override
  State<KundeDialog> createState() => _KundeDialogState();
}

class _KundeDialogState extends State<KundeDialog> {
  static const _orange = Color(0xFFCC5C4C);

  late final TextEditingController nameCtrl;
  late final TextEditingController telCtrl;

  bool stammkunde = false;
  String bevorzugterFriseur = '';
  DateTime? letzterHaarschnitt;
  DateTime? naechsterTermin;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    final i = widget.initial;
    nameCtrl = TextEditingController(text: i?.name ?? '');
    telCtrl = TextEditingController(text: i?.telefonnummer ?? '');

    stammkunde = i?.stammkunde ?? false;
    bevorzugterFriseur = (i?.bevorzugterFriseur.isNotEmpty ?? false)
        ? i!.bevorzugterFriseur
        : (widget.friseure.isNotEmpty ? widget.friseure.first : 'Serkan');

    letzterHaarschnitt = i?.letzterHaarschnitt;
    naechsterTermin = i?.naechsterTermin;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    telCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => DateFormat('dd.MM.yyyy').format(d);

  Future<void> _pickLetzter() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: letzterHaarschnitt ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null) return;
    setState(() => letzterHaarschnitt = picked);
  }

  Future<void> _pickNext() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: naechsterTermin ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null) return;
    setState(() => naechsterTermin = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);

    final name = nameCtrl.text.trim();
    final tel = telCtrl.text.trim();

    if (name.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Bitte Namen eingeben.')));
      return;
    }

    setState(() => saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    setState(() => saving = false);

    final id = widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final kunde = Kunde(
      id: id,
      name: name,
      telefonnummer: tel,
      stammkunde: stammkunde,
      bevorzugterFriseur: bevorzugterFriseur,
      letzterHaarschnitt: letzterHaarschnitt,
      naechsterTermin: naechsterTermin,
    );

    if (!mounted) return;
    Navigator.pop(context, kunde);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Kunden bearbeiten' : 'Neuen Kunden anlegen'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'z.B. Lara Demir',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: telCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefonnummer',
                hintText: 'z.B. +43 699 ...',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Bevorzugter Friseur',
                      prefixIcon: const Icon(Icons.content_cut),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: bevorzugterFriseur,
                        isExpanded: true,
                        items: (widget.friseure.isNotEmpty ? widget.friseure : ['Serkan', 'Aylin', 'Mira', 'Kenan'])
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: saving ? null : (v) => setState(() => bevorzugterFriseur = v ?? bevorzugterFriseur),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withAlpha(30)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Stammkunde', style: TextStyle(fontWeight: FontWeight.w700))),
                        Switch(
                          value: stammkunde,
                          onChanged: saving ? null : (v) => setState(() => stammkunde = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: saving ? null : _pickLetzter,
                    icon: const Icon(Icons.history),
                    label: Text(letzterHaarschnitt == null ? 'Letzter Haarschnitt' : _fmt(letzterHaarschnitt!)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: saving ? null : _pickNext,
                    icon: const Icon(Icons.event),
                    label: Text(naechsterTermin == null ? 'Nächster Termin' : _fmt(naechsterTermin!)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: _orange),
          onPressed: saving ? null : _save,
          icon: saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save),
          label: const Text('Speichern'),
        ),
      ],
    );
  }
}
