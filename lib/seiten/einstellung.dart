import 'package:flutter/material.dart';
import '../controllers/einstellung_controller.dart';
import '../models/app_settings.dart';

class EinstellungSeite extends StatefulWidget {
  const EinstellungSeite({super.key});

  @override
  State<EinstellungSeite> createState() => _EinstellungSeiteState();
}

class _EinstellungSeiteState extends State<EinstellungSeite>
    with TickerProviderStateMixin {
  late final EinstellungController ctrl;
  late final TabController tab;

  @override
  void initState() {
    super.initState();
    ctrl = EinstellungController();
    ctrl.init();
    tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        if (!ctrl.loaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final s = ctrl.settings;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: const Text('Einstellungen'),
            bottom: TabBar(
              controller: tab,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Profil'),
                Tab(icon: Icon(Icons.schedule), text: 'Termine'),
                Tab(icon: Icon(Icons.notifications), text: 'Benachr.'),
                Tab(icon: Icon(Icons.palette), text: 'Darstellung'),
              ],
            ),
          ),
          body: TabBarView(
            controller: tab,
            children: [
              // --- PROFIL ---
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SectionTitle('Sprache'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<Sprache>(
                          initialValue: s.sprache, // ✅ statt value
                          items: const [
                            DropdownMenuItem(value: Sprache.de, child: Text('Deutsch')),
                            DropdownMenuItem(value: Sprache.en, child: Text('English')),
                            DropdownMenuItem(value: Sprache.tr, child: Text('Türkçe')),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            ctrl.update((u) => u.sprache = val);
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 24),
                        _SectionTitle('Passwort & Profil (Platzhalter)'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Passwort ändern – später mit DB verbinden')),
                                );
                              },
                              icon: const Icon(Icons.lock_reset),
                              label: const Text('Passwort ändern'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Profilbild hochladen – später mit Storage verbinden')),
                                );
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Profilbild hochladen'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- TERMINE ---
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SectionTitle('Standard-Dauer'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          initialValue: s.standardTermindauerMin, // ✅
                          items: const [
                            DropdownMenuItem(value: 15, child: Text('15 Minuten')),
                            DropdownMenuItem(value: 30, child: Text('30 Minuten')),
                            DropdownMenuItem(value: 45, child: Text('45 Minuten')),
                            DropdownMenuItem(value: 60, child: Text('60 Minuten')),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            ctrl.update((u) => u.standardTermindauerMin = val);
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        _TwoCols(
                          left: _NumDropdown(
                            label: 'Puffer vor Termin',
                            value: s.pufferVorMin,
                            values: const [0, 5, 10, 15],
                            onChanged: (v) => ctrl.update((u) => u.pufferVorMin = v),
                          ),
                          right: _NumDropdown(
                            label: 'Puffer nach Termin',
                            value: s.pufferNachMin,
                            values: const [0, 5, 10, 15],
                            onChanged: (v) => ctrl.update((u) => u.pufferNachMin = v),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          value: s.pausenAutomatisch,
                          onChanged: (val) =>
                              ctrl.update((u) => u.pausenAutomatisch = val),
                          title: const Text('Automatische Pausen einplanen'),
                          subtitle: const Text('z. B. Mittagspause automatisch blocken'),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Öffnungszeiten & Pausen-Editor kommt später (mit DB/Service).',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- BENACHRICHTIGUNGEN ---
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: s.kundenErinnerung,
                          onChanged: (val) =>
                              ctrl.update((u) => u.kundenErinnerung = val),
                          title: const Text('Kunden-Erinnerungen senden'),
                          subtitle: const Text('z. B. 24h vor Termin (Mail/SMS)'),
                        ),
                        SwitchListTile(
                          value: s.mitarbeiterReminder,
                          onChanged: (val) =>
                              ctrl.update((u) => u.mitarbeiterReminder = val),
                          title: const Text('Mitarbeiter-Reminder'),
                          subtitle: const Text('z. B. 15 Min vor Termin'),
                        ),
                        SwitchListTile(
                          value: s.tagesuebersichtAmMorgen,
                          onChanged: (val) =>
                              ctrl.update((u) => u.tagesuebersichtAmMorgen = val),
                          title: const Text('Tagesübersicht am Morgen'),
                          subtitle: const Text('z. B. 08:00 – „Wer kommt heute?“'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- DARSTELLUNG ---
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: s.darkmode,
                          onChanged: (val) => ctrl.update((u) => u.darkmode = val),
                          title: const Text('Dark Mode'),
                        ),
                        const SizedBox(height: 8),
                        _SectionTitle('Startseite'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<Startseite>(
                          initialValue: s.startseite, // ✅
                          items: const [
                            DropdownMenuItem(
                                value: Startseite.dashboard, child: Text('Dashboard')),
                            DropdownMenuItem(
                                value: Startseite.kunden, child: Text('Kunden')),
                            DropdownMenuItem(
                                value: Startseite.terminuebersicht,
                                child: Text('Terminübersicht')),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            ctrl.update((u) => u.startseite = val);
                          },
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dashboard-Boxen anpassen (ein-/ausblenden) folgt später.',
                            style: Theme.of(context).textTheme.bodySmall,
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
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              )),
    );
  }
}

class _TwoCols extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _TwoCols({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 700) {
        return Column(children: [left, const SizedBox(height: 12), right]);
      }
      return Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      );
    });
  }
}

class _NumDropdown extends StatelessWidget {
  final String label;
  final int value;
  final List<int> values;
  final ValueChanged<int> onChanged;

  const _NumDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value, // ✅ statt value:
      items: values
          .map((v) => DropdownMenuItem(value: v, child: Text('$v Minuten')))
          .toList(),
      onChanged: (val) {
        if (val == null) return;
        onChanged(val);
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
