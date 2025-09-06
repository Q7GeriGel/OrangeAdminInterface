import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/terminplan_controller.dart';

class BoxFreieZeitfenster extends StatefulWidget {
  const BoxFreieZeitfenster({super.key});

  @override
  State<BoxFreieZeitfenster> createState() => _BoxFreieZeitfensterState();
}

class _BoxFreieZeitfensterState extends State<BoxFreieZeitfenster> {
 @override
void initState() {
  super.initState();
  // Controller *jetzt* holen (kein async gap)
  final terminplan = context.read<TerminplanController>();

  // Erst nach dem ersten Frame ausführen
  WidgetsBinding.instance.addPostFrameCallback((_) {
    terminplan.aktualisiere(DateTime.now());
  });
}

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TerminplanController>();

    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFCC5C4C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.timer, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Freie Zeitfenster heute',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (p.lade) const LinearProgressIndicator(),
          if (!p.lade)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF335776),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    itemCount: p.freie.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, i) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        p.freie[i].beschriftung,
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
