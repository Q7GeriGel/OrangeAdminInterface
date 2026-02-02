import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/notizen_controller.dart';
import '../controllers/terminplan_controller.dart';

/// Notiz-Kachel (rechts großer Block)
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

      // tag ist bei dir DateTime (aber ich mach’s robust)
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
    final terminplan = context.watch<TerminplanController>();
    final notizen = context.watch<NotizenController>();

    final day = _asDate(terminplan.tag);

    if (_c.text != notizen.text) _c.text = notizen.text;

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
                    'Notizen',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('dd.MM.yyyy').format(day),
                    style: TextStyle(color: Colors.black.withAlpha(140)),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final txt = _c.text.trim();

                      await context.read<NotizenController>().speichere(day, txt);

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
// Dashboard: Einträge + Box
// -------------------

class DashboardEntry {
  final String text;
  final Color? accent;
  final VoidCallback? onTap;

  const DashboardEntry(this.text, {this.accent, this.onTap});
}

class DashboardBox extends StatefulWidget {
  final String titel;
  final List<DashboardEntry> eintraege;
  final double maxHeight;
  final IconData? icon;

  const DashboardBox({
    super.key,
    required this.titel,
    required this.eintraege,
    this.maxHeight = 220,
    this.icon,
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
    const orange = Color(0xFFCC5C4C);
    const blue = Color(0xFF335776);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: orange,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(widget.icon ?? Icons.info, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.titel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Body
        Container(
          decoration: BoxDecoration(
            color: blue,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            child: Scrollbar(
              controller: _scrollCtrl, // ✅ wichtig
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(999),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ListView.separated(
                  controller: _scrollCtrl, // ✅ wichtig
                  primary: false, // ✅ wichtig bei nested scrolls
                  itemCount: widget.eintraege.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = widget.eintraege[i];
                    final accent = e.accent ?? orange;
                    final clickable = e.onTap != null;

                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: e.onTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.text,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (clickable)
                                const Icon(Icons.chevron_right, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
