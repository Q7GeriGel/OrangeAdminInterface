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

  /// ✅ Wichtig: wir normalisieren ALLE Locales auf nur languageCode (tr/de),
  /// damit Dropdown exakt 1 Match findet (und nicht tr_TR vs tr)
  Locale? _norm(Locale? l) {
    if (l == null) return null;
    return Locale(l.languageCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.read<AppSettingsController>();

    _themeMode ??= settings.themeMode;
    _locale ??= _norm(settings.locale) ?? const Locale('de');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = AppColors.of(context);

    final currentTheme = context.watch<AppSettingsController>().themeMode;
    final currentLocale = _norm(context.watch<AppSettingsController>().locale);

    final hasChanges =
        _themeMode != currentTheme || _norm(_locale) != currentLocale;

    return AppPage(
      title: l10n.settings,
      actions: [
        ElevatedButton.icon(
          onPressed: hasChanges
              ? () async {
                  await context.read<AppSettingsController>().save(
                        themeMode: _themeMode,
                        locale: _norm(_locale),
                      );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.save)),
                    );
                  }
                }
              : null,
          icon: const Icon(Icons.save_outlined),
          label: Text(l10n.save),
        ),
      ],
      child: ListView(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: l10n.darkMode,
                  icon: Icons.dark_mode_outlined,
                ),
                const SizedBox(height: AppGaps.s12),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ButtonSegment(
                        value: ThemeMode.system, label: Text('System')),
                  ],
                  selected: {_themeMode ?? ThemeMode.system},
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
                  title: l10n.language,
                  icon: Icons.language_outlined,
                ),
                const SizedBox(height: AppGaps.s12),

                // ✅ Dropdown muss exakt 1 Match haben -> nur Locale('tr') / Locale('de')
                DropdownButtonFormField<Locale>(
                  value: _norm(_locale),
                  items: const [
                    DropdownMenuItem(
                      value: Locale('tr'),
                      child: Text('Türkçe'),
                    ),
                    DropdownMenuItem(
                      value: Locale('de'),
                      child: Text('Deutsch'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _locale = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.isDark
                        ? colors.scheme.surface.withValues(alpha: 0.35)
                        : colors.scheme.surface,
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
