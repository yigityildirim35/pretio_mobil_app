import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      // Default to system locale or english if not set
      // We leave it null to let MaterialApp use system locale initially,
      // or we can force a default. Let's force 'tr' or 'en' based on system?
      // For now, let's default to English if nothing saved, or maybe just null.
      // If null, MaterialApp uses device locale.
      // But user asked for specific behavior: "sadece türkçe ve ingilizce dilleri bulunsun"
      // Let's default to Turkish if system is Turkish, else English.
      // But we can just start with English as distinct default.
      _locale = const Locale(
        'tr',
      ); // Default to TR as per request context implication (Turkish user)
      // User said "sadece türkçe ve ingilizce".
    }
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    if (!['en', 'tr', 'fr', 'de', 'es'].contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }
}
