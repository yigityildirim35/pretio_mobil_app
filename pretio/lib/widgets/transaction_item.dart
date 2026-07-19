import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:pretio/l10n/app_localizations.dart';
import '../models/transaction.dart';
import '../models/category_model.dart';
import '../utils/card_decoration.dart';
import '../providers/currency_provider.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:intl/intl.dart';

String getLocalizedCategoryName(BuildContext context, String categoryId) {
  switch (categoryId.toLowerCase()) {
    case 'food':
      return AppLocalizations.of(context)!.catFood;
    case 'transport':
      return AppLocalizations.of(context)!.catTransport;
    case 'shopping':
      return AppLocalizations.of(context)!.catShopping;
    case 'entertainment':
    case 'fun':
      return AppLocalizations.of(context)!.catFun;
    case 'bills':
      return AppLocalizations.of(context)!.catBills;
    case 'other':
      return AppLocalizations.of(context)!.catOther;
    default:
      return categoryId; // Display raw ID only if no match found
  }
}

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final List<CategoryModel> categories;
  final Function(Transaction) onDelete;
  final Function(Transaction, Transaction) onEdit;
  final Function(Transaction) onToggleFavorite;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.categories,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleFavorite,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool _isExpanded = false;

  Color _getCategoryColor(String categoryName) {
    if (widget.transaction is ShadowTransaction) {
      return Theme.of(context).primaryColor;
    }
    try {
      final category = widget.categories.firstWhere(
        (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      );
      return category.color;
    } catch (e) {
      if (categoryName == 'no_spend') return Colors.amber;
      if (categoryName == 'Silinen Veri') return const Color(0xFFE1BEE7);
      if (categoryName == 'Diğer') return Colors.pinkAccent;
      if (categoryName == 'Kategorilendirilmemiş') return Colors.pink;
      if (categoryName == 'Abonelik') return Colors.grey.shade500; // Grayish neutral color
      
      switch (categoryName.toLowerCase()) {
        case 'food':
          return Colors.orange;
        case 'transport':
          return Colors.blue;
        case 'shopping':
          return Colors.purple;
        case 'health':
          return Colors.red;
        case 'entertainment':
          return Colors.pink;
        case 'bills':
          return Colors.indigo;
        default:
          return const Color(0xFFE1BEE7); // Fallback to light purple if truly unknown
      }
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    if (widget.transaction.type == 'income') {
      return Icons.account_balance_wallet_rounded;
    }
    if (widget.transaction is ShadowTransaction) {
      return Icons.shopping_bag_rounded;
    }
    try {
      final category = widget.categories.firstWhere(
        (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      );
      return category.iconData;
    } catch (e) {
      if (categoryName == 'no_spend') return Icons.emoji_events;
      if (categoryName == 'Silinen Veri') return Icons.delete_outline;
      if (categoryName == 'Diğer') return Icons.star;
      if (categoryName == 'Kategorilendirilmemiş') return Icons.auto_awesome;
      if (categoryName == 'Abonelik') return Icons.autorenew_rounded;

      switch (categoryName.toLowerCase()) {
        case 'food':
          return Icons.restaurant;
        case 'transport':
          return Icons.directions_bus;
        case 'shopping':
          return Icons.shopping_bag;
        case 'health':
          return Icons.medical_services;
        case 'entertainment':
          return Icons.movie;
        case 'bills':
          return Icons.receipt;
        default:
          return Icons.delete_outline; // Fallback to trash if truly unknown
      }
    }
  }


  Color _getNecessityColor(String necessity) {
    if (necessity == 'none') {
      return Colors.transparent;
    }
    if (necessity == 'need') {
      return const Color(0xFF26E581); // Green - ihtiyaç
    }
    if (necessity == 'obligation' || necessity == 'zorunluluk' || necessity == 'necessity') {
      return const Color(0xFFFF6B6B); // Coral Red - zorunluluk
    }
    return const Color(0xFFB973FF); // Purple - istek
  }

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'TODAY';
    } else if (targetDate == yesterday) {
      return 'YESTERDAY';
    } else {
      return DateFormat('MMM dd, yyyy').format(date).toUpperCase();
    }
  }

  void _showEditDialog(BuildContext context, Transaction t) {
    final titleController = TextEditingController(text: t.title);
    final amountController = TextEditingController(text: t.amount.toString());

    // Category is stored as cat.name, so we work with names throughout
    String selectedCategory = t.category;
    // Verify it matches an existing category name; if not, default to first
    final categoryMatchesByName = widget.categories.any((c) => c.name == selectedCategory);
    if (!categoryMatchesByName) {
      selectedCategory = widget.categories.isNotEmpty
          ? widget.categories.first.name
          : 'General';
    }

    String selectedNecessity = t.necessity;
    if (selectedNecessity != 'need' &&
        selectedNecessity != 'want' &&
        selectedNecessity != 'necessity' &&
        selectedNecessity != 'obligation' &&
        selectedNecessity != 'zorunluluk' &&
        selectedNecessity != 'none') {
      selectedNecessity = 'none';
    }
    if (selectedNecessity == 'zorunluluk' ||
        selectedNecessity == 'necessity' && t.necessity != 'need') {
      selectedNecessity = 'obligation';
    }

    String selectedEmotion = t.emotion;
    if (selectedEmotion != 'happy' &&
        selectedEmotion != 'neutral' &&
        selectedEmotion != 'regret' &&
        selectedEmotion != 'none') {
      selectedEmotion = 'none';
    }

    final noteController = TextEditingController(text: t.note);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.editTransactionTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.titleLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.amountLabel,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.categoryName,
                    ),
                    items: widget.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedNecessity,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.needVsWant,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'none',
                        child: Text(AppLocalizations.of(context)!.notSpecified),
                      ),
                      DropdownMenuItem(
                        value: 'need',
                        child: Text(AppLocalizations.of(context)!.need),
                      ),
                      DropdownMenuItem(
                        value: 'want',
                        child: Text(AppLocalizations.of(context)!.want),
                      ),
                      DropdownMenuItem(
                        value: 'obligation',
                        child: Text(AppLocalizations.of(context)!.necessity),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedNecessity = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedEmotion,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.emotionalImpact,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'none',
                        child: Text(AppLocalizations.of(context)!.notSpecified),
                      ),
                      DropdownMenuItem(
                        value: 'happy',
                        child: Text(AppLocalizations.of(context)!.good),
                      ),
                      DropdownMenuItem(
                        value: 'neutral',
                        child: Text(AppLocalizations.of(context)!.okay),
                      ),
                      DropdownMenuItem(
                        value: 'regret',
                        child: Text(AppLocalizations.of(context)!.regret),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedEmotion = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.addNote,
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final newAmount = double.tryParse(amountController.text);
                  if (newAmount != null && newAmount >= 0.01 && titleController.text.isNotEmpty) {
                    final newT = Transaction(
                      id: t.id,
                      title: titleController.text,
                      amount: newAmount,
                      emotion: selectedEmotion,
                      necessity: selectedNecessity,
                      date: t.date,
                      category: selectedCategory,
                      isFavorite: t.isFavorite,
                      note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                      logoUrl: t.logoUrl,
                    );
                    widget.onEdit(t, newT);
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final isIncome = widget.transaction.type == 'income';
    final catColor = isIncome ? Colors.green : _getCategoryColor(widget.transaction.category);
    final hasNote = widget.transaction.note != null && widget.transaction.note!.isNotEmpty;
    final isNoSpend = widget.transaction.category == 'no_spend';

    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: true);
    final displayAmount = currencyProvider.convertFromBase(widget.transaction.amount, currencyProvider.currency);
    final formattedPrice = currencyProvider.formatCurrency(displayAmount, currencyProvider.currency);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Slidable(
        key: ValueKey(widget.transaction.id),
        enabled: !isNoSpend, // Disable sliding for 'No Spend'
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.65,
          children: [
            SlidableAction(
              onPressed: (context) => widget.onToggleFavorite(widget.transaction),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: widget.transaction.isFavorite ? Icons.star_border_rounded : Icons.star_rounded,
              label: AppLocalizations.of(context)!.favorite,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
            SlidableAction(
              onPressed: (context) => _showEditDialog(context, widget.transaction),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: AppLocalizations.of(context)!.manage,
            ),
            SlidableAction(
              onPressed: (context) {
                widget.onDelete(widget.transaction);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: AppLocalizations.of(context)!.delete,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: _buildTransactionCard(theme, is3D, isIncome, catColor, hasNote, formattedPrice),
        ),
      ),
    );
  }

  Color _getEmotionColor(BuildContext context, String emotion) {
    final theme = Theme.of(context);

    switch (emotion) {
      case 'happy':
      case 'none': // "none" is saved when the feature is turned off
        return theme.colorScheme.primary;
      case 'neutral':
      case 'meh':
        return theme.colorScheme.tertiary;
      case 'regret':
      case 'pişman':
      case 'unhappy':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  Widget _buildTransactionCard(ThemeData theme, bool is3D, bool isIncome, Color catColor, bool hasNote, String formattedPrice) {
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final isNoSpend = widget.transaction.category == 'no_spend';
    final emotionColor = _getEmotionColor(context, widget.transaction.emotion);

    String necessityText = '';
    Color necessityColor = _getNecessityColor(widget.transaction.necessity);
    if (widget.transaction.necessity != 'none') {
      if (widget.transaction.necessity == 'need') {
        necessityText = AppLocalizations.of(context)!.need;
      } else if (widget.transaction.necessity == 'want') {
        necessityText = AppLocalizations.of(context)!.want;
      } else {
        necessityText = AppLocalizations.of(context)!.necessity;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAlias,
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        shadowColor: is3D ? (isNoSpend ? Colors.amber : (isDark ? catColor.withValues(alpha: 0.5) : catColor.withValues(alpha: 0.4))) : null,
        backgroundColor: theme.cardColor,
        borderRadius: 16,
      ).copyWith(
        border: Border.all(color: Colors.transparent, width: 0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          // Icon Box
                          _buildIconBox(theme, is3D, isDark, catColor),
                          const SizedBox(width: 14),
                          // Title & Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.transaction.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: onSurface,
                                          fontSize: 16,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ),
                                    if (widget.transaction.isFavorite) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (necessityText.isNotEmpty && !is3D) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: necessityColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: necessityColor.withValues(alpha: 0.3), width: 0.5),
                                        ),
                                        child: Text(
                                          necessityText.toUpperCase(),
                                          style: TextStyle(
                                            color: necessityColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (is3D) ...[
                                      Text(
                                        _getRelativeDate(widget.transaction.date).toUpperCase(),
                                        style: TextStyle(
                                          color: onSurface.withValues(alpha: 0.4),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                    if (widget.transaction.category.toLowerCase() == 'abonelik' || widget.transaction.category.toLowerCase() == 'subscriptions') ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 0.5),
                                        ),
                                        child: const Text(
                                          "LİMİT DIŞI",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (hasNote) ...[
                                      Icon(Icons.notes_rounded, size: 14, color: onSurface.withValues(alpha: 0.5)),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Amount (Empty for 'no_spend' to hide '0.00' if desired, but user didn't say hide amount, wait user said "0 yansımayacak". But "0" looks okay. Actually, maybe we can hide the amount for no_spend? Let's just show it as empty or don't show amount if it's no_spend.)
                          if (!isNoSpend)
                            Text(
                              isIncome ? '+$formattedPrice' : '-$formattedPrice',
                              style: TextStyle(
                                color: isIncome ? Colors.green : onSurface.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: -0.5,
                              ),
                            )
                          else
                            Text(
                              '-',
                              style: TextStyle(
                                color: onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          if (is3D && !isNoSpend) ...[
                            const SizedBox(width: 16),
                            // 3D Indicators
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.transaction.necessity != 'none')
                                  _buildIndicatorPill(necessityColor),
                                if (widget.transaction.necessity != 'none') const SizedBox(width: 6),
                                _buildIndicatorPill(emotionColor),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_isExpanded)
                      Container(
                        padding: const EdgeInsets.fromLTRB(80, 0, 16, 16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: onSurface.withValues(alpha: 0.1)),
                            const SizedBox(height: 8),
                            if (widget.transaction.necessity == 'necessity' || widget.transaction.necessity == 'obligation' || widget.transaction.necessity == 'zorunluluk') ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: necessityColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: necessityColor.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, size: 16, color: necessityColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.obligationWarning,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: necessityColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (hasNote)
                              Text(
                                widget.transaction.note == 'Otomatik Yenileme' ? AppLocalizations.of(context)!.autoRenewal : widget.transaction.note!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: onSurface.withValues(alpha: 0.7),
                                  height: 1.5,
                                ),
                              )
                            else
                              Text(
                                AppLocalizations.of(context)!.noNoteAttached,
                                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Flat View Emotion Bar (Far Right, Full Height)
              if (!is3D)
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: isNoSpend ? Colors.amber : emotionColor.withValues(alpha: 0.85),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(ThemeData theme, bool is3D, bool isDark, Color catColor) {
    if (is3D) {
      final isNoSpend = widget.transaction.category == 'no_spend';
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3748) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isNoSpend ? Colors.amber : catColor.withValues(alpha: 0.5),
              offset: const Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: _buildIcon(catColor, 28),
        ),
      );
    } else {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: catColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _buildIcon(catColor, 22),
        ),
      );
    }
  }

  Widget _buildIcon(Color color, double size) {
    if (widget.transaction.logoUrl != null && widget.transaction.logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.4),
        child: widget.transaction.logoUrl!.startsWith('http')
            ? Image.network(
                widget.transaction.logoUrl!,
                width: size, height: size, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(_getCategoryIcon(widget.transaction.category), color: color, size: size),
              )
            : Image.file(
                File(widget.transaction.logoUrl!),
                width: size, height: size, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(_getCategoryIcon(widget.transaction.category), color: color, size: size),
              ),
      );
    }
    return Icon(_getCategoryIcon(widget.transaction.category), color: color, size: size);
  }

  Widget _buildIndicatorPill(Color color) {
    return Container(
      width: 6,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
