import 'package:flutter/material.dart';

class KundeCreateResult {
  final String name;
  final String? telefon;
  final String? email;
  final String? notiz;

  const KundeCreateResult({
    required this.name,
    this.telefon,
    this.email,
    this.notiz,
  });
}

Future<KundeCreateResult?> showCreateKundeDialog({
  required BuildContext context,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  final nameCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool saving = false;

  bool isValidEmail(String s) {
    if (s.trim().isEmpty) return true; // optional
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(s.trim());
  }

  return showDialog<KundeCreateResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (dialogCtx, setState) {
          Future<void> save() async {
            final name = nameCtrl.text.trim();
            final tel = telCtrl.text.trim();
            final email = emailCtrl.text.trim();
            final note = noteCtrl.text.trim();

            if (name.isEmpty) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Bitte Namen eingeben.')),
              );
              return;
            }

            if (!isValidEmail(email)) {
              messenger.showSnackBar(
                const SnackBar(content: Text('E-Mail Format passt nicht.')),
              );
              return;
            }

            setState(() => saving = true);

            // kein await nötig (nur UI) – aber wir halten das Muster konsistent
            await Future<void>.delayed(const Duration(milliseconds: 120));

            setState(() => saving = false);

            Navigator.pop(
              dialogCtx,
              KundeCreateResult(
                name: name,
                telefon: tel.isEmpty ? null : tel,
                email: email.isEmpty ? null : email,
                notiz: note.isEmpty ? null : note,
              ),
            );
          }

          return AlertDialog(
            title: const Text('Neuen Kunden anlegen'),
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

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: telCtrl,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Telefon (optional)',
                            hintText: 'z.B. 0664 1234567',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'E-Mail (optional)',
                            hintText: 'z.B. lara@mail.at',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notiz (optional)',
                      hintText: 'z.B. Allergie, bevorzugter Mitarbeiter, etc.',
                      prefixIcon: const Icon(Icons.notes),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.pop(dialogCtx),
                child: const Text('Abbrechen'),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFCC5C4C)),
                onPressed: saving ? null : save,
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
        },
      );
    },
  );
}

/// Flow-Funktion (wie beim Termin): Dialog öffnen + Feedback.
/// (Speichern in Liste/Controller hängen wir danach an.)
Future<void> openCreateKundeFlow({
  required BuildContext context,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  final res = await showCreateKundeDialog(context: context);
  if (res == null) return;

  messenger.showSnackBar(
    SnackBar(content: Text('Kunde erstellt: ${res.name}')),
  );
}
