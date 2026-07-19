import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ExchangeRateApiException implements Exception {
  final String message;
  ExchangeRateApiException(this.message);
  @override
  String toString() => 'ExchangeRateApiException: $message';
}

class ExchangeRateApiService {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  /// Fetches live exchange rates with an exponential backoff retry mechanism.
  /// Base currency is hardcoded to 'TRY' per constraints.
  Future<Map<String, double>> fetchLiveRates({int maxRetries = 3}) async {
    int attempts = 0;

    while (attempts <= maxRetries) {
      try {
        final url = Uri.parse('$_baseUrl/TRY');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data != null && data['rates'] != null) {
            final rates = data['rates'] as Map<String, dynamic>;
            final Map<String, double> convertedRates = {};

            rates.forEach((key, value) {
              convertedRates[key] = (value as num).toDouble();
            });

            // Ensure TRY is always 1.0 just in case
            convertedRates['TRY'] = 1.0;
            return convertedRates;
          } else {
            throw ExchangeRateApiException('Invalid API response structure');
          }
        } else {
          throw ExchangeRateApiException('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        attempts++;
        if (attempts > maxRetries) {
          debugPrint('ExchangeRateApiService: All $maxRetries retries failed.');
          throw ExchangeRateApiException(
            'Failed to fetch rates after $maxRetries attempts: $e',
          );
        }

        // Exponential backoff logic: 2s, 4s, 8s...
        // 2^(attempts)
        final delaySeconds = 1 << attempts;
        debugPrint(
          'ExchangeRateApiService: Fetch failed ($e). Retrying in $delaySeconds seconds (Attempt $attempts of $maxRetries)...',
        );
        await Future.delayed(Duration(seconds: delaySeconds));
      }
    }

    throw ExchangeRateApiException('Unknown error occurred');
  }
}
