import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/currency_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    // Hardcoded manual localization for "Settings" title if not in AppLocalizations yet,
    // or use a safe fallback. Assuming 'appPreferences' or similar exists, or just 'Settings'.
    // For now, I'll use a direct string or try to use AppLocalizations if a 'settings' key exists.
    // Based on previous files, 'appPreferences' exists. I'll use "Settings" hardcoded for now
    // or look for a suitable key. I'll use "Settings" as the title.

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Divider(color: theme.dividerColor),

            // Language Setting
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              trailing: DropdownButton<Locale>(
                value: localeProvider.locale ?? const Locale('en'),
                dropdownColor: theme.cardColor,
                underline: Container(), // Remove underline
                icon: const Icon(Icons.arrow_drop_down),
                items: [
                  const DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('🇬🇧 English'),
                  ),
                  const DropdownMenuItem(
                    value: Locale('tr'),
                    child: Text('🇹🇷 Türkçe'),
                  ),
                  const DropdownMenuItem(
                    value: Locale('fr'),
                    child: Text('🇫🇷 Français'),
                  ),
                ],
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    localeProvider.setLocale(newLocale);
                  }
                },
              ),
            ),

            // Currency Setting
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: Text(AppLocalizations.of(context)!.currency),
              trailing: DropdownButton<String>(
                value: currencyProvider.currency,
                dropdownColor: theme.cardColor,
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down),
                items: ['TL', 'USD', 'EUR', 'GBP'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    currencyProvider.setCurrency(newValue);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
