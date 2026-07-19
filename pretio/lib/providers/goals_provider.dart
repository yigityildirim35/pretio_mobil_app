import 'package:flutter/material.dart';
import '../utils/financial_engine.dart';
import '../services/local_storage_service.dart';
import 'transaction_provider.dart';
import 'subscription_provider.dart';

class GoalsProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  // --- Core Inputs ---
  double _currentBalance = 0.0;

  // --- User Interactive State ---
  double _dailySpendingLimit = 0.0;
  double _monthlyTargetSavings = 0.0;

  // --- Accumulated State ---
  double _bigGoalSavings = 0.0; // Total accumulated extra savings over time
  double _spentToday = 0.0;

  // --- Dates for Logic ---
  DateTime _lastProcessedDate = DateTime.now();
  int _daysInMonth = 30; // Calculated dynamically based on current month/year

  bool _isInitialized = false;
  bool _isInitializing = false;

  bool get isInitialized => _isInitialized;

  // --- Getters ---
  double get distributableBalance => _currentBalance;
  double get dailySpendingLimit => _dailySpendingLimit;
  double get monthlyTargetSavings => _monthlyTargetSavings;
  double get bigGoalSavings => _bigGoalSavings;
  double get spentToday => _spentToday;
  bool get isOverBudget => _spentToday > _dailySpendingLimit;
  bool get isSavingsDepleted => _monthlyTargetSavings <= 0;

  // Additional helpful getters
  double get remainingToday => (_dailySpendingLimit - _spentToday) > 0
      ? (_dailySpendingLimit - _spentToday)
      : 0.0;

  double get todayProgressPercent {
    if (_dailySpendingLimit <= 0) return 0.0;
    return (_spentToday / _dailySpendingLimit).clamp(0.0, 1.0);
  }

  // Helper to safely access shadow goal from TxProvider if available
  double updateShadowGoalAmount = 0.0;

  double get baseMonthlyTargetSavings {
    double initialSavings =
        distributableBalance - (_dailySpendingLimit * _daysInMonth);
    return initialSavings > 0 ? initialSavings : _monthlyTargetSavings;
  }

  int get remainingDaysInMonth => _daysInMonth - DateTime.now().day + 1;

  // Initialization & Config
  Future<void> _initAsync(TransactionProvider txProvider) async {
    final now = DateTime.now();
    _calculateDaysInMonth(now.year, now.month);

    await _loadPersistedData();

    // FIX: Evaluate previously passed days with the EXACT limits loaded from yesterday
    // BEFORE recalculating today's limit, to avoid applying today's limit to yesterday's spending
    processDayTransition(now);

    if (_dailySpendingLimit == 0 && _monthlyTargetSavings == 0) {
      if (distributableBalance > 0) {
        // Default everything to daily limit if not set
        _dailySpendingLimit = distributableBalance / _daysInMonth;
        _monthlyTargetSavings = 0.0;
        await _saveConfigurations();
      }
    } else {
      // IMPORTANT: We honor the _dailySpendingLimit loaded from storage.
      // Do NOT recalculate it from _monthlyTargetSavings here, as the denominator 
      // (remainingDaysInMonth) shifts daily and causes the value to drift.
    }
    
    // Auto-recovery for the bug that caused negative bigGoalSavings due to incorrect limits
    if (_bigGoalSavings < 0) {
      _bigGoalSavings = 0.0;
      await _saveDailyState();
    }

    _isInitialized = true;
    _isInitializing = false;

    notifyListeners();
  }

  void _calculateDaysInMonth(int year, int month) {
    // 0th day of next month is the last day of current month
    _daysInMonth = DateTime(year, month + 1, 0).day;
  }

  void updateIncomeAndExpenses(double newIncome, double newExpenses) {
    // Deprecated. Do nothing, since current balance is dynamically pulled.
  }

  void updateDependencies({
    required TransactionProvider txProvider,
    required SubscriptionProvider subProvider,
    required double income,
    required double expenses,
  }) {
    final now = DateTime.now();

    // Do not initialize or evaluate income changes until TransactionProvider has fully loaded from disk.
    if (!txProvider.isDataLoaded) return;

    // FIX: The base distributable balance is strictly the Initial Balance (Income - Fixed Expenses)
    // minus all expenses from prior months, so the budget carries over month-to-month.
    // minus all expenses from prior months, PLUS any incomes earned this month
    final incomesThisMonth = txProvider.transactions
        .where((t) => t.type == 'income' && t.date.year == now.year && t.date.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
    final newBaseBalance = txProvider.balanceAtStartOfMonth(now) + incomesThisMonth;

    if (!_isInitialized && !_isInitializing) {
      _isInitializing = true;
      _currentBalance = newBaseBalance;
      _initAsync(txProvider);
      return;
    }
    if (!_isInitialized) return;

    bool incomeChanged = false;
    if ((_currentBalance - newBaseBalance).abs() > 0.001) {
      _currentBalance = newBaseBalance;
      incomeChanged = true;
    }

    // Always ensure TransactionProvider's dailyGoal stays in sync with our MASTER limit
    if ((txProvider.dailyGoal - _dailySpendingLimit).abs() > 0.01) {
      Future.microtask(() => txProvider.updateDailyGoal(_dailySpendingLimit));
    }

    if (incomeChanged) {
      // If user's salary or subscriptions change, we keep the Daily Spending Limit fixed (MASTER),
      // as per user preference, and recalculate the Monthly Target Savings to absorb the difference.
      _monthlyTargetSavings = FinancialEngine.calculateSavingsFromDailyLimit(
        distributableBalance: _currentBalance,
        dailySpendingLimit: _dailySpendingLimit,
        daysInMonth: _daysInMonth,
      );
      _saveConfigurations();
    }

    // Ensure day transitions happen automatically even if app is kept alive
    if (now.day != _lastProcessedDate.day ||
        now.month != _lastProcessedDate.month ||
        now.year != _lastProcessedDate.year) {
      processDayTransition(now);
    }

    // Dynamically calculate spentToday from transactions to react automatically to adds/edits/deletes
    double newSpentToday = 0.0;
    for (var tx in txProvider.transactions) {
      if (tx.type == 'expense' &&
          tx.date.year == now.year &&
          tx.date.month == now.month &&
          tx.date.day == now.day) {
        final catLower = tx.category.toLowerCase();
        if (catLower != 'abonelik' && catLower != 'subscriptions') {
          newSpentToday += tx.amount;
        }
      }
    }

    // If the spent amount for today changed (transaction added/edited/deleted)
    if ((newSpentToday - _spentToday).abs() > 0.001) {
      double diff = newSpentToday - _spentToday;

      if (diff > 0) {
        // Amount added
        double newTotal = _spentToday + diff;
        if (newTotal > _dailySpendingLimit) {
          double previousOverflow = _spentToday > _dailySpendingLimit
              ? _spentToday - _dailySpendingLimit
              : 0.0;
          double currentOverflow = newTotal - _dailySpendingLimit;
          double newOverflowCreated = currentOverflow - previousOverflow;
          _monthlyTargetSavings -= newOverflowCreated;
        }
      } else {
        // Amount removed (diff is negative)
        double amountRemoved = -diff;
        double newTotal = _spentToday - amountRemoved;
        if (_spentToday > _dailySpendingLimit) {
          double previousOverflow = _spentToday - _dailySpendingLimit;
          double currentOverflow = newTotal > _dailySpendingLimit
              ? newTotal - _dailySpendingLimit
              : 0.0;
          double overflowResolved = previousOverflow - currentOverflow;
          _monthlyTargetSavings += overflowResolved;
        }
      }

      _spentToday = newSpentToday;
      _saveDailyState();
      
      // Save configurations because _monthlyTargetSavings might have changed from overflow
      _saveConfigurations();

      // Delay notifyListeners to avoid build-time update clashes from ProxyProvider
      Future.microtask(() => notifyListeners());
    } else if (incomeChanged) {
      Future.microtask(() => notifyListeners());
    }
  }

  void updateDailySpendingLimit(double newLimit) {
    _dailySpendingLimit = newLimit;
    _monthlyTargetSavings = FinancialEngine.calculateSavingsFromDailyLimit(
      distributableBalance: _currentBalance,
      dailySpendingLimit: _dailySpendingLimit,
      daysInMonth: _daysInMonth,
    );
    _saveConfigurations();
    notifyListeners();
  }

  void updateMonthlyTargetSavings(double newTarget) {
    _monthlyTargetSavings = newTarget;
    _dailySpendingLimit = FinancialEngine.calculateDailyLimitFromSavings(
      distributableBalance: _currentBalance,
      monthlyTargetSavings: _monthlyTargetSavings,
      daysInMonth: _daysInMonth,
    );
    _saveConfigurations();
    notifyListeners();
  }

  void addExtraIncome(double amount) {
    if (amount <= 0) return;
    _bigGoalSavings += amount;
    _saveDailyState();
    notifyListeners();
  }

  void withdrawExtramIncome(double amount) {
    if (amount <= 0) return;
    _bigGoalSavings -= amount;
    // Don't let total savings go negative unless absolutely necessary,
    // but in realistic scenarios withdrawing more than you have would be at 0 minimum.
    if (_bigGoalSavings < 0) {
      _bigGoalSavings = 0;
    }
    _saveDailyState();
    notifyListeners();
  }

  void resetGoal(TransactionProvider txProvider) {
    _bigGoalSavings = 0.0;
    _monthlyTargetSavings = 0.0;
    // Reset to default daily limit based on current balance
    _calculateDaysInMonth(DateTime.now().year, DateTime.now().month);
    _dailySpendingLimit = _currentBalance / _daysInMonth;

    txProvider.resetShadowGoal();
    txProvider.updateDailyGoal(_dailySpendingLimit);

    _saveConfigurations();
    _saveDailyState();
    notifyListeners();
  }

  void processDayTransition(DateTime currentDate) {
    DateTime last = DateTime(
      _lastProcessedDate.year,
      _lastProcessedDate.month,
      _lastProcessedDate.day,
    );
    DateTime cur = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    if (last.isAtSameMomentAs(cur)) {
      return; // Still the same day
    }

    int daysPassed = cur.difference(last).inDays;

    if (daysPassed > 0) {
      // Process yesterday first
      FinancialDayResult result = FinancialEngine.evaluateDailyClose(
        dailySpendingLimit: _dailySpendingLimit,
        spentToday: _spentToday,
      );

      double saved = result.savedAmount;

      // Restore Monthly Target Savings first if we were under limit, then send the rest to Big Goal
      if (saved > 0) {
        double baseTarget = baseMonthlyTargetSavings;
        if (_monthlyTargetSavings < baseTarget) {
          double deficit = baseTarget - _monthlyTargetSavings;
          if (saved <= deficit) {
            _monthlyTargetSavings += saved;
            saved = 0;
          } else {
            _monthlyTargetSavings += deficit;
            saved -= deficit;
          }
        }
        _bigGoalSavings += saved;
      }

      // If user skipped days, those empty days count as 0 spent,
      // adding FULL daily limit to savings.
      if (daysPassed > 1) {
        double missedSavings = _dailySpendingLimit * (daysPassed - 1);
        
        double baseTarget = baseMonthlyTargetSavings;
        if (_monthlyTargetSavings < baseTarget) {
          double deficit = baseTarget - _monthlyTargetSavings;
          if (missedSavings <= deficit) {
            _monthlyTargetSavings += missedSavings;
            missedSavings = 0;
          } else {
            _monthlyTargetSavings += deficit;
            missedSavings -= deficit;
          }
        }
        _bigGoalSavings += missedSavings;
      }

      // Reset for today
      _spentToday = 0.0;
    }

    // Handle Month Transition
    if (currentDate.year != _lastProcessedDate.year ||
        currentDate.month != _lastProcessedDate.month) {
      _processMonthTransition(currentDate);
    }

    _lastProcessedDate = currentDate;
    _saveDailyState();
    _saveConfigurations();
    notifyListeners();
  }

  void _processMonthTransition(DateTime currentDate) {
    _calculateDaysInMonth(currentDate.year, currentDate.month);

    // Optional: Transfer whatever is left in target savings to the big goal at month end.
    if (_monthlyTargetSavings > 0) {
      _bigGoalSavings += _monthlyTargetSavings;
    }

    // Reset daily limit based on the strict rule (monthlyTargetSavings is the Boss)
    _dailySpendingLimit = FinancialEngine.calculateDailyLimitFromSavings(
      distributableBalance: _currentBalance,
      monthlyTargetSavings: _monthlyTargetSavings,
      daysInMonth: _daysInMonth,
    );
  }

  // --- Persistance Handling placeholders (Requires LocalStorageService modifications) ---

  Future<void> _loadPersistedData() async {
    final data = await _storage.loadGoalsData();
    _dailySpendingLimit = data['dailyLimit'] ?? 0.0;
    _monthlyTargetSavings = data['monthlyTarget'] ?? 0.0;
    _bigGoalSavings = data['bigGoalSavings'] ?? 0.0;
    _spentToday = data['spentToday'] ?? 0.0;

    final lastDateStr = data['lastProcessedDate'];
    if (lastDateStr != null && lastDateStr.isNotEmpty) {
      _lastProcessedDate = DateTime.tryParse(lastDateStr) ?? DateTime.now();
    }
  }

  Future<void> _saveConfigurations() async {
    await _storage.saveGoalsConfiguration(
      dailyLimit: _dailySpendingLimit,
      monthlyTarget: _monthlyTargetSavings,
    );
  }

  Future<void> _saveDailyState() async {
    await _storage.saveGoalsDailyState(
      spentToday: _spentToday,
      bigGoalSavings: _bigGoalSavings,
      lastProcessedDate: _lastProcessedDate.toIso8601String(),
    );
  }
}
