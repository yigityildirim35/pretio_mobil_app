import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../models/category_model.dart';

class TransactionProvider with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  List<Transaction> _transactions = [];
  // Gölge İşlemler
  List<ShadowTransaction> _shadowTransactions = [];

  // Kategoriler
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  // Callback to trigger external state updates (like badge evaluation)
  VoidCallback? onTransactionsChanged;

  bool _isDataLoaded = false;
  bool get isDataLoaded => _isDataLoaded;

  double _dailyGoal = 500.0;
  // Profil Ayarları
  double _salary = 25000.0;
  double _weeklyHours = 40.0;
  String _shadowGoalName = "Hedef";
  double _shadowGoalAmount = 20000.0;
  double _initialBalance = 20000.0;
  double _timeValueSalary = 25000.0;
  double _timeValueHours = 40.0;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<ShadowTransaction> get shadowTransactions => _shadowTransactions;
  double get dailyGoal => _dailyGoal;
  double get salary => _salary;
  double get weeklyHours => _weeklyHours;
  String get shadowGoalName => _shadowGoalName;
  double get shadowGoalAmount => _shadowGoalAmount;
  double get initialBalance => _initialBalance;
  double get timeValueSalary => _timeValueSalary;
  double get timeValueHours => _timeValueHours;

  // Computed: Streak (transaction bazlı, günlük harcama hedefine göre)
  int get currentStreak {
    if (_transactions.isEmpty) return 0;
    Map<String, double> dailyTotals = {};
    Set<String> activeDays = {};
    for (var t in _transactions) {
      String key = '${t.date.year}-${t.date.month}-${t.date.day}';
      activeDays.add(key);
      if (t.type == 'expense' && t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk') {
        dailyTotals[key] = (dailyTotals[key] ?? 0) + t.amount;
      }
    }
    int streak = 0;
    DateTime date = DateTime.now();
    while (true) {
      String key = '${date.year}-${date.month}-${date.day}';
      // Eğer o gün hiç işlem yoksa streak kırılır (bugün hariç)
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      if (!activeDays.contains(key) && !isToday) break;
      final total = dailyTotals[key] ?? 0.0;
      if (total <= _dailyGoal) {
        streak++;
      } else {
        break;
      }
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get longestStreak {
    if (_transactions.isEmpty) return 0;
    Map<String, double> dailyTotals = {};
    Set<String> activeDays = {};
    DateTime minDate = DateTime.now();
    for (var t in _transactions) {
      String key = '${t.date.year}-${t.date.month}-${t.date.day}';
      activeDays.add(key);
      if (t.type == 'expense' && t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk') {
        dailyTotals[key] = (dailyTotals[key] ?? 0) + t.amount;
      }
      if (t.date.isBefore(minDate)) minDate = t.date;
    }
    int longest = 0;
    int current = 0;
    DateTime date = DateTime(minDate.year, minDate.month, minDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    while (!date.isAfter(today)) {
      String key = '${date.year}-${date.month}-${date.day}';
      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      
      // Eğer o gün hiç işlem yoksa (bugün hariç) streak kırılır
      if (!activeDays.contains(key) && !isToday) {
        current = 0;
      } else {
        final total = dailyTotals[key] ?? 0.0;
        if (total <= _dailyGoal) {
          current++;
          if (current > longest) longest = current;
        } else {
          current = 0;
        }
      }
      date = date.add(const Duration(days: 1));
    }
    return longest;
  }

  // Computed: Saatlik Ücret Hesabı
  double get hourlyWage {
    // This is for display elsewhere, but let's check if we should use timeValue versions
    // For now, we keep the original logic for backward compatibility if needed, 
    // OR we change it to use the new independent fields.
    // The user said "zaman değeri tek başına çalışsın", so I will use the new fields here.
    if (_timeValueHours <= 0) return 0;
    return (_timeValueSalary / 4) / _timeValueHours;
  }

  double get currentBalance {
    final totalIncome = _transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final totalSpent = _transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    return _initialBalance + totalIncome - totalSpent;
  }

  double balanceAtStartOfMonth(DateTime date) {
    final transactionsBeforeThisMonth = _transactions.where((t) => t.date.isBefore(DateTime(date.year, date.month, 1)));
    final incomeBeforeThisMonth = transactionsBeforeThisMonth.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final spentBeforeThisMonth = transactionsBeforeThisMonth.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    
    return _initialBalance + incomeBeforeThisMonth - spentBeforeThisMonth;
  }

  // Initial Load
  Future<void> loadData() async {
    final txs = await _storage.loadTransactions();
    final shadowTxs = await _storage.loadShadowTransactions();
    final settings = await _storage.loadSettings();

    _transactions = txs;
    _shadowTransactions = shadowTxs;

    _dailyGoal = settings['dailyGoal'] ?? 500.0;
    _salary = settings['salary'] ?? 25000.0;
    _weeklyHours = settings['weeklyHours'] ?? 40.0;
    _shadowGoalName = settings['shadowGoalName'] ?? "Hedef";
    _shadowGoalAmount = settings['shadowGoalAmount'] ?? 20000.0;
    _initialBalance = settings['initialBalance'] ?? 20000.0;
    _categories = await _storage.loadCategories();
    
    final timeValueData = await _storage.loadTimeValueMetrics();
    _timeValueSalary = timeValueData['salary']!;
    _timeValueHours = timeValueData['hours']!;

    // Sıralama (Yeniden eskiye)
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    _shadowTransactions.sort((a, b) => b.date.compareTo(a.date));

    _isDataLoaded = true;

    _fireConditionalNotifications();
    notifyListeners();
  }

  // --- NORMAL İŞLEMLER ---
  void addTransaction(Transaction t) {
    if (t.category != 'no_spend') {
      _transactions.removeWhere((tx) => 
        tx.category == 'no_spend' && 
        tx.date.year == t.date.year && 
        tx.date.month == t.date.month && 
        tx.date.day == t.date.day
      );
    }
    _transactions.insert(0, t);
    _storage.saveTransactions(_transactions);
    onTransactionsChanged?.call();
    notifyListeners();
    _fireConditionalNotifications();
  }

  void addNoSpendTransaction(Transaction t) {
    _transactions.removeWhere((tx) => 
      tx.category == 'no_spend' && 
      tx.date.year == t.date.year && 
      tx.date.month == t.date.month && 
      tx.date.day == t.date.day
    );
    _transactions.insert(0, t);
    _storage.saveTransactions(_transactions);
    onTransactionsChanged?.call();
    _fireConditionalNotifications();
    notifyListeners();
    // No-spend day recorded — prompt the user
    NotificationService().showNoSpendCasual();
  }

  void deleteTransaction(Transaction t) {
    _transactions.remove(t);
    _storage.saveTransactions(_transactions);
    onTransactionsChanged?.call();
    _fireConditionalNotifications();
    notifyListeners();
  }

  void editTransaction(Transaction oldT, Transaction newT) {
    final index = _transactions.indexWhere((t) => t.id == oldT.id);
    if (index != -1) {
      _transactions[index] = newT;
      _storage.saveTransactions(_transactions);
      onTransactionsChanged?.call();
      _fireConditionalNotifications();
      notifyListeners();
    }
  }

  void toggleFavorite(Transaction t) {
    final index = _transactions.indexWhere((tx) => tx.id == t.id);
    if (index != -1) {
      _transactions[index].isFavorite = !_transactions[index].isFavorite;
      _storage.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  void updateTransactionsCategoryName(String oldName, String newName) {
    bool hasChanges = false;
    for (var i = 0; i < _transactions.length; i++) {
      if (_transactions[i].category == oldName) {
        _transactions[i].category = newName;
        if (_transactions[i].title == oldName) {
          _transactions[i].title = newName;
        }
        hasChanges = true;
      }
    }
    for (var i = 0; i < _shadowTransactions.length; i++) {
      if (_shadowTransactions[i].category == oldName) {
        _shadowTransactions[i].category = newName;
        if (_shadowTransactions[i].title == oldName) {
          _shadowTransactions[i].title = newName;
        }
        hasChanges = true;
      }
    }
    if (hasChanges) {
      _storage.saveTransactions(_transactions);
      _storage.saveShadowTransactions(_shadowTransactions);
      onTransactionsChanged?.call();
      notifyListeners();
    }
  }

  Future<void> updateCategoriesState(List<CategoryModel> newCategories) async {
    _categories = newCategories;
    await _storage.saveCategories(newCategories);
    notifyListeners();
  }

  // --- GÖLGE İŞLEMLER (Shadow) ---
  void addShadowTransaction(ShadowTransaction t) {
    _shadowTransactions.insert(0, t);
    _storage.saveShadowTransactions(_shadowTransactions);
    onTransactionsChanged?.call();
    notifyListeners();
  }

  void deleteShadowTransaction(ShadowTransaction t) {
    _shadowTransactions.remove(t);
    _storage.saveShadowTransactions(_shadowTransactions);
    onTransactionsChanged?.call();
    notifyListeners();
  }

  void toggleShadowFavorite(ShadowTransaction t) {
    final index = _shadowTransactions.indexOf(t);
    if (index != -1) {
      _shadowTransactions[index].isFavorite =
          !_shadowTransactions[index].isFavorite;
      _storage.saveShadowTransactions(_shadowTransactions);
      notifyListeners();
    }
  }

  void editShadowTransaction(ShadowTransaction oldT, ShadowTransaction newT) {
    final index = _shadowTransactions.indexOf(oldT);
    if (index != -1) {
      _shadowTransactions[index] = newT;
      _storage.saveShadowTransactions(_shadowTransactions);
      onTransactionsChanged?.call();
      notifyListeners();
    }
  }

  // --- AYARLAR VE HEDEFLER ---
  void updateDailyGoal(double newGoal) {
    _dailyGoal = newGoal;
    _saveSettings();
    notifyListeners();
  }

  void updateSalaryAndHours(double salary, double hours) {
    _salary = salary;
    _weeklyHours = hours;
    _saveSettings();
    notifyListeners();
  }

  void updateShadowGoal(String name, double amount) {
    _shadowGoalName = name;
    _shadowGoalAmount = amount;
    _saveSettings();
    notifyListeners();
  }

  void updateInitialBalance(double balance) {
    _initialBalance = balance;
    _saveSettings();
    notifyListeners();
  }

  // Update logic for independent time value
  void updateTimeValueMetrics(double salary, double hours) {
    _timeValueSalary = salary;
    _timeValueHours = hours;
    _storage.saveTimeValueMetrics(salary, hours);
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _storage.saveSettings(
      dailyGoal: _dailyGoal,
      salary: _salary,
      weeklyHours: _weeklyHours,
      shadowGoalName: _shadowGoalName,
      shadowGoalAmount: _shadowGoalAmount,
      initialBalance: _initialBalance,
    );
  }

  void resetShadowGoal() {
    _shadowGoalName = "Hedef";
    _shadowGoalAmount = 20000.0;
    _dailyGoal = 500.0;
    _saveSettings();
    notifyListeners();
  }

  void addBonusIncome(double amount, String title, String category) {
    // Instead of increasing _initialBalance directly, we add an income transaction.
    // The currentBalance getter already handles (initialBalance + totalIncome - totalSpent).
    final t = Transaction(
      title: title,
      amount: amount,
      emotion: 'none',
      necessity: 'none',
      date: DateTime.now(),
      category: category,
      type: 'income',
    );
    addTransaction(t);
  }

  // -----------------------------------------------------------------------
  // Conditional notification logic
  // -----------------------------------------------------------------------

  /// Checks current streak and today's spending; fires appropriate notification.
  Future<void> _fireConditionalNotifications() async {
    final notif = NotificationService();
    await notif.ensureInitialized();
    final streak = currentStreak;

    // 1. Streak milestone
    if (notif.isMilestone(streak)) {
      notif.showStreakMilestone(streak);
      return; // Only one conditional notification per action
    }

    // 2. Today's total — check if limit is kept or if prompt is needed
    final now = DateTime.now();
    double todayTotal = 0.0;
    bool todayHasRealSpend = false;
    bool todayHasNoSpend = false;

    for (final tx in _transactions) {
      final isToday = tx.date.year == now.year &&
          tx.date.month == now.month &&
          tx.date.day == now.day;
      if (!isToday) { continue; }
      if (tx.category == 'no_spend') {
        todayHasNoSpend = true;
        continue;
      }
      if (tx.necessity == 'necessity' ||
          tx.necessity == 'obligation' ||
          tx.necessity == 'zorunluluk') { continue; }
      
      todayTotal += tx.amount;
      todayHasRealSpend = true;
    }

    // 3. Evening Motivational Notifications (Scheduled)
    
    // A. Daily Limit Kept Notification (ID 14 at 21:00)
    if (todayTotal <= _dailyGoal) {
      // If we are under limit (even if 0 spend), schedule for 21:00
      notif.scheduleDailyLimitKept();
    } else {
      // Over limit — cancel tonight's success message
      notif.cancelDailyLimitKept();
    }

    // B. No Spend Prompt (ID 13 at 23:30)
    if (!todayHasRealSpend && !todayHasNoSpend) {
      // No spend recorded yet AND no "no spend" marker — prompt user at 23:30 to mark it
      notif.scheduleNoSpendPrompt();
    } else {
      // Money was spent OR already marked as no-spend — prompt is invalid/unnecessary
      notif.cancelNoSpendPrompt();
    }
  }
}
