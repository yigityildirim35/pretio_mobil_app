import 'package:decimal/decimal.dart';

class CurrencyConversionService {
  /// Converts an amount in the base currency (TRY) to the target currency.
  /// Uses Decimal to prevent floating point inaccuracies during computation.
  Decimal convertFromBase(
    Decimal amountInBase,
    String targetCurrency,
    Map<String, double> rates,
  ) {
    if (targetCurrency == 'TL' || targetCurrency == 'TRY') {
      return amountInBase;
    }

    final double? rateDouble = rates[targetCurrency];
    if (rateDouble == null) {
      return amountInBase; // Fallback if rate is missing
    }

    final rate = Decimal.parse(rateDouble.toString());
    return amountInBase * rate;
  }

  /// Converts an amount from a target currency back to the base currency (TRY).
  /// Uses Decimal to prevent floating point inaccuracies during computation.
  Decimal convertToBase(
    Decimal amountInTarget,
    String targetCurrency,
    Map<String, double> rates,
  ) {
    if (targetCurrency == 'TL' || targetCurrency == 'TRY') {
      return amountInTarget;
    }

    final double? rateDouble = rates[targetCurrency];
    if (rateDouble == null || rateDouble == 0) {
      return amountInTarget; // Avoid division by zero or missing
    }

    final rate = Decimal.parse(rateDouble.toString());

    // We parse it down to a precision scale when dividing to avoid repeating decimal errors
    final val = (amountInTarget / rate).toDecimal(scaleOnInfinitePrecision: 8);
    return val;
  }
}
