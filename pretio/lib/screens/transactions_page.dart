import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../models/transaction.dart';
import '../models/category_model.dart';
import '../widgets/transaction_item.dart';
import '../providers/transaction_provider.dart';

class TransactionsPage extends StatelessWidget {
  final List<CategoryModel> categories;

  const TransactionsPage({super.key, required this.categories});

  Map<String, List<Transaction>> _groupTransactions(
    List<Transaction> txs,
    BuildContext context,
  ) {
    final Map<String, List<Transaction>> groups = {};
    for (var t in txs) {
      final dateParams = DateTime(t.date.year, t.date.month, t.date.day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      String header;
      if (dateParams == today) {
        header = AppLocalizations.of(context)!.today;
      } else if (dateParams == yesterday) {
        header = AppLocalizations.of(context)!.yesterday;
      } else {
        header = '${t.date.day}/${t.date.month}/${t.date.year}';
      }

      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(t);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // Sort transactions by date descending
          final sortedTxs = [...provider.transactions]
            ..sort((a, b) => b.date.compareTo(a.date));
            
          final favoriteTxs = sortedTxs.where((t) => t.isFavorite).toList();

          final groupedAll = _groupTransactions(sortedTxs, context);
          final groupedFavorites = _groupTransactions(favoriteTxs, context);

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.transactionHistory),
              bottom: TabBar(
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.all),
                  Tab(text: AppLocalizations.of(context)!.favorites),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildListView(groupedAll, provider, context),
                _buildListView(groupedFavorites, provider, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(Map<String, List<Transaction>> grouped, TransactionProvider provider, BuildContext context) {
    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey.withAlpha(80)),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noRecordsToday, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final header = grouped.keys.elementAt(index);
        final txs = grouped[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                header,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...txs.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                child: TransactionItem(
                  transaction: t,
                  categories: categories,
                  onDelete: provider.deleteTransaction,
                  onEdit: provider.editTransaction,
                  onToggleFavorite: provider.toggleFavorite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
