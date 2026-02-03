import 'package:flutter/material.dart';
import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzername;

  const MitarbeiterSeite({super.key, required this.benutzername});

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  final TextEditingController _notesController = TextEditingController(
    text:
        "Was ist passiert?\nWelche Kunden kamen nicht?\nWas lief gut/schlecht?\nWas soll morgen vorbereitet werden?",
  );

  // TODO: später aus Provider/Repository ziehen
  final List<String> freieSlots = const [
    "08:00 – 08:30",
    "08:30 – 09:00",
    "09:00 – 09:30",
    "10:00 – 10:30",
    "10:30 – 11:00",
    "11:00 – 11:30",
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveNotes() {
    // TODO: später speichern (Provider/DB)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notizen gespeichert (Mock)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Blaues Panel (bleibt wie bei dir)
    const panelBlue = AppColors.bluePanel;

    // Innenkarten: du wolltest “Rest kann bleiben”
    final innerCard = Colors.white;

    // Notizen-Feld: in Darkmode darf das NICHT blendend sein
    final notesFill = isDark ? const Color(0xFF151A21) : const Color(0xFFF6F6F6);
    final notesText = isDark ? Colors.white : Colors.black;
    final notesHint = isDark ? Colors.white70 : Colors.black54;

    return AppPage(
      title: "Mitarbeiter",
      child: Column(
        children: [
          _UserHeaderCard(
            benutzername: widget.benutzername,
            onLogout: () {
              // TODO: dein Logout hier
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout (Mock)")),
              );
            },
          ),
          const SizedBox(height: AppGaps.s18),

          // FIX gegen Overflow: Expanded + innen scrollen
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.r22),
              child: Container(
                color: panelBlue,
                padding: const EdgeInsets.all(AppGaps.s18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LINKS: Freie Zeitfenster
                    Expanded(
                      child: _InnerPanel(
                        background: innerCard,
                        title: "Freie Zeitfenster heute",
                        titleIcon: Icons.timer_outlined,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: freieSlots.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _SlotTile(
                                time: freieSlots[i],
                                statusText: "frei",
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: AppGaps.s18),

                    // RECHTS: Notizen
                    Expanded(
                      child: _InnerPanel(
                        background: innerCard,
                        title: "Notizen",
                        titleIcon: Icons.note_alt_outlined,
                        topRight: ElevatedButton.icon(
                          onPressed: _saveNotes,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text("Speichern"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB5A7),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadii.pill),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _notesController,
                            expands: true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyle(color: notesText),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: notesFill,
                              hintText: "Notizen…",
                              hintStyle: TextStyle(color: notesHint),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserHeaderCard extends StatelessWidget {
  final String benutzername;
  final VoidCallback onLogout;

  const _UserHeaderCard({
    required this.benutzername,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Colors.white;
    final subtitleColor = isDark ? Colors.black54 : Colors.black54;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r22),
      child: Container(
        color: cardBg,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.orangeSoft,
              child: const Icon(Icons.person, color: AppColors.orange),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benutzername,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Intern • Team-Übersicht & Notizen",
                    style: TextStyle(color: subtitleColor),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.orange,
                side: const BorderSide(color: AppColors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerPanel extends StatelessWidget {
  final Color background;
  final String title;
  final IconData titleIcon;
  final Widget child;
  final Widget? topRight;

  const _InnerPanel({
    required this.background,
    required this.title,
    required this.titleIcon,
    required this.child,
    this.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r18),
      child: Container(
        color: background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Icon(titleIcon, color: AppColors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (topRight != null) topRight!,
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String time;
  final String statusText;

  const _SlotTile({required this.time, required this.statusText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.bluePanel,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(15, 0, 0, 0),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              statusText,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
