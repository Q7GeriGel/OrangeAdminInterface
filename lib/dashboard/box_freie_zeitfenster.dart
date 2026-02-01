import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/terminplan_controller.dart';

class BoxFreieZeitfenster extends StatefulWidget {
  const BoxFreieZeitfenster({super.key});

  @override
  State<BoxFreieZeitfenster> createState() => _BoxFreieZeitfensterState();
}

class _BoxFreieZeitfensterState extends State<BoxFreieZeitfenster> {
  static const _orange = Color(0xFFCC5C4C);
  static const _blue = Color(0xFF335776);

  @override
  void initState() {
    super.initState();
    final terminplan = context.read<TerminplanController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      terminplan.aktualisiere(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TerminplanController>();

    return Container(
      // OUTER CARD: sorgt dafür, dass Header + Body exakt gleich breit sind
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: _orange,
            child: const Row(
              children: [
                Icon(Icons.timer, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Freie Zeitfenster heute',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          if (p.lade) const LinearProgressIndicator(),

          // Body (blau) – immer sichtbar und sauber
          Container(
            width: double.infinity,
            color: _blue,
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(999),
                child: Padding(
                  // Platz rechts, damit Scrollbar nix “übermalt”
                  padding: const EdgeInsets.only(right: 10),
                  child: ListView.separated(
                    itemCount: p.freie.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black.withAlpha(25)),
                      ),
                      child: Text(
                        p.freie[i].beschriftung,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
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
