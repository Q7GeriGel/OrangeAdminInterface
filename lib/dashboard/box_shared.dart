import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/notizen_controller.dart';
import '../controllers/terminplan_controller.dart';
import '../l10n/gen/app_localizations.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final terminplan = context.read<TerminplanController>();
      final notizen = context.read<NotizenController>();

      final day = _asDate(terminplan.tag);
      await notizen.lade(day);

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  DateTime _asDate(Object? v) {
    if (v is DateTime) return v;

    if (v is String) {
      final iso = DateTime.tryParse(v);
      if (iso != null) return DateTime(iso.year, iso.month, iso.day);

      try {
        final d = DateFormat('dd.MM.yyyy').parseStrict(v);
        return DateTime(d.year, d.month, d.day);
      } catch (_) {}

      try {
        final d = DateFormat('dd.MM').parseStrict(v);
        final now = DateTime.now();
        return DateTime(now.year, d.month, d.day);
      } catch (_) {}
    }

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final terminplan = context.watch<TerminplanController>();
    final notizen = context.watch<NotizenController>();

    final day = _asDate(terminplan.tag);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    if (_c.text != notizen.text) _c.text = notizen.text;

    final dateText = DateFormat('dd.MM.yyyy').format(day);

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
                  Text(t.notesTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(width: 10),
                  Text(
                    dateText,
                    style: TextStyle(color: scheme.onSurface.withAlpha(isDark ? 170 : 140)),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final txt = _c.text.trim();

                      await context.read<NotizenController>().speichere(day, txt);

                      messenger.showSnackBar(SnackBar(content: Text(t.noteSavedSnack)));
                    },
                    icon: const Icon(Icons.save),
                    label: Text(t.save),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _c,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: t.notesDefaultTemplate,
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
// Dashboard-Box-System (Dark/Light kompatibel)
// -------------------

class DashboardUi {
  static const headerOrange = Color(0xFFCC5C4C);

  static const outerRadius = 22.0;
  static const innerRadius = 18.0;
  static const headerRadius = 18.0;

  static const rowHeight = 64.0;
}

class DashboardEntry {
  final String title;
  final String? subtitle;
  final Color? accent;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DashboardEntry(
    this.title, {
    this.subtitle,
    this.accent,
    this.trailing,
    this.onTap,
  });
}

class DashboardPill extends StatelessWidget {
  final String text;
  const DashboardPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(14) : Colors.black.withAlpha(10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: scheme.onSurface.withAlpha(200),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class DashboardBox extends StatefulWidget {
  final String titel;
  final List<DashboardEntry> eintraege;
  final IconData icon;

  final double height;
  final bool loading;
  final String emptyText;

  const DashboardBox({
    super.key,
    required this.titel,
    required this.eintraege,
    required this.icon,
    this.height = 360,
    this.loading = false,
    this.emptyText = 'Keine Einträge',
  });

  @override
  State<DashboardBox> createState() => _DashboardBoxState();
}

class _DashboardBoxState extends State<DashboardBox> {
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final panel = isDark ? const Color(0xFF111821) : const Color(0xFF355573);
    final inner = isDark ? const Color(0xFF141D27) : Colors.white;

    final border = isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(18);
    final tileBorder = isDark ? Colors.white.withAlpha(14) : const Color(0xFFE9E9E9);

    return SizedBox(
      height: widget.height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(DashboardUi.outerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 0 : 10),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: DashboardUi.headerOrange,
                  borderRadius: BorderRadius.circular(DashboardUi.headerRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(widget.icon, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.titel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.loading) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(minHeight: 4),
                ),
              ],

              const SizedBox(height: 12),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DashboardUi.innerRadius),
                  child: Container(
                    color: inner,
                    padding: const EdgeInsets.all(10),
                    child: _buildBody(
                      isDark: isDark,
                      scheme: scheme,
                      tileBorder: tileBorder,
                      border: border,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required bool isDark,
    required ColorScheme scheme,
    required Color tileBorder,
    required Color border,
  }) {
    if (widget.loading && widget.eintraege.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.eintraege.isEmpty) {
      return _EmptyLine(text: widget.emptyText, border: border);
    }

    final list = ScrollConfiguration(
      behavior: const _NoGlowScrollBehavior(),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ListView.separated(
          controller: _scrollCtrl,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.eintraege.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _EntryTile(e: widget.eintraege[i], tileBorder: tileBorder),
        ),
      ),
    );

    if (kIsWeb) return list;

    return Scrollbar(
      controller: _scrollCtrl,
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(999),
      child: list,
    );
  }
}

class _EntryTile extends StatelessWidget {
  final DashboardEntry e;
  final Color tileBorder;
  const _EntryTile({required this.e, required this.tileBorder});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accent = e.accent ?? DashboardUi.headerOrange;
    final clickable = e.onTap != null;
    final subtitle = (e.subtitle ?? '').trim();

    final tileBg = isDark ? const Color(0xFF141D27) : Colors.white;

    return Material(
      color: tileBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: e.onTap,
        mouseCursor: clickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        splashColor: Colors.black.withAlpha(10),
        hoverColor: Colors.black.withAlpha(6),
        child: Container(
          height: DashboardUi.rowHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tileBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 26,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w900, color: scheme.onSurface),
                    ),
                    if (subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: scheme.onSurface.withAlpha(170),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (e.trailing != null) ...[
                const SizedBox(width: 10),
                e.trailing!,
              ] else if (clickable) ...[
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: scheme.onSurface.withAlpha(160)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  final String text;
  final Color border;
  const _EmptyLine({required this.text, required this.border});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final tileBg = isDark ? const Color(0xFF141D27) : Colors.white;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: DashboardUi.headerOrange,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w900, color: scheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
