class FinancialDayResult {
  final double savedAmount;
  final double overflowAmount;

  FinancialDayResult({required this.savedAmount, required this.overflowAmount});
}

class FinancialEngine {
  /// Recalculates `monthlyTargetSavings` when user edits `dailySpendingLimit`
  static double calculateSavingsFromDailyLimit({
    required double distributableBalance,
    required double dailySpendingLimit,
    required int daysInMonth,
  }) {
    return distributableBalance - (dailySpendingLimit * daysInMonth);
  }

  /// Recalculates `dailySpendingLimit` when user edits `monthlyTargetSavings`
  static double calculateDailyLimitFromSavings({
    required double distributableBalance,
    required double monthlyTargetSavings,
    required int daysInMonth,
  }) {
    // Avoid division by zero
    if (daysInMonth <= 0) return 0.0;
    return (distributableBalance - monthlyTargetSavings) / daysInMonth;
  }

  /// Evaluates daily transaction accumulation at end-of-day or real-time
  /// tracking.
  /// Leftovers go to savings. Exceeding daily limit causes an overflow tracking.
  static FinancialDayResult evaluateDailyClose({
    required double dailySpendingLimit,
    required double spentToday,
  }) {
    if (spentToday < dailySpendingLimit) {
      return FinancialDayResult(
        savedAmount: dailySpendingLimit - spentToday,
        overflowAmount: 0.0,
      );
    } else if (spentToday > dailySpendingLimit) {
      return FinancialDayResult(
        savedAmount: 0.0,
        overflowAmount: spentToday - dailySpendingLimit,
      );
    } else {
      return FinancialDayResult(savedAmount: 0.0, overflowAmount: 0.0);
    }
  }
}
