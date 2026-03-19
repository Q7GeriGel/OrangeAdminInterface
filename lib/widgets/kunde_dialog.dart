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
  static const _orange = Color(0xFFF57C00);

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
      messenger.showSnackBar(
        const SnackBar(content: Text('Bitte Namen eingeben.')),
      );
      return;
    }

    setState(() => saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => saving = false);

    final id = widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    Navigator.pop(
      context,
      Kunde(
        id: id,
        name: name,
        telefonnummer: tel,
        stammkunde: stammkunde,
        bevorzugterFriseur: bevorzugterFriseur,
        letzterHaarschnitt: letzterHaarschnitt,
        naechsterTermin: naechsterTermin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friseurItems =
        widget.friseure.isNotEmpty ? widget.friseure : const ['Serkan'];

    if (!friseurItems.contains(bevorzugterFriseur)) {
      bevorzugterFriseur = friseurItems.first;
    }

    return AlertDialog(
      title: Text(widget.initial == null ? 'Neuer Kunde' : 'Kunde bearbeiten'),
      content: SizedBox(
        width: 760,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              enabled: !saving,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telCtrl,
              enabled: !saving,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefonnummer',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withAlpha(30)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: bevorzugterFriseur,
                        isExpanded: true,
                        items: friseurItems
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                  () => bevorzugterFriseur = v ?? bevorzugterFriseur,
                                ),
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
                        const Expanded(
                          child: Text(
                            'Stammkunde',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Switch(
                          value: stammkunde,
                          onChanged: saving
                              ? null
                              : (v) => setState(() => stammkunde = v),
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
                    label: Text(
                      letzterHaarschnitt == null
                          ? 'Letzter Haarschnitt'
                          : _fmt(letzterHaarschnitt!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: saving ? null : _pickNext,
                    icon: const Icon(Icons.event),
                    label: Text(
                      naechsterTermin == null
                          ? 'Nächster Termin'
                          : _fmt(naechsterTermin!),
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
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: _orange),
          onPressed: saving ? null : _save,
          icon: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: const Text('Speichern'),
        ),
      ],
    );
  }
}