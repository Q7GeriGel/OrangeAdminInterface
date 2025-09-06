import 'package:flutter/material.dart'; 
import '../dashboard/box_freie_zeitfenster.dart'; 
import '../dashboard/box_aktuelle_aenderung'; 
import '../dashboard/box_bevorstehende_kunden';

class DashboardPage extends StatelessWidget {
  final String benutzername;

  const DashboardPage({super.key, required this.benutzername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Begrüßung
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Willkommen",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ", $benutzername!",
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcc5c4c),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Hier ist dein Tagesplan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Layout: Oben zwei Spalten, unten zentrierte Box
            Column(
              children: [
                // Erste Zeile: Zwei nebeneinander
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: BevorstehendeKundenBox()),
                    SizedBox(width: 24),
                    Expanded(child: AktuelleAenderungenBox()),
                  ],
                ),
                const SizedBox(height: 32),

                // Zweite Zeile: Freie Zeitfenster zentriert
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: const BoxFreieZeitfenster(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
