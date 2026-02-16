import 'package:flutter/material.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTab)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.changeLanguage),
            subtitle: Text(l10n.changeLanguageSubtitle),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentLocale.languageCode,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(l10n.languageEnglish),
                  ),
                  DropdownMenuItem(
                    value: 'he',
                    child: Text(l10n.languageHebrew),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    localeNotifier.setLocale(Locale(value));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
