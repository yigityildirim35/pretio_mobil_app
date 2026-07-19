import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goals_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class GoalsSettingsSheet extends StatefulWidget {
  const GoalsSettingsSheet({super.key});

  @override
  State<GoalsSettingsSheet> createState() => _GoalsSettingsSheetState();
}

class _GoalsSettingsSheetState extends State<GoalsSettingsSheet> {
  late TextEditingController _dailyController;
  late TextEditingController _monthlyController;
  late double _baseDistributableBalance;
  late double _displayDistributableBalance;
  late int _daysInMonth;

  bool _isUpdatingFromCode = false;

  @override
  void initState() {
    super.initState();
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );

    _baseDistributableBalance = goalsProvider.distributableBalance;
    _displayDistributableBalance = currencyProvider.convertFromBase(
      _baseDistributableBalance,
      currencyProvider.currency,
    );

    final now = DateTime.now();
    _daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final initialDaily = currencyProvider.convertFromBase(
      goalsProvider.dailySpendingLimit,
      currencyProvider.currency,
    );
    final initialMonthly = currencyProvider.convertFromBase(
      goalsProvider.monthlyTargetSavings,
      currencyProvider.currency,
    );

    _dailyController = TextEditingController(
      text: initialDaily.toStringAsFixed(0),
    );
    _monthlyController = TextEditingController(
      text: initialMonthly.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _dailyController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _onDailyChanged(String val) {
    if (_isUpdatingFromCode) return;

    final amount = double.tryParse(val) ?? 0.0;

    // Calculate new monthly target in display currency
    final newMonthly = _displayDistributableBalance - (amount * _daysInMonth);

    _isUpdatingFromCode = true;
    _monthlyController.text = newMonthly.toStringAsFixed(0);
    _isUpdatingFromCode = false;

    // Save to provider
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );
    goalsProvider.updateDailySpendingLimit(
      currencyProvider.convertToBase(amount, currencyProvider.currency),
    );
  }

  void _onMonthlyChanged(String val) {
    if (_isUpdatingFromCode) return;

    final amount = double.tryParse(val) ?? 0.0;

    // Calculate new daily limit in display currency
    final remainingForDaily = _displayDistributableBalance - amount;
    final newDaily = remainingForDaily > 0
        ? remainingForDaily / _daysInMonth
        : 0.0;

    _isUpdatingFromCode = true;
    _dailyController.text = newDaily.toStringAsFixed(0);
    _isUpdatingFromCode = false;

    // Save to provider
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );
    goalsProvider.updateMonthlyTargetSavings(
      currencyProvider.convertToBase(amount, currencyProvider.currency),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.goalUpdateGoalsTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 1. Balance (Read-only)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.balance,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  currencyProvider.getDisplayValue(_baseDistributableBalance),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Daily Limit
          _buildGoalInputField(
            context: context,
            label: AppLocalizations.of(context)!.goalDailyLimit,
            controller: _dailyController,
            currency: currencyProvider.currency,
            onChanged: _onDailyChanged,
          ),
          const SizedBox(height: 16),

          // 3. Monthly Target
          _buildGoalInputField(
            context: context,
            label: AppLocalizations.of(context)!.goalMonthlySavingsTarget,
            controller: _monthlyController,
            currency: currencyProvider.currency,
            onChanged: _onMonthlyChanged,
          ),

          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            decoration: Provider.of<ThemeProvider>(context).is3DEnabled
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.done,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String currency,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.normal,
        ),
        suffixText: currency,
        suffixStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.cardColor,
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
