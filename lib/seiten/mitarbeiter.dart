import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../config/staff_config.dart';
import '../widgets/app_page.dart';
import '../widgets/theme/app_tokens.dart';

class MitarbeiterSeite extends StatefulWidget {
  final String benutzername;
  final bool isAdmin;

  const MitarbeiterSeite({
    super.key,
    required this.benutzername,
    required this.isAdmin,
  });

  @override
  State<MitarbeiterSeite> createState() => _MitarbeiterSeiteState();
}

class _MitarbeiterSeiteState extends State<MitarbeiterSeite> {
  final TextEditingController _notesController = TextEditingController();

  final List<String> freieSlots = const [
    '08:00 – 08:30',
    '08:30 – 09:00',
    '09:00 – 09:30',
    '10:00 – 10:30',
    '10:30 – 11:00',
    '11:00 – 11:30',
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
    final txt = prefs.getString(_notesKey) ?? '';
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

  Future<void> _neuenMitarbeiterAnlegen() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CreateEmployeeDialog(),
    );

    if (result == true && mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mitarbeiter erfolgreich angelegt.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const panelBlue = AppColors.bluePanel;

    final innerCard = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final notesFill = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final text = isDark ? Colors.white : Colors.black;
    final sub = isDark ? Colors.white70 : Colors.black54;

    return AppPage(
      title: t.employees,
      child: Column(
        children: [
          _UserHeaderCard(
            benutzername: widget.benutzername,
            subtitle: t.employeesSubtitle,
            trailing: widget.isAdmin
                ? FilledButton.icon(
                    onPressed: _neuenMitarbeiterAnlegen,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Neuer Mitarbeiter'),
                  )
                : null,
          ),
          const SizedBox(height: AppGaps.s18),
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
                            backgroundColor: const Color(0xFFFFB74D),
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

class _CreateEmployeeDialog extends StatefulWidget {
  const _CreateEmployeeDialog();

  @override
  State<_CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<_CreateEmployeeDialog> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final username = _usernameCtrl.text.trim().toLowerCase();
    final password = _passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte Benutzername und Passwort eingeben.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final error = await StaffConfig.createEmployee(
      username: username,
      password: password,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neuen Mitarbeiter anlegen'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameCtrl,
              textInputAction: TextInputAction.next,
              enabled: !_saving,
              decoration: InputDecoration(
                labelText: 'Benutzername',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              enabled: !_saving,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Erstellen'),
        ),
      ],
    );
  }
}

class _UserHeaderCard extends StatelessWidget {
  final String benutzername;
  final String subtitle;
  final Widget? trailing;

  const _UserHeaderCard({
    required this.benutzername,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
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
              backgroundColor: const Color(0xFFFFB74D),
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
            if (trailing != null) ...[
              const SizedBox(width: 14),
              trailing!,
            ],
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
    final border = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

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
                  Icon(titleIcon, color: const Color(0xFFF57C00)),
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
    final bg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final border = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
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
              color: const Color(0xFFFFB74D),
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
              color: (statusIsFree ? AppColors.orange : Colors.black)
                  .withAlpha(isDark ? 28 : 15),
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