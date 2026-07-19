import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category_model.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../screens/transactions_page.dart';
import 'transaction_item.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class RecentActivitySection extends StatelessWidget {
  final List<Transaction> transactions;
  final List<CategoryModel> categories;
  final Function(Transaction) onDelete;
  final Function(Transaction, Transaction) onEdit;
  final Function(Transaction) onToggleFavorite;

  const RecentActivitySection({
    super.key,
    required this.transactions,
    required this.categories,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to CurrencyProvider to trigger rebuild when currency changes
    Provider.of<CurrencyProvider>(context);
    final displayedTransactions = transactions.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.recentActivity,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionsPage(categories: categories),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.viewAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (displayedTransactions.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context)!.noRecentActivity),
            )
          else
            ...displayedTransactions.map((t) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TransactionItem(
                  transaction: t,
                  categories: categories,
                  onDelete: onDelete,
                  onEdit: onEdit,
                  onToggleFavorite: onToggleFavorite,
                ),
              );
            }),
        ],
      ),
    );
  }
}
