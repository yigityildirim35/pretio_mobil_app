import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/category_model.dart';
import '../models/subscription.dart';
import '../models/user_badge_progress.dart';
import 'package:flutter/material.dart'; // For Colors and Icons

class LocalStorageService {
  static const String _transactionsKey = 'transactions_v1';
  static const String _shadowTransactionsKey = 'shadow_transactions_v1';
  static const String _dailyGoalKey = 'daily_goal_v1';
  static const String _salaryKey = 'salary_v1';
  static const String _weeklyHoursKey = 'weekly_hours_v1';
  static const String _shadowGoalNameKey = 'shadow_goal_name_v1';
  static const String _shadowGoalAmountKey = 'shadow_goal_amount_v1';
  static const String _initialBalanceKey = 'initial_balance_v1';
  static const String _categoriesKey = 'categories_v1';
  static const String _quickAmountsKey = 'quick_amounts_v1';
  static const String _themeKey = 'theme_mode_v1';
  static const String _streakKey = 'streak_v1';
  static const String _lastLoginKey = 'last_login_v1';
  static const String _currencyKey = 'currency_code_v1';
  static const String _subscriptionsKey = 'subscriptions_v1';
  static const String _badgesKey = 'badges_v1';

  // Goals logic keys
  static const String _goalsDailyLimitKey = 'goals_daily_limit_v1';
  static const String _goalsMonthlyTargetKey = 'goals_monthly_target_v1';
  static const String _goalsBigSavingsKey = 'goals_big_savings_v1';
  static const String _goalsSpentTodayKey = 'goals_spent_today_v1';
  static const String _goalsLastProcessedDateKey =
      'goals_last_processed_date_v1';
  static const String _timeValueSalaryKey = 'time_value_salary_v1';
  static const String _timeValueHoursKey = 'time_value_hours_v1';

  Future<void> saveBadges(List<UserBadgeProgress> badges) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(badges.map((b) => b.toJson()).toList());
    await prefs.setString(_badgesKey, encoded);
  }

  Future<List<UserBadgeProgress>> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_badgesKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((json) => UserBadgeProgress.fromJson(json)).toList();
  }

  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      subscriptions.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_subscriptionsKey, encoded);
  }

  Future<List<Subscription>> loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_subscriptionsKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((json) => Subscription.fromJson(json)).toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_transactionsKey, encoded);
  }

  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_transactionsKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<void> saveShadowTransactions(
    List<ShadowTransaction> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_shadowTransactionsKey, encoded);
  }

  Future<List<ShadowTransaction>> loadShadowTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_shadowTransactionsKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((json) => ShadowTransaction.fromJson(json)).toList();
  }

  Future<void> saveSettings({
    required double dailyGoal,
    required double salary,
    required double weeklyHours,
    String shadowGoalName = "Hedef",
    double shadowGoalAmount = 20000.0,
    double initialBalance = 20000.0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_dailyGoalKey, dailyGoal);
    await prefs.setDouble(_salaryKey, salary);
    await prefs.setDouble(_weeklyHoursKey, weeklyHours);
    await prefs.setString(_shadowGoalNameKey, shadowGoalName);
    await prefs.setDouble(_shadowGoalAmountKey, shadowGoalAmount);
    await prefs.setDouble(_initialBalanceKey, initialBalance);
  }

  Future<void> saveTimeValueMetrics(double salary, double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_timeValueSalaryKey, salary);
    await prefs.setDouble(_timeValueHoursKey, hours);
  }

  Future<Map<String, double>> loadTimeValueMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'salary': prefs.getDouble(_timeValueSalaryKey) ?? 25000.0,
      'hours': prefs.getDouble(_timeValueHoursKey) ?? 40.0,
    };
  }

  Future<void> saveInitialBalance(double val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_initialBalanceKey, val);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'dailyGoal': prefs.getDouble(_dailyGoalKey) ?? 500.0,
      'salary': prefs.getDouble(_salaryKey) ?? 25000.0,
      'weeklyHours': prefs.getDouble(_weeklyHoursKey) ?? 40.0,
      'shadowGoalName': prefs.getString(_shadowGoalNameKey) ?? "Hedef",
      'shadowGoalAmount': prefs.getDouble(_shadowGoalAmountKey) ?? 20000.0,
      'initialBalance': prefs.getDouble(_initialBalanceKey) ?? 20000.0,
    };
  }

  // Goals Specific Data
  Future<void> saveGoalsConfiguration({
    required double dailyLimit,
    required double monthlyTarget,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_goalsDailyLimitKey, dailyLimit);
    await prefs.setDouble(_goalsMonthlyTargetKey, monthlyTarget);
  }

  Future<void> saveGoalsDailyState({
    required double spentToday,
    required double bigGoalSavings,
    required String lastProcessedDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_goalsSpentTodayKey, spentToday);
    await prefs.setDouble(_goalsBigSavingsKey, bigGoalSavings);
    await prefs.setString(_goalsLastProcessedDateKey, lastProcessedDate);
  }

  Future<Map<String, dynamic>> loadGoalsData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'dailyLimit': prefs.getDouble(_goalsDailyLimitKey) ?? 0.0,
      'monthlyTarget': prefs.getDouble(_goalsMonthlyTargetKey) ?? 0.0,
      'bigGoalSavings': prefs.getDouble(_goalsBigSavingsKey) ?? 0.0,
      'spentToday': prefs.getDouble(_goalsSpentTodayKey) ?? 0.0,
      'lastProcessedDate': prefs.getString(_goalsLastProcessedDateKey),
    };
  }

  // Currency
  Future<void> saveCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
  }

  Future<String> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'TL';
  }

  // Categories
  Future<void> saveCategories(List<CategoryModel> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      categories.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_categoriesKey, encoded);
  }

  Future<List<CategoryModel>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_categoriesKey);
    if (encoded == null) {
      return _defaultCategories;
    }
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((json) => CategoryModel.fromJson(json)).toList();
  }

  // Quick Amounts
  Future<void> saveQuickAmounts(List<double> amounts) async {
    final prefs = await SharedPreferences.getInstance();
    // Sort before saving
    amounts.sort();
    final String encoded = jsonEncode(amounts);
    await prefs.setString(_quickAmountsKey, encoded);
  }

  Future<List<double>> loadQuickAmounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_quickAmountsKey);
    if (encoded == null) {
      return [50.0, 100.0, 200.0, 500.0]; // Defaults
    }
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((e) => (e as num).toDouble()).toList();
  }

  // Theme
  Future<void> saveThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, index);
  }

  Future<int?> loadThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    // Migrating from bool: if it's a bool true, load 1. If bool false, load 0.
    final dynamic val = prefs.get(_themeKey);
    if (val is bool) {
      return val ? 1 : 0;
    }
    return val as int?;
  }

  // Streak
  Future<void> saveStreak(int streak, String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastLoginKey, dateKey);
  }

  Future<Map<String, dynamic>> loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'streak': prefs.getInt(_streakKey) ?? 1,
      'lastLoginDate': prefs.getString(_lastLoginKey) ?? '',
    };
  }

  // Profile Data
  static const String _keyProfileName = 'profile_name';
  static const String _keySelectedAvatar = 'selected_avatar';
  static const String _keyPickedImagePath = 'picked_image_path';

  Future<void> saveProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileName, name);
  }

  Future<String?> getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileName);
  }

  Future<void> saveSelectedAvatar(String? assetPath) async {
    final prefs = await SharedPreferences.getInstance();
    if (assetPath == null) {
      await prefs.remove(_keySelectedAvatar);
    } else {
      await prefs.setString(_keySelectedAvatar, assetPath);
    }
  }

  Future<String?> getSelectedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedAvatar);
  }

  Future<void> savePickedImagePath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove(_keyPickedImagePath);
    } else {
      await prefs.setString(_keyPickedImagePath, path);
    }
  }

  Future<String?> getPickedImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPickedImagePath);
  }

  // Default Categories
  List<CategoryModel> get _defaultCategories => [
    CategoryModel(
      id: 'food',
      name: 'Food',
      iconCode: Icons.fastfood.codePoint,
      colorValue: Colors.orange.toARGB32(),
      isDefault: true,
    ),
    CategoryModel(
      id: 'transport',
      name: 'Transport',
      iconCode: Icons.directions_bus.codePoint,
      colorValue: Colors.blue.toARGB32(),
      isDefault: true,
    ),
    CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      iconCode: Icons.shopping_bag.codePoint,
      colorValue: Colors.pink.toARGB32(),
      isDefault: true,
    ),
    CategoryModel(
      id: 'entertainment',
      name: 'Fun',
      iconCode: Icons.movie.codePoint,
      colorValue: Colors.purple.toARGB32(),
      isDefault: true,
    ),
    CategoryModel(
      id: 'bills',
      name: 'Bills',
      iconCode: Icons.receipt.codePoint,
      colorValue: Colors.red.toARGB32(),
      isDefault: true,
    ),
    CategoryModel(
      id: 'other',
      name: 'Other',
      iconCode: Icons.more_horiz.codePoint,
      colorValue: Colors.grey.toARGB32(),
      isDefault: true,
    ),
  ];
  // Currency Rates
  static const String _currencyRatesKey = 'currency_rates_v2';
  static const String _ratesTimestampKey = 'currency_rates_timestamp_v2';

  Future<void> saveExchangeRates(Map<String, double> rates) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(rates);
    await prefs.setString(_currencyRatesKey, encoded);
    await prefs.setString(_ratesTimestampKey, DateTime.now().toIso8601String());
  }

  Future<Map<String, dynamic>> loadExchangeRates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_currencyRatesKey);
    final String? timestampStr = prefs.getString(_ratesTimestampKey);

    if (encoded == null || timestampStr == null) {
      return {};
    }

    final Map<String, dynamic> decoded = jsonDecode(encoded);
    final Map<String, double> rates = {};
    decoded.forEach((key, value) {
      rates[key] = (value as num).toDouble();
    });

    return {'rates': rates, 'timestamp': DateTime.parse(timestampStr)};
  }

  // Dashboard Panel Order
  static const String _panelOrderKey = 'dashboard_panel_order_v1';

  Future<void> savePanelOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_panelOrderKey, order);
  }

  Future<List<String>?> loadPanelOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_panelOrderKey);
  }

  // 3D View
  static const String _3dEnabledKey = 'settings_3d_enabled_v1';

  Future<void> save3DEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_3dEnabledKey, enabled);
  }

  Future<bool> load3DEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_3dEnabledKey) ?? false;
  }
  Future<void> saveBoolSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> loadBoolSetting(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
