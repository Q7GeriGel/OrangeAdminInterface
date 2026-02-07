import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friseur_orange_web/l10n/gen/app_localizations.dart';

import '../controllers/app_settings_controller.dart';
import '../widgets/app_card.dart';
import '../widgets/app_page.dart';
import '../widgets/app_section_header.dart';
import '../widgets/theme/app_tokens.dart';

class EinstellungSeite extends StatefulWidget {
  const EinstellungSeite({super.key});

  @override
  State<EinstellungSeite> createState() => _EinstellungSeiteState();
}

class _EinstellungSeiteState extends State<EinstellungSeite> {
  ThemeMode? _themeMode;
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.read<AppSettingsController>();
    _themeMode ??= settings.themeMode;
    _locale ??= settings.locale;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final settings = context.watch<AppSettingsController>();
    final hasChanges = (_themeMode ?? settings.themeMode) != settings.themeMode ||
        (_locale ?? settings.locale) != settings.locale;

    return AppPage(
      title: t.settings,
      actions: [
        ElevatedButton.icon(
          onPressed: hasChanges
              ? () async {
                  await context.read<AppSettingsController>().save(
                        themeMode: _themeMode,
                        locale: _locale,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.saved)),
                    );
                  }
                }
              : null,
          icon: const Icon(Icons.save_outlined),
          label: Text(t.save),
        ),
      ],
      child: ListView(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: t.darkMode,
                  icon: Icons.dark_mode_outlined,
                ),
                const SizedBox(height: AppGaps.s12),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(value: ThemeMode.light, label: Text(t.themeLight)),
                    ButtonSegment(value: ThemeMode.dark, label: Text(t.themeDark)),
                    ButtonSegment(value: ThemeMode.system, label: Text(t.themeSystem)),
                  ],
                  selected: {_themeMode ?? settings.themeMode},
                  onSelectionChanged: (s) => setState(() => _themeMode = s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppGaps.s18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: t.language,
                  icon: Icons.language_outlined,
                ),
                const SizedBox(height: AppGaps.s12),
                DropdownButtonFormField<Locale>(
                  initialValue: _locale ?? settings.locale,
                  items: [
                    DropdownMenuItem(value: const Locale('de'), child: Text(t.langGerman)),
                    DropdownMenuItem(value: const Locale('tr'), child: Text(t.langTurkish)),
                  ],
                  onChanged: (v) => setState(() => _locale = v),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
