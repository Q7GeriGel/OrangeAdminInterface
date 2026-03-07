import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzername;

  const MitarbeiterSeite({
    super.key,
    required this.benutzername,
  });

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  final TextEditingController _notesController = TextEditingController();

  final List<String> freieSlots = const [
    "08:00 – 08:30",
    "08:30 – 09:00",
    "09:00 – 09:30",
    "10:00 – 10:30",
    "10:30 – 11:00",
    "11:00 – 11:30"
  ];

  String get _notesKey => 'notes_${widget.benutzername.toLowerCase()}';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void didUpdateWidget(covariant MitarbeiterSeite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.benutzername != widget.benutzername) {
      _loadNotes();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final txt = prefs.getString(_notesKey) ?? "";
    if (!mounted) return;

    final t = AppLocalizations.of(context)!;

    setState(() {
      _notesController.text = txt.isEmpty ? t.notesDefaultTemplate : txt;
    });
  }

  Future<void> _saveNotes() async {
    final t = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, _notesController.text.trim());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.notesSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const panelBlue = AppColors.bluePanel;

    final innerCard = isDark ? const Color(0xFF111821) : Colors.white;
    final notesFill = isDark ? const Color(0xFF141D27) : const Color(0xFFF6F6F6);
    final text = isDark ? Colors.white : Colors.black;
    final sub = isDark ? Colors.white70 : Colors.black54;

    return AppPage(
      title: t.employees,
      child: Column(
        children: [
          _UserHeaderCard(
            benutzername: widget.benutzername,
            subtitle: t.employeesSubtitle,
          ),
          const SizedBox(height: AppGaps.s18),

          // ✅ HESAP / ACCOUNT PANEL KOMPLETT ENTFERNT

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.r22),
              child: Container(
                color: panelBlue,
                padding: const EdgeInsets.all(AppGaps.s18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _InnerPanel(
                        background: innerCard,
                        title: t.freeSlotsToday,
                        titleIcon: Icons.timer_outlined,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: freieSlots.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _SlotTile(
                                time: freieSlots[i],
                                freeText: t.free,
                                bookedText: t.booked,
                                statusIsFree: true,
                                isDark: isDark,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppGaps.s18),
                    Expanded(
                      child: _InnerPanel(
                        background: innerCard,
                        title: t.notesTitle,
                        titleIcon: Icons.note_alt_outlined,
                        topRight: ElevatedButton.icon(
                          onPressed: _saveNotes,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(t.save),
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
                            style: TextStyle(color: text),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: notesFill,
                              hintText: t.notesHint,
                              hintStyle: TextStyle(color: sub),
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
  final String subtitle;

  const _UserHeaderCard({
    required this.benutzername,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF111821) : Colors.white;
    final title = isDark ? Colors.white : Colors.black;
    final sub = isDark ? Colors.white70 : Colors.black54;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r22),
      child: Container(
        color: cardBg,
        padding: const EdgeInsets.all(AppGaps.s18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFFFE0D7),
              child: Icon(Icons.person, color: Colors.black.withAlpha(160)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benutzername,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: title,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: sub,
                    ),
                  ),
                ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? Colors.white.withAlpha(16) : Colors.black.withAlpha(10);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.r18),
      child: Container(
        color: background,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  Icon(titleIcon, color: const Color(0xFFC95B4C)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                  if (topRight != null) topRight!,
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String time;
  final String freeText;
  final String bookedText;
  final bool statusIsFree;
  final bool isDark;

  const _SlotTile({
    required this.time,
    required this.freeText,
    required this.bookedText,
    required this.statusIsFree,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF141D27) : const Color(0xFFF5F6F8);
    final border = isDark ? Colors.white.withAlpha(14) : Colors.black.withAlpha(10);
    final text = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF335776),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              time,
              style: TextStyle(fontWeight: FontWeight.w900, color: text),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (statusIsFree ? AppColors.orange : Colors.black).withAlpha(isDark ? 28 : 15),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              statusIsFree ? freeText : bookedText,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}