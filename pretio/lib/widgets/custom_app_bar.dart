import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final bool isOverBudget;

  const CustomAppBar({
    super.key,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.isOverBudget = false,
  });

  void _showBalanceOptionsDialog(
    BuildContext context,
    TransactionProvider provider,
    CurrencyProvider currencyProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.accountActions,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.addIncome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(AppLocalizations.of(context)!.addIncomeDesc),
              onTap: () {
                Navigator.pop(context);
                _showAddIncomeDialog(context, provider, currencyProvider);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.blue),
              title: Text(AppLocalizations.of(context)!.editTotalBalance),
              subtitle: Text(AppLocalizations.of(context)!.resetInitialBalance),
              onTap: () {
                Navigator.pop(context);
                _showEditBalanceDialog(context, provider, currencyProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIncomeDialog(
    BuildContext context,
    TransactionProvider provider,
    CurrencyProvider currencyProvider,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.addIncome),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterAmount,
            suffixText: currencyProvider.currency,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val >= 0.01) {
                final baseAmount = currencyProvider.convertToBase(val, currencyProvider.currency);
                final l10n = AppLocalizations.of(context)!;
                provider.addBonusIncome(baseAmount, l10n.income, l10n.income);
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showEditBalanceDialog(
    BuildContext context,
    TransactionProvider provider,
    CurrencyProvider currencyProvider,
  ) {
    final displayValue = currencyProvider.convertFromBase(
      provider.initialBalance,
      currencyProvider.currency,
    );
    final controller = TextEditingController(
      text: displayValue.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.updateBalance),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(suffixText: currencyProvider.currency),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) {
                final baseBalance = currencyProvider.convertToBase(val, currencyProvider.currency);
                provider.updateInitialBalance(baseBalance);
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final currentBalance = transactionProvider.currentBalance;

    final currencyLabel = currencyProvider.currency == 'TL'
        ? 'TRY'
        : currencyProvider.currency;

    final langLabel =
        localeProvider.locale?.languageCode.toUpperCase() ?? 'EN';

    Widget buildDivider() => Container(
          width: 1,
          height: 26,
          color: theme.dividerColor.withValues(alpha: 0.18),
        );

    // A tappable chip: icon + value, no text label
    Widget buildChip({
      required Widget icon,
      required String value,
      VoidCallback? onTap,
      Color? valueColor,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 6),
                if (value.isNotEmpty)
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: valueColor ?? theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 1. Balance
          buildChip(
            icon: Icon(
              Icons.account_balance_wallet_rounded,
              size: 17,
              color: theme.colorScheme.primary,
            ),
            value: currencyProvider.getDisplayValue(currentBalance, compact: true),
            onTap: () => _showBalanceOptionsDialog(
              context,
              transactionProvider,
              currencyProvider,
            ),
          ),
          buildDivider(),

          // 2. Current streak
          buildChip(
            icon: Icon(
              Icons.local_fire_department,
              size: 17,
              color: isOverBudget ? Colors.red : Colors.orange,
            ),
            value: '$currentStreak',
          ),
          buildDivider(),

          // 3. Longest streak
          buildChip(
            icon: const Icon(Icons.emoji_events, size: 17, color: Colors.amber),
            value: '$longestStreak',
          ),
          buildDivider(),

          // 4. Currency selector
          Expanded(
            child: PopupMenuButton<String>(
              offset: const Offset(0, 44),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) => currencyProvider.setCurrency(value),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'TRY', child: Text('₺ (TRY)')),
                const PopupMenuItem(value: 'USD', child: Text('\$ (USD)')),
                const PopupMenuItem(value: 'EUR', child: Text('€ (EUR)')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          currencyLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildDivider(),

          // 5. Language selector
          Expanded(
            child: PopupMenuButton<String>(
              offset: const Offset(0, 44),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) =>
                  localeProvider.setLocale(Locale(value)),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'de', child: Text('🇩🇪 DE')),
                const PopupMenuItem(value: 'en', child: Text('🇺🇸 EN')),
                const PopupMenuItem(value: 'es', child: Text('🇪🇸 ES')),
                const PopupMenuItem(value: 'fr', child: Text('🇫🇷 FR')),
                const PopupMenuItem(value: 'tr', child: Text('🇹🇷 TR')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          langLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
