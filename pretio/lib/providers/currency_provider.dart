import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../data/services/exchange_rate_api_service.dart';
import '../data/services/local_rate_cache_service.dart';
import '../domain/services/currency_conversion_service.dart';
import '../services/local_storage_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final ExchangeRateApiService _apiService = ExchangeRateApiService();
  final LocalRateCacheService _cacheService = LocalRateCacheService();
  final CurrencyConversionService _conversionService =
      CurrencyConversionService();
  final LocalStorageService _storageService = LocalStorageService();

  String _currency = 'TL';
  Map<String, double> _rates = {'TL': 1.0, 'TRY': 1.0};

  bool _isLoading = false;
  bool _isOffline = false;
  bool _isPrivacyModeEnabled = false;

  String get currency => _currency;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  bool get isPrivacyModeEnabled => _isPrivacyModeEnabled;


  Future<void> init() async {
    await loadCurrency();
    await _initializeRates();
  }


  Future<void> loadCurrency() async {
    _currency = await _storageService.loadCurrency();
    _isPrivacyModeEnabled = await _storageService.loadBoolSetting('settings_privacy_enabled', defaultValue: false);
    notifyListeners();
  }


  Future<void> setCurrency(String newCurrency) async {
    if (_currency == newCurrency) return;
    _currency = newCurrency;
    notifyListeners();
    await _storageService.saveCurrency(newCurrency);

    // Attempt fetch if new currency isn't cached (though our api fetches all at once)
    if (_rates.isEmpty ||
        (!_rates.containsKey(newCurrency) && newCurrency != 'TL')) {
      await fetchRatesSilently();
    }
  }

  Future<void> setPrivacyModeEnabled(bool value) async {
    if (_isPrivacyModeEnabled == value) return;
    _isPrivacyModeEnabled = value;
    notifyListeners();
    await _storageService.saveBoolSetting('settings_privacy_enabled', value);
  }


  Future<void> _initializeRates() async {
    _isLoading = true;
    notifyListeners();

    // 1. Try to load from cache first
    final cacheData = await _cacheService.loadExchangeRates();

    if (cacheData != null) {
      _rates = cacheData['rates'] as Map<String, double>;
      final timestamp = cacheData['timestamp'] as DateTime;

      // Stop blocking loading spinner since we have stable fallback memory
      _isLoading = false;
      notifyListeners();

      // If older than 1 hour -> background fetch
      if (DateTime.now().difference(timestamp).inHours >= 1) {
        await fetchRatesSilently();
      }
    } else {
      // No cache exists, we must fetch and potentially block UI or show fallback
      await fetchRatesSilently();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRatesSilently() async {
    try {
      final freshRates = await _apiService.fetchLiveRates(maxRetries: 3);
      _rates = freshRates;
      _isOffline = false;
      await _cacheService.saveExchangeRates(_rates);
      notifyListeners();
    } catch (e) {
      debugPrint(
        'CurrencyProvider: Failed to fetch recent rates in background. Using cache. Error: $e',
      );
      _isOffline = true;

      // Safe fallback logic if no Internet and Cache is permanently empty
      if (_rates.isEmpty || !_rates.containsKey('USD')) {
        _rates = {
          'TRY': 1.0,
          'TL': 1.0,
          'USD': 0.025, // Fallback roughly ~ 40 TL
          'EUR': 0.023,
        };
      }
      notifyListeners();
    }
  }

  double convertFromBase(double amountInBase, String targetCurrency) {
    final amtDec = Decimal.parse(amountInBase.toString());
    final resultDec = _conversionService.convertFromBase(
      amtDec,
      targetCurrency,
      _rates,
    );
    return resultDec.toDouble();
  }

  double convertToBase(double amountInTarget, String targetCurrency) {
    final amtDec = Decimal.parse(amountInTarget.toString());
    final resultDec = _conversionService.convertToBase(
      amtDec,
      targetCurrency,
      _rates,
    );
    return resultDec.toDouble();
  }

  String getDisplayValue(double amountInBase, {bool compact = false}) {
    final convertedAmount = convertFromBase(amountInBase, _currency);
    return formatCurrency(convertedAmount, _currency, compact: compact);
  }

  String formatCurrency(double amount, String currencyCode, {bool compact = false}) {
    String symbol;
    switch (currencyCode) {
      case 'USD':
        symbol = '\$';
        break;
      case 'EUR':
        symbol = '€';
        break;
      case 'TL':
      case 'TRY':
      default:
        symbol = '₺';
        break;
    }

    if (_isPrivacyModeEnabled) {
      return '$symbol ***';
    }

    if (compact) {

      final absAmount = amount.abs();
      final sign = amount < 0 ? '-' : '';
      if (absAmount >= 1000000) {
        return '$sign$symbol${(absAmount / 1000000).toStringAsFixed(1)}M';
      } else if (absAmount >= 1000) {
        return '$sign$symbol${(absAmount / 1000).toStringAsFixed(1)}k';
      }
      return '$sign$symbol${absAmount.toStringAsFixed(0)}';
    }

    // Enterprise required: round correctly to 2 decimals visually
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
