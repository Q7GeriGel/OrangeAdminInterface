import 'package:flutter/material.dart';

import '../dashboard/box_bevorstehende_kunden.dart';
import '../dashboard/box_aktuelle_aenderung.dart';
import '../dashboard/box_freie_zeitfenster.dart';

class DashboardPage extends StatelessWidget {
  final String benutzername;

  const DashboardPage({super.key, required this.benutzername});

  static const _bg = Color(0xFFF4F4F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WelcomeHeader(benutzername: benutzername),
                  const SizedBox(height: 6),
                  Text(
                    "Hier ist dein Tagesplan:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 26),

                  LayoutBuilder(
                    builder: (context, c) {
                      final isNarrow = c.maxWidth < 900;

                      if (isNarrow) {
                        return Column(
                          children: const [
                            BevorstehendeKundenBox(),
                            SizedBox(height: 18),
                            AktuelleAenderungenBox(),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(child: BevorstehendeKundenBox()),
                          SizedBox(width: 22),
                          Expanded(child: AktuelleAenderungenBox()),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 26),

                  // Freie Zeitfenster: gleiche “Card Breite” und sauber zentriert
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: const BoxFreieZeitfenster(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final String benutzername;
  const _WelcomeHeader({required this.benutzername});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
          color: Colors.black,
        );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Willkommen", style: baseStyle),
            TextSpan(
              text: ", $benutzername!",
              style: baseStyle?.copyWith(color: const Color(0xFFcc5c4c)),
            ),
          ],
        ),
      ),
    );
  }
}
