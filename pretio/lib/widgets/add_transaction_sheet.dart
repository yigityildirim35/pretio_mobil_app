import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../models/transaction.dart';

import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../services/local_storage_service.dart';
import 'quick_entry_card.dart';
import 'custom_date_picker.dart';

class AddTransactionSheet extends StatefulWidget {
  final DateTime? initialDate;

  const AddTransactionSheet({super.key, this.initialDate});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedEmotion = 'neutral';
  String _selectedNecessity = 'want';
  String _selectedCategory = 'General';
  String? _currentNote;
  String _selectedType = 'expense'; // 'expense' or 'income'
  final ValueNotifier<String> _selectedCategoryNotifier = ValueNotifier<String>(
    'General',
  );

  List<double> _quickAmounts = [];
  late DateTime _selectedDate;

  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    // Tarih Güvenliği: Gelen tarih bugünden sonraysa, bugüne çek.
    DateTime initial = widget.initialDate ?? DateTime.now();
    if (initial.isAfter(DateTime.now())) {
      initial = DateTime.now();
    }
    _selectedDate = initial;

    final txProvider = Provider.of<TransactionProvider>(context, listen: false);
    if (txProvider.categories.isNotEmpty) {
      _selectedCategory = txProvider.categories.first.name;
      _selectedCategoryNotifier.value = txProvider.categories.first.name;
    }

    _loadData();
  }

  Future<void> _loadData() async {
    final amts = await _storage.loadQuickAmounts();

    if (mounted) {
      setState(() {
        _quickAmounts = amts;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _selectedCategoryNotifier.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      final currencyProvider = Provider.of<CurrencyProvider>(
        context,
        listen: false,
      );
      final enteredAmount =
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      if (enteredAmount < 0.01) return; // Prevent practically zero price
      final baseAmount = currencyProvider.convertToBase(
        enteredAmount,
        currencyProvider.currency,
      );

      final t = Transaction(
        title: _titleController.text,
        amount: baseAmount,
        emotion: _selectedEmotion,
        necessity: _selectedNecessity,
        date: _selectedDate,
        category: _selectedCategoryNotifier.value,
        note: _currentNote,
        type: _selectedType,
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addTransaction(t);

      // İşlem bitince sheet'i kapat
      Navigator.pop(context);
    }
  }

  // --- Yardımcı Metodlar (Dashboard'dan uyarlandı) ---

  void _showAddQuickAmountDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final val = double.tryParse(controller.text);
              if (val != null) {
                final currencyProvider = Provider.of<CurrencyProvider>(
                  context,
                  listen: false,
                );
                final baseVal = currencyProvider.convertToBase(
                  val,
                  currencyProvider.currency,
                );

                if (!_quickAmounts.contains(baseVal)) {
                  final newAmounts = [..._quickAmounts, baseVal];
                  newAmounts.sort();
                  await _storage.saveQuickAmounts(newAmounts);
                  setState(() => _quickAmounts = newAmounts);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showEditQuickAmountDialog(double amount) {
    // Silme diyaloğu basitçe
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAmountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final newAmounts = _quickAmounts
                  .where((a) => a != amount)
                  .toList();
              await _storage.saveQuickAmounts(newAmounts);
              setState(() => _quickAmounts = newAmounts);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // We use the QuickEntryCard directly, but we remove its internal margin 
            // by adjusting our outer padding if needed, or just letting it be.
            // Actually, QuickEntryCard has margin: horizontal 16. 
            // In a bottom sheet, this looks like a floating card which is nice.
            QuickEntryCard(
              titleController: _titleController,
              amountController: _amountController,
              selectedEmotion: _selectedEmotion,
              selectedNecessity: _selectedNecessity,
              selectedCategory: _selectedCategory,
              selectedCategoryNotifier: _selectedCategoryNotifier,
              categories: txProvider.categories,
              quickAmounts: _quickAmounts,
              selectedType: _selectedType,
              onTypeChanged: (val) => setState(() => _selectedType = val),
              onEmotionChanged: (val) => setState(() => _selectedEmotion = val),
              onNecessityChanged: (val) => setState(() => _selectedNecessity = val),
              onCategoryChanged: (val) {
                _selectedCategoryNotifier.value = val;
                if (val == 'General') {
                  _titleController.clear();
                } else {
                  _titleController.text = val;
                }
              },
              onSave: _handleSave,
              
              // Enable full features even in the sheet
              onAddCategory: () {
                // You can add logic here if needed, or use a shared helper.
                // For now, let's keep it simple or redirect to a global handler.
              },
              onAddAmount: _showAddQuickAmountDialog,
              onLongPressAmount: _showEditQuickAmountDialog,

              selectedDate: _selectedDate,
              onDateTap: () async {
                final date = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CustomDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
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
                final hasRealTransactions = txProvider.transactions.any((tx) => 
                  tx.category != 'no_spend' && 
                  tx.date.year == _selectedDate.year &&
                  tx.date.month == _selectedDate.month &&
                  tx.date.day == _selectedDate.day
                );

                if (hasRealTransactions) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.noSpendToast)),
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
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
