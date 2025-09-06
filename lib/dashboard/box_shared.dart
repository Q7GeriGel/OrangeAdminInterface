import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notizen_controller.dart';
import '../controllers/terminplan_controller.dart';

/// Notiz-Kachel (rechter großer Block mit Notizbuch)
class BoxShared extends StatefulWidget {
  const BoxShared({super.key});

  @override
  State<BoxShared> createState() => _BoxSharedState();
}

class _BoxSharedState extends State<BoxShared> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController();

    // Notiz nach dem ersten Frame laden (kein use_build_context_synchronously)
    final notizen = context.read<NotizenController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notizen.lade(DateTime.now());
      if (mounted) setState(() {}); // optional: Textfeld refreshen
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tag = context.watch<TerminplanController>().tag;
    final txt = context.watch<NotizenController>().text;
    if (_c.text != txt) _c.text = txt;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 420,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Schreibe deine Gedanken nieder!!!',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () async {
                      // Alles VOR await capturen → kein BuildContext danach
                      final notizen   = context.read<NotizenController>();
                      final messenger = ScaffoldMessenger.of(context);
                      final tagLocal  = tag;
                      final text      = _c.text.trim();

                      await notizen.speichere(tagLocal, text);

                      messenger.showSnackBar(
                        const SnackBar(content: Text('Notiz gespeichert')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Speichern'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _c,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'Was ist passiert?\nWelche Kunden kamen nicht?\nWas lief gut/schlecht?\nWas soll morgen vorbereitet werden?',
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

// -------------------
// Hilfen für andere Dashboard-Kacheln (Titel + Listeneinträge)
// -------------------

class DashboardEntry {
  final String text;
  const DashboardEntry(this.text);
}

class DashboardBox extends StatelessWidget {
  final String titel;
  final List<DashboardEntry> eintraege;
  final double maxHeight;
  final IconData? icon; // <- NEU: optionales Icon

  const DashboardBox({
    super.key,
    required this.titel,
    required this.eintraege,
    this.maxHeight = 220,
    this.icon, // <- NEU
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kopf (oranger Balken)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFCC5C4C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon ?? Icons.info, color: Colors.white, size: 18), // <- nutzt icon
                const SizedBox(width: 8),
                Text(
                  titel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Inhalt (blauer Kasten mit Liste)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF335776),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  itemCount: eintraege.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      eintraege[i].text,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
