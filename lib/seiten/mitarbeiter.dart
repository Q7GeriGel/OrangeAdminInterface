import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';
import '../widgets/account_panel.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzername;

  // ✅ für Sedat
  final bool isAdmin;
  final String aktiverAccount;
  final ValueChanged<String> onAccountChanged;

  const MitarbeiterSeite({
    super.key,
    required this.benutzername,
    required this.isAdmin,
    required this.aktiverAccount,
    required this.onAccountChanged,
  });

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  final TextEditingController _notesController = TextEditingController();

  // ✅ Mock-DATEN ok (aber echte Funktion):
  final List<String> freieSlots = const [
    "08:00 – 08:30",
    "08:30 – 09:00",
    "09:00 – 09:30",
    "10:00 – 10:30",
    "10:30 – 11:00",
    "11:00 – 11:30",
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

    setState(() {
      _notesController.text = txt.isEmpty
          ? "Was ist passiert?\nWelche Kunden kamen nicht?\nWas lief gut/schlecht?\nWas soll morgen vorbereitet werden?"
          : txt;
    });
  }

  Future<void> _saveNotes() async {
    final t = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, _notesController.text.trim());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.saved)),
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

          // ✅ HIER die Hesap Box (nur Admin)
          AccountPanel(
            isAdmin: widget.isAdmin,
            selected: widget.aktiverAccount,
            onChanged: widget.onAccountChanged,
          ),

          if (widget.isAdmin) const SizedBox(height: AppGaps.s18),

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
                                statusText: t.booked, // kannst du später anpassen
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
                              hintText: t.notesTitle,
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: title,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: sub)),
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
    final divider = isDark ? Colors.white.withAlpha(18) : Colors.black12;
    final titleColor = isDark ? Colors.white : Colors.black;

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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                  ),
                  if (topRight != null) topRight!,
                ],
              ),
            ),
            Divider(height: 1, color: divider),
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
  final bool statusIsFree;
  final bool isDark;

  const _SlotTile({
    required this.time,
    required this.statusText,
    required this.statusIsFree,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark ? Colors.white.withAlpha(20) : Colors.black12;
    final text = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
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
              style: TextStyle(fontWeight: FontWeight.w800, color: text),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (statusIsFree ? AppColors.orange : Colors.black).withAlpha(isDark ? 28 : 15),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              statusIsFree ? "frei" : statusText,
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
