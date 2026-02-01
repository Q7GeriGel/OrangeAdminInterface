import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/anmeldung_controller.dart';
import '../controllers/terminplan_controller.dart';
import '../controllers/notizen_controller.dart';

import '../dashboard/box_freie_zeitfenster.dart';
import '../dashboard/box_shared.dart';
import 'auth_gate.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzernameFallback;
  const MitarbeiterSeite({super.key, required this.benutzernameFallback});

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  static const _pageBg = Color(0xFFF4F4F4);

  @override
  void initState() {
    super.initState();
    final terminplan = context.read<TerminplanController>();
    final notizen = context.read<NotizenController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await terminplan.aktualisiere(DateTime.now());
      await notizen.lade(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = context.watch<AnmeldungController>().anzeigeName;
    final name =
        (nameProvider.isNotEmpty) ? nameProvider : widget.benutzernameFallback;

    return Container(
      color: _pageBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withAlpha(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 42,
                    child: Icon(Icons.person, size: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const AuthGate()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Logout'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // deine Boxen bleiben 1:1 funktional
            const BoxFreieZeitfenster(),
            const SizedBox(height: 16),
            const BoxShared(),
          ],
        ),
      ),
    );
  }
}
