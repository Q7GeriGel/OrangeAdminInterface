import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/terminplan_controller.dart';
import '../../models/termin.dart';

class DashboardPanels extends StatelessWidget {
  const DashboardPanels({super.key});

  static const double _gap = 18;
  static const double _panelHeight = 320;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TerminplanController>();

    final kommende = controller.kommendeHeute(limit: 50);
    final aenderungen = controller.aenderungen;
    final freie = controller.freie;

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        // 1/2/3 Spalten je nach Breite
        final cols = w >= 1100 ? 3 : (w >= 780 ? 2 : 1);
        final itemWidth = (w - _gap * (cols - 1)) / cols;

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            SizedBox(
              width: itemWidth,
              height: _panelHeight,
              child: _Panel(
                title: 'Bevorstehende Kunden',
                icon: Icons.person,
                child: _ScrollableList(
                  emptyText: 'Keine Termine mehr heute',
                  itemCount: kommende.length,
                  itemBuilder: (context, i) {
                    final t = kommende[i];
                    final time = DateFormat('HH:mm').format(t.start);
                    return _RowCard(
                      leadingColor: _colorForStatus(t.status),
                      title: t.kundeName,
                      subtitle: '${t.mitarbeiterName} • $time',
                      rightChip: _StatusChip(status: t.status),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              height: _panelHeight,
              child: _Panel(
                title: 'Aktuelle Änderungen',
                icon: Icons.refresh,
                child: _ScrollableList(
                  emptyText: 'Noch keine Änderungen',
                  itemCount: aenderungen.length,
                  itemBuilder: (context, i) {
                    final text = aenderungen[i];
                    return _RowCard(
                      leadingColor: const Color(0xFFC95D4B),
                      title: text,
                      subtitle: '',
                      rightChip: null,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              height: _panelHeight,
              child: _Panel(
                title: 'Freie Zeitfenster heute',
                icon: Icons.timer_outlined,
                child: _ScrollableList(
                  emptyText: 'Heute keine freien Slots',
                  itemCount: freie.length,
                  itemBuilder: (context, i) {
                    final f = freie[i];
                    final label =
                        '${DateFormat('HH:mm').format(f.start)} – ${DateFormat('HH:mm').format(f.end)}';
                    return _RowCard(
                      leadingColor: const Color(0xFF355573),
                      title: label,
                      subtitle: '',
                      rightChip: const _SmallPill(text: 'frei'),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _colorForStatus(String status) {
    if (status == Termin.statusBestaetigt) return const Color(0xFF2E7D32);
    if (status == Termin.statusAbgesagt) return const Color(0xFFC62828);
    return const Color(0xFF355573);
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Panel({
    required this.title,
    required this.icon,
    required this.child,
  });

  static const Color _panelBlue = Color(0xFF355573);
  static const Color _headerOrange = Color(0xFFC95D4B);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _panelBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Header
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: _headerOrange,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Inner white card (scrollable content)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(10),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollableList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String emptyText;

  const _ScrollableList({
    required this.itemCount,
    required this.itemBuilder,
    required this.emptyText,
  });

  @override
  State<_ScrollableList> createState() => _ScrollableListState();
}

class _ScrollableListState extends State<_ScrollableList> {
  final ScrollController _ctrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return _EmptyLine(text: widget.emptyText);
    }

    return Scrollbar(
      controller: _ctrl,
      thumbVisibility: true, // ✅ damit man "Scrollwheel/Scrollbar" auch sieht
      child: ListView.separated(
        controller: _ctrl,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: widget.itemBuilder,
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  final String text;
  const _EmptyLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFC95D4B),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final Color leadingColor;
  final String title;
  final String subtitle;
  final Widget? rightChip;

  const _RowCard({
    required this.leadingColor,
    required this.title,
    required this.subtitle,
    required this.rightChip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 26,
            decoration: BoxDecoration(
              color: leadingColor,
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
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (subtitle.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (rightChip != null) rightChip!,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    if (status == Termin.statusBestaetigt) {
      bg = const Color(0xFFE6F4EA);
      fg = const Color(0xFF1B5E20);
    } else if (status == Termin.statusAbgesagt) {
      bg = const Color(0xFFFCE8E6);
      fg = const Color(0xFFB71C1C);
    } else {
      bg = const Color(0xFFEAF1FF);
      fg = const Color(0xFF1E3A8A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  final String text;
  const _SmallPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.55),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}
