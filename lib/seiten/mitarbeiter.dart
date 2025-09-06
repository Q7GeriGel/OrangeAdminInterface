import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/anmeldung_controller.dart';
import '../controllers/terminplan_controller.dart';
import '../controllers/notizen_controller.dart';

import '../dashboard/box_freie_zeitfenster.dart';
import '../dashboard/box_shared.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzernameFallback;
  const MitarbeiterSeite({super.key, required this.benutzernameFallback});

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  @override
void initState() {
  super.initState();
  final terminplan = context.read<TerminplanController>();
  final notizen    = context.read<NotizenController>();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await terminplan.aktualisiere(DateTime.now());
    await notizen.lade(DateTime.now());
  });
}


  @override
  Widget build(BuildContext context) {
    final nameProvider = context.watch<AnmeldungController>().anzeigeName;
    final name = (nameProvider.isNotEmpty)
        ? nameProvider
        : widget.benutzernameFallback;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 54, child: Icon(Icons.person, size: 64)),
              const SizedBox(width: 16),
              Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          const BoxFreieZeitfenster(),
          const SizedBox(height: 16),
          const BoxShared(),
        ],
      ),
    );
  }
}
