import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  /// Fetches live exchange rates for the given base currency.
  /// Returns a Map<String, double> where key is currency code and value is rate.
  /// Example: {'USD': 0.03, 'EUR': 0.028} for base 'TRY'.
  Future<Map<String, double>> fetchLiveRates(String baseCurrency) async {
    try {
      final url = Uri.parse('$_baseUrl/$baseCurrency');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        // Convert all values to double safely
        final Map<String, double> convertedRates = {};
        rates.forEach((key, value) {
          convertedRates[key] = (value as num).toDouble();
        });

        // Ensure base currency is 1.0
        convertedRates[baseCurrency] = 1.0;

        return convertedRates;
      } else {
        throw Exception('Failed to load rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to currency API: $e');
    }
  }
}
