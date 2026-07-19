import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../models/transaction.dart';
import '../services/local_storage_service.dart';
import 'transaction_provider.dart';
import 'currency_provider.dart';

class SubscriptionProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  List<Subscription> _subscriptions = [];
  bool _isLoading = true;

  // Callback to trigger external state updates (like badge evaluation)
  VoidCallback? onSubscriptionsChanged;

  List<Subscription> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;

  Future<void> loadSubscriptions() async {
    _isLoading = true;
    final subs = await _storage.loadSubscriptions();
    _subscriptions = subs;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    await _storage.saveSubscriptions(_subscriptions);
  }

  Future<void> addSubscription(Subscription subscription) async {
    _subscriptions.add(subscription);
    await _saveToStorage();
    onSubscriptionsChanged?.call();
    notifyListeners();
  }

  Future<void> updateSubscription(
    String id,
    Subscription newSubscription,
  ) async {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _subscriptions[index] = newSubscription;
      await _saveToStorage();
      onSubscriptionsChanged?.call();
      notifyListeners();
    }
  }

  Future<void> deleteSubscription(String id) async {
    _subscriptions.removeWhere((s) => s.id == id);
    await _saveToStorage();
    onSubscriptionsChanged?.call();
    notifyListeners();
  }

  Future<void> processDueSubscriptions(
    TransactionProvider txProvider,
    CurrencyProvider currProvider,
  ) async {
    if (_subscriptions.isEmpty) return;

    final now = DateTime.now();
    final currentMonthYear = "${now.month}-${now.year}";
    bool updated = false;

    for (int i = 0; i < _subscriptions.length; i++) {
      final sub = _subscriptions[i];

      int? billingDay;
      try {
        final parts = sub.date.split('.');
        if (parts.isNotEmpty) {
          billingDay = int.parse(parts[0]);
        }
      } catch (_) {}
      billingDay ??= 1;

      if (now.day >= billingDay) {
        if (sub.lastBilledDate != currentMonthYear) {
          // sub.price is now assumed to be in the Base Currency (TRY)
          final baseAmount = double.tryParse(sub.price) ?? 0.0;

          final transaction = Transaction(
            title: sub.name,
            amount: baseAmount,
            emotion: sub.emotion,
            necessity: sub.necessity,
            date: DateTime(now.year, now.month, billingDay),
            category: 'Abonelik',
            note: 'Otomatik Yenileme',
            logoUrl: sub.logoUrl, // Pass custom icon url
          );

          txProvider.addTransaction(transaction);

          _subscriptions[i] = sub.copyWith(lastBilledDate: currentMonthYear);
          updated = true;
        }
      }
    }

    if (updated) {
      await _saveToStorage();
      onSubscriptionsChanged?.call();
      notifyListeners();
    }
  }
}
