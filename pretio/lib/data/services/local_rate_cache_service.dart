import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRateCacheService {
  static const String _currencyRatesKey = 'currency_rates_v3';
  static const String _ratesTimestampKey = 'currency_rates_timestamp_v3';

  /// Saves the exchange rates and current timestamp to local storage.
  Future<void> saveExchangeRates(Map<String, double> rates) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(rates);

    // We run these operations concurrently for minor performance gains
    await Future.wait([
      prefs.setString(_currencyRatesKey, encoded),
      prefs.setString(_ratesTimestampKey, DateTime.now().toIso8601String()),
    ]);
  }

  /// Loads the exchange rates and their timestamp from local storage.
  /// Returns null if there are no cached rates.
  Future<Map<String, dynamic>?> loadExchangeRates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_currencyRatesKey);
    final String? timestampStr = prefs.getString(_ratesTimestampKey);

    if (encoded == null || timestampStr == null) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(encoded);
      final Map<String, double> rates = {};

      decoded.forEach((key, value) {
        rates[key] = (value as num).toDouble();
      });

      return {'rates': rates, 'timestamp': DateTime.parse(timestampStr)};
    } catch (e) {
      // If parsing fails for some corrupted cache reason, return null
      return null;
    }
  }
}
