import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/budget_ring.dart';
import '../widgets/quick_entry_card.dart';
import '../widgets/recent_activity_section.dart';
import '../services/local_storage_service.dart';
import '../models/category_model.dart';
import '../widgets/category_creation_dialog.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/goals_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/goals_settings_sheet.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/animated_amount.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedEmotion = 'none';
  String selectedNecessity = 'none';
  String selectedCategory = '';
  String? _currentNote; // New state for note
  String selectedType = 'expense'; // 'expense' or 'income'
  final ValueNotifier<String> selectedCategoryNotifier = ValueNotifier<String>(
    '',
  );
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  final LocalStorageService _storage = LocalStorageService();
  List<double> quickAmounts = [];
  DateTime _selectedDate = DateTime.now();

  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runBackgroundEngines();
    });
  }





  Future<void> _runBackgroundEngines() async {
    final txProvider = Provider.of<TransactionProvider>(context, listen: false);
    final currProvider = Provider.of<CurrencyProvider>(context, listen: false);
    final subProvider = Provider.of<SubscriptionProvider>(
      context,
      listen: false,
    );
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    // Give providers a small delay to ensure initial loadData from storage completes
    await Future.delayed(const Duration(milliseconds: 500));

    // Wait for sub provider data exactly
    await subProvider.loadSubscriptions();

    if (!mounted) return;

    await subProvider.processDueSubscriptions(txProvider, currProvider);

    // Ensure the profileprovider evaluates correctly to begin with.
    profileProvider.evaluateBadges(txProvider, subProvider);

    // Register real-time sync for any future transaction/subscription modifications.
    // Ensure we do not assign it multiple times
    txProvider.onTransactionsChanged = () {
      profileProvider.evaluateBadges(txProvider, subProvider);
    };

    subProvider.onSubscriptionsChanged = () {
      profileProvider.evaluateBadges(txProvider, subProvider);
    };
  }

  Future<void> _loadData() async {
    final amts = await _storage.loadQuickAmounts();

    if (mounted) {
      setState(() {
        quickAmounts = amts;
      });
    }
  }

  void _handleSave() {
    if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
      final currencyProvider = Provider.of<CurrencyProvider>(
        context,
        listen: false,
      );
      final enteredAmount = double.tryParse(amountController.text) ?? 0.0;
      if (enteredAmount < 0.01) return; // Prevent practically zero price
      final baseAmount = currencyProvider.convertToBase(
        enteredAmount,
        currencyProvider.currency,
      );

      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      
      final t = Transaction(
        title: titleController.text,
        amount: baseAmount,
        emotion: themeProvider.isEmotionModuleEnabled ? selectedEmotion : 'none',
        necessity: themeProvider.isNeedWantModuleEnabled ? selectedNecessity : 'none',
        date: _selectedDate,
        category: selectedCategoryNotifier.value.isNotEmpty ? selectedCategoryNotifier.value : 'Kategorilendirilmemiş',
        note: _currentNote, // Include note
        type: selectedType, // Add transaction type
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(t);

      titleController.clear();
      amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _currentNote = null; // Clear note
      });
      FocusScope.of(context).unfocus();
    }
  }

  double _getTodaySpent(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == 'expense' &&
              t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day &&
              t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk',
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void _showAddQuickAmountDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addQuickAmount),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: Provider.of<CurrencyProvider>(
              context,
              listen: false,
            ).currency,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final val = double.tryParse(controller.text);
              if (val != null && !quickAmounts.contains(val)) {
                final newAmounts = [...quickAmounts, val];
                newAmounts.sort();
                await _storage.saveQuickAmounts(newAmounts);
                setState(() => quickAmounts = newAmounts);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showEditQuickAmountDialog(double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editAmount(amount)),
        content: Text(AppLocalizations.of(context)!.deleteAmountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final newAmounts = quickAmounts
                  .where((a) => a != amount)
                  .toList();
              await _storage.saveQuickAmounts(newAmounts);
              setState(() => quickAmounts = newAmounts);
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _handleReorderCategories(int oldIndex, int newIndex) async {
    final txProvider = Provider.of<TransactionProvider>(context, listen: false);
    final newCategories = List<CategoryModel>.from(txProvider.categories);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = newCategories.removeAt(oldIndex);
    newCategories.insert(newIndex, item);
    await txProvider.updateCategoriesState(newCategories);
  }

  void _handleDeleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.deleteCategoryTitle(category.name),
        ),
        content: Text(AppLocalizations.of(context)!.deleteCategoryContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final txProvider = Provider.of<TransactionProvider>(context, listen: false);
              final newCategories = List<CategoryModel>.from(txProvider.categories);
              newCategories.removeWhere((c) => c.id == category.id);

              setState(() {
                if (selectedCategory == category.name) {
                  selectedCategory = '';
                  selectedCategoryNotifier.value = '';
                  titleController.clear();
                }
              });
              await txProvider.updateCategoriesState(newCategories);
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _handleEditCategory(CategoryModel oldCategory) {
    showDialog(
      context: context,
      builder: (context) => CategoryCreationDialog(
        initialCategory: oldCategory,
        onCategoryCreated: (newCategory) async {
          final txProvider = Provider.of<TransactionProvider>(context, listen: false);
          final newCategories = List<CategoryModel>.from(txProvider.categories);
          final index = newCategories.indexWhere((c) => c.id == oldCategory.id);
          if (index != -1) {
            newCategories[index] = newCategory;
          }

          setState(() {
            if (selectedCategory == oldCategory.name) {
              selectedCategory = newCategory.name;
              selectedCategoryNotifier.value = newCategory.name;
              if (titleController.text == oldCategory.name) {
                titleController.text = newCategory.name;
              }
            }
          });
          await txProvider.updateCategoriesState(newCategories);
          
          if (oldCategory.name != newCategory.name) {
            final txProvider = Provider.of<TransactionProvider>(context, listen: false);
            txProvider.updateTransactionsCategoryName(oldCategory.name, newCategory.name);
          }
        },
      ),
    );
  }

  Map<String, double> _getTodayBreakdown(List<Transaction> transactions) {
    final now = DateTime.now();
    final todayTx = transactions.where(
      (t) =>
          t.type == 'expense' &&
          t.date.year == now.year &&
          t.date.month == now.month &&
          t.date.day == now.day,
    );
    double needs = 0;
    double wants = 0;
    for (var t in todayTx) {
      if (t.necessity == 'need') {
        needs += t.amount;
      } else if (t.necessity == 'want' || t.necessity == 'none') {
        wants += t.amount;
      }
    }
    return {'needs': needs, 'wants': wants};
  }


  Widget _buildMiniSummaryAndStreak(
    bool isOverBudget,
    Map<String, double> breakdown,
    CurrencyProvider currencyProvider,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // MINI SUMMARY (3 Columns)
          Row(
            children: [
              // NEEDS
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.needs.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedAmount(
                      amount: breakdown['needs']!,
                      formatter: (val) => currencyProvider.getDisplayValue(val),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // DIVIDER 1
              Container(
                height: 30,
                width: 1,
                color: Colors.grey.withValues(alpha: 0.2), // Subtle divider
              ),
              // TOTAL
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedAmount(
                      amount: breakdown['needs']! + breakdown['wants']!,
                      formatter: (val) => currencyProvider.getDisplayValue(val),
                      style: TextStyle(
                        fontSize: 18, // Slightly bigger
                        fontWeight: FontWeight.w900, // Bolder
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              // DIVIDER 2
              Container(
                height: 30,
                width: 1,
                color: Colors.grey.withValues(alpha: 0.2), // Subtle divider
              ),
              // WANTS
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.wants.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedAmount(
                      amount: breakdown['wants']!,
                      formatter: (val) => currencyProvider.getDisplayValue(val),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Use Selector for CustomAppBar to only rebuild when streaks or budget status change
              Selector<TransactionProvider, Map<String, dynamic>>(
                selector: (context, provider) => {
                  'currentStreak': provider.currentStreak,
                  'longestStreak': provider.longestStreak,
                },
                builder: (context, data, child) {
                  return Selector<GoalsProvider, bool>(
                    selector: (context, goalsProvider) {
                      final transactions = Provider.of<TransactionProvider>(context, listen: false).transactions;
                      final todaySpent = _getTodaySpent(transactions);
                      return (goalsProvider.dailySpendingLimit - todaySpent) < 0;
                    },
                    builder: (context, isOverBudget, child) {
                      return CustomAppBar(
                        currentStreak: data['currentStreak'] as int,
                        longestStreak: data['longestStreak'] as int,
                        isOverBudget: isOverBudget,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              // Use Selector for BudgetRing
              Consumer2<GoalsProvider, TransactionProvider>(
                builder: (context, goalsProvider, txProvider, child) {
                  final dailyGoal = goalsProvider.dailySpendingLimit;
                  final todaySpent = _getTodaySpent(txProvider.transactions);
                  final remaining = dailyGoal - todaySpent;
                  return BudgetRing(
                    remaining: remaining,
                    goal: dailyGoal,
                    onGoalTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const GoalsSettingsSheet(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              // Use Selector for MiniSummary
              Consumer3<GoalsProvider, TransactionProvider, CurrencyProvider>(
                builder: (context, goalsProvider, txProvider, currencyProvider, child) {
                  final todaySpent = _getTodaySpent(txProvider.transactions);
                  final isOverBudget = (goalsProvider.dailySpendingLimit - todaySpent) < 0;
                  final breakdown = _getTodayBreakdown(txProvider.transactions);
                  return _buildMiniSummaryAndStreak(isOverBudget, breakdown, currencyProvider);
                },
              ),
              const SizedBox(height: 24),
              // Use Consumer for QuickEntryCard
              Selector<TransactionProvider, List<CategoryModel>>(
                selector: (context, provider) => provider.categories,
                builder: (context, categories, child) {
                  return QuickEntryCard(
                    titleController: titleController,
                    amountController: amountController,
                    selectedEmotion: selectedEmotion,
                    selectedNecessity: selectedNecessity,
                    selectedCategory: selectedCategory,
                    selectedCategoryNotifier: selectedCategoryNotifier,
                    categories: categories,
                    quickAmounts: quickAmounts,
                    selectedType: selectedType,
                    onTypeChanged: (val) => setState(() => selectedType = val),
                    onEmotionChanged: (val) => setState(() => selectedEmotion = val),
                    onNecessityChanged: (val) => setState(() => selectedNecessity = val),
                    onCategoryChanged: (val) {
                      selectedCategoryNotifier.value = val;
                      if (val == 'General') {
                        titleController.clear();
                      } else {
                        titleController.text = val;
                      }
                    },
                    onSave: _handleSave,
                    onAddCategory: () {
                      showDialog(
                        context: context,
                        builder: (context) => CategoryCreationDialog(
                          onCategoryCreated: (newCategory) async {
                            final txProvider = Provider.of<TransactionProvider>(context, listen: false);
                            final newCategories = [
                              ...txProvider.categories,
                              newCategory,
                            ];
                            await txProvider.updateCategoriesState(newCategories);
                            setState(() {
                              selectedCategory = newCategory.name;
                              titleController.text = newCategory.name;
                            });
                          },
                        ),
                      );
                    },
                onReorderCategory: _handleReorderCategories,
                onDeleteCategory: _handleDeleteCategory,
                onEditCategory: _handleEditCategory,
                onAddAmount: _showAddQuickAmountDialog,
                onLongPressAmount: _showEditQuickAmountDialog,
                selectedDate: _selectedDate,
                onDateTap: () async {
                  final date = await showDialog<DateTime>(
                    context: context,
                    builder: (context) => CustomDatePicker(
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                note: _currentNote,
                onNoteChanged: (val) => setState(() => _currentNote = val),
                 onNoSpend: () {
                   HapticFeedback.selectionClick();
                   
                   final txProvider = Provider.of<TransactionProvider>(context, listen: false);
                   final hasRealTransactions = txProvider.transactions.any((tx) => 
                     tx.category != 'no_spend' && 
                     tx.date.year == _selectedDate.year &&
                     tx.date.month == _selectedDate.month &&
                     tx.date.day == _selectedDate.day
                   );

                   if (hasRealTransactions) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                           content: Text(AppLocalizations.of(context)!.noSpendToast),
                           duration: const Duration(seconds: 2),
                       ),
                     );
                     return;
                   }

                   final t = Transaction(
                     title: AppLocalizations.of(context)!.noSpendTitle,
                     amount: 0.0,
                     emotion: 'none',
                     necessity: 'none',
                     date: _selectedDate,
                     category: 'no_spend',
                     note: AppLocalizations.of(context)!.noSpendNote,
                   );
                   txProvider.addNoSpendTransaction(t);
                   setState(() {
                     _selectedDate = DateTime.now();
                     _currentNote = null;
                   });
                 },
              );
            },
          ),
          const SizedBox(height: 24),
              // Use Consumer for RecentActivitySection
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  return RecentActivitySection(
                    transactions: provider.transactions,
                    categories: provider.categories,
                    onDelete: provider.deleteTransaction,
                    onEdit: provider.editTransaction,
                    onToggleFavorite: provider.toggleFavorite,
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }


}
