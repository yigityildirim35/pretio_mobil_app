import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Added for Provider.of
import 'custom_text_field.dart';
import 'emotion_button.dart';
import '../models/category_model.dart';
import '../providers/currency_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../utils/card_decoration.dart';
import '../providers/theme_provider.dart';

String getLocalizedCategoryName(BuildContext context, String categoryId) {
  switch (categoryId) {
    case 'Food':
      return AppLocalizations.of(context)!.catFood;
    case 'Transport':
      return AppLocalizations.of(context)!.catTransport;
    case 'Shopping':
      return AppLocalizations.of(context)!.catShopping;
    case 'Fun':
      return AppLocalizations.of(context)!.catFun;
    case 'Bills':
      return AppLocalizations.of(context)!.catBills;
    case 'Other':
      return AppLocalizations.of(context)!.catOther;
    default:
      return categoryId;
  }
}

class QuickEntryCard extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final String selectedEmotion;
  final String selectedNecessity;
  final String selectedCategory; // Keep for fallback if needed
  final ValueNotifier<String>?
  selectedCategoryNotifier; // Add detailed notifier
  final List<CategoryModel> categories;
  final List<double> quickAmounts;
  final ValueChanged<String> onEmotionChanged;
  final ValueChanged<String> onNecessityChanged;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSave;
  final VoidCallback? onAddCategory;
  final Function(int, int)? onReorderCategory;
  final ValueChanged<CategoryModel>? onDeleteCategory;
  final ValueChanged<CategoryModel>? onEditCategory;
  final VoidCallback? onAddAmount;
  final ValueChanged<double>? onLongPressAmount;
  final DateTime selectedDate;
  final VoidCallback onDateTap;
  final String? note; // New
  final ValueChanged<String?>? onNoteChanged; // New
  final VoidCallback? onNoSpend; // Added
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const QuickEntryCard({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedEmotion,
    required this.selectedNecessity,
    required this.selectedCategory,
    this.selectedCategoryNotifier,
    required this.categories,
    required this.quickAmounts,
    required this.onEmotionChanged,
    required this.onNecessityChanged,
    required this.onCategoryChanged,
    required this.onSave,
    this.onAddCategory,
    this.onReorderCategory,
    this.onDeleteCategory,
    this.onEditCategory,
    this.onAddAmount,
    this.onLongPressAmount,
    required this.selectedDate,
    required this.onDateTap,
    this.note,
    this.onNoteChanged,
    this.onNoSpend,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  State<QuickEntryCard> createState() => _QuickEntryCardState();
}

class _QuickEntryCardState extends State<QuickEntryCard> {
  bool _isEditingCategories = false;

  void _toggleEditMode() {
    setState(() {
      _isEditingCategories = !_isEditingCategories;
    });
    HapticFeedback.selectionClick();
  }

  void _showNoteDialog() {
    final noteController = TextEditingController(text: widget.note);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.addNote,
        ),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterNote,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              widget.onNoteChanged?.call(
                noteController.text.trim().isEmpty
                    ? null
                    : noteController.text.trim(),
              );
              Navigator.pop(context);
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(
        context: context,
        is3D: Provider.of<ThemeProvider>(context).is3DEnabled,
        borderRadius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.addQuickAmount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (widget.onDeleteCategory != null)
                Flexible(
                  child: TextButton(
                    onPressed: _toggleEditMode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _isEditingCategories
                          ? AppLocalizations.of(context)!.done
                          : AppLocalizations.of(context)!.manage,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isEditingCategories ? Colors.red : Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              else
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.addTransaction,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // DATE SELECTION ROW
          InkWell(
            onTap: widget.onDateTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('d MMM yyyy', Localizations.localeOf(context).languageCode).format(widget.selectedDate),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Reactive icon: listens to selectedCategoryNotifier so icon updates instantly on category change
          widget.selectedCategoryNotifier != null
              ? ValueListenableBuilder<String>(
                  valueListenable: widget.selectedCategoryNotifier!,
                  builder: (context, currentCategory, _) {
                    final bool hasCategory = currentCategory.isNotEmpty &&
                        currentCategory != 'General';
                    return CustomTextField(
                      controller: widget.titleController,
                      hint: AppLocalizations.of(context)!.whatDidYouBuy,
                      icon: hasCategory ? Icons.edit : Icons.auto_awesome,
                      iconColor: theme.colorScheme.primary,
                    );
                  },
                )
              : CustomTextField(
                  controller: widget.titleController,
                  hint: AppLocalizations.of(context)!.whatDidYouBuy,
                  icon: widget.selectedCategory.isNotEmpty && widget.selectedCategory != 'General'
                      ? Icons.edit
                      : Icons.auto_awesome,
                  iconColor: theme.colorScheme.primary,
                ),
          const SizedBox(height: 16),
          SizedBox(
            height: 30,
            child: widget.selectedCategoryNotifier != null
                ? ValueListenableBuilder<String>(
                    valueListenable: widget.selectedCategoryNotifier!,
                    builder: (context, currentCategory, child) {
                      return ReorderableListView(
                        scrollDirection: Axis.horizontal,
                        onReorder:
                            widget.onReorderCategory ??
                            (oldIndex, newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              widget.onReorderCategory?.call(
                                oldIndex,
                                newIndex,
                              );
                            },
                        footer: widget.onAddCategory != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: InkWell(
                                  onTap: widget.onAddCategory,
                                  borderRadius: BorderRadius.circular(15),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        children: [
                          for (
                            int index = 0;
                            index < widget.categories.length;
                            index++
                          )
                            Container(
                              key: ValueKey(widget.categories[index].id),
                              margin: const EdgeInsets.only(right: 8),
                              child: _CategoryChip(
                                label: getLocalizedCategoryName(
                                  context,
                                  widget.categories[index].name,
                                ),
                                icon: widget.categories[index].iconData,
                                isSelected:
                                    currentCategory ==
                                    widget.categories[index].name,
                                isEditing:
                                    _isEditingCategories, // Pass editing state
                                onTap: () {
                                  if (_isEditingCategories) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(getLocalizedCategoryName(context, widget.categories[index].name)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onDeleteCategory?.call(widget.categories[index]);
                                            },
                                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                                            child: Text(AppLocalizations.of(context)!.delete),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onEditCategory?.call(widget.categories[index]);
                                            },
                                            child: Text(AppLocalizations.of(context)!.edit),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    HapticFeedback.lightImpact();
                                    widget.onCategoryChanged(
                                      widget.categories[index].name,
                                    );
                                  }
                                },
                                // REMOVED onDoubleTap to fix latency
                                color: widget.categories[index].color,
                              ),
                            ),
                        ],
                      );
                    },
                  )
                : Container(), // Fallback removed for brevity as we know we have notifier
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.amountController,
            icon: Icons.payments_outlined,
            iconColor: theme.colorScheme.primary,
            hint: '0.00',
            isAmount: true,
          ),
          const SizedBox(height: 12),
          // QUICK AMOUNT BUTTONS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...widget.quickAmounts.map((amt) {
                  final currencyProvider = Provider.of<CurrencyProvider>(
                    context,
                  );
                  final displayAmt = currencyProvider.convertFromBase(
                    amt,
                    currencyProvider.currency,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        widget.amountController.text = displayAmt
                            .toStringAsFixed(1);
                        HapticFeedback.selectionClick();
                      },
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                        widget.onLongPressAmount?.call(amt);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          // Display amount with just number? Or with symbol?
                          // Required: just number + symbol is typically fine.
                          // But wait, the card logic above uses '$currency'.
                          // Let's us currencyProvider.formatCurrency or just manual string.
                          // Provider has formatCurrency but it includes symbol.
                          // Here we want e.g. "50 $" or "50 TL"
                          // The 'currency' var above (line 149) is just the code (USD, TL).
                          // Text('${amt.toInt()} $currency') was original.
                          // Let's use formatCurrency if possible, OR just displayAmt
                          currencyProvider.formatCurrency(
                            displayAmt,
                            currencyProvider.currency,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (widget.onAddAmount != null)
                  IconButton(
                    onPressed: widget.onAddAmount,
                    icon: const Icon(Icons.add_circle, color: Colors.grey),
                    tooltip: AppLocalizations.of(context)!.addQuickAmount,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // EMOTION MODULE (conditionally shown)
          if (Provider.of<ThemeProvider>(context).isEmotionModuleEnabled && 
              widget.selectedNecessity != 'necessity' && 
              widget.selectedNecessity != 'obligation' && 
              widget.selectedNecessity != 'zorunluluk') ...[
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.howDoYouFeel,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: EmotionButton(
                    icon: Icons.sentiment_satisfied,
                    label: AppLocalizations.of(context)!.good,
                    isSelected: widget.selectedEmotion == 'happy',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => widget.onEmotionChanged(widget.selectedEmotion == 'happy' ? 'none' : 'happy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EmotionButton(
                    icon: Icons.sentiment_neutral,
                    label: AppLocalizations.of(context)!.okay,
                    isSelected: widget.selectedEmotion == 'neutral',
                    color: Theme.of(context).colorScheme.tertiary,
                    onTap: () => widget.onEmotionChanged(widget.selectedEmotion == 'neutral' ? 'none' : 'neutral'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EmotionButton(
                    icon: Icons.sentiment_dissatisfied,
                    label: AppLocalizations.of(context)!.regret,
                    isSelected: widget.selectedEmotion == 'regret',
                    color: Theme.of(context).colorScheme.error,
                    onTap: () => widget.onEmotionChanged(widget.selectedEmotion == 'regret' ? 'none' : 'regret'),
                  ),
                ),
              ],
            ),
          ],
          // NEED/WANT MODULE (conditionally shown)
          if (Provider.of<ThemeProvider>(context).isNeedWantModuleEnabled) ...[
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.isThisNeedOrWant,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: EmotionButton(
                    icon: Icons.check_circle_outline,
                    label: AppLocalizations.of(context)!.need,
                    isSelected: widget.selectedNecessity == 'need',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => widget.onNecessityChanged(widget.selectedNecessity == 'need' ? 'none' : 'need'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: EmotionButton(
                    icon: Icons.favorite_border,
                    label: AppLocalizations.of(context)!.want,
                    isSelected: widget.selectedNecessity == 'want',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => widget.onNecessityChanged(widget.selectedNecessity == 'want' ? 'none' : 'want'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: EmotionButton(
                    icon: Icons.receipt_long,
                    label: AppLocalizations.of(context)!.necessity,
                    isSelected: widget.selectedNecessity == 'necessity',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => widget.onNecessityChanged(widget.selectedNecessity == 'necessity' ? 'none' : 'necessity'),
                  ),
                ),
              ],
            ),
          ], // end needWantModule
          const SizedBox(height: 24),
          // ACTIONS ROW & SAVE BUTTON
          Row(
            children: [
              // Note Button
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: theme.canvasColor,
                  borderRadius: BorderRadius.circular(16),
                  border: widget.note != null && widget.note!.isNotEmpty
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: IconButton(
                  onPressed: _showNoteDialog,
                  icon: Icon(
                    widget.note != null && widget.note!.isNotEmpty
                        ? Icons.description
                        : Icons.note_add_outlined,
                    color: widget.note != null && widget.note!.isNotEmpty
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  tooltip: AppLocalizations.of(context)!.addNote,
                ),
              ),

              // Save Button
              Expanded(
                child: Container(
                  height: 60,
                  decoration: Provider.of<ThemeProvider>(context).is3DEnabled
                      ? BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      widget.onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: const Color(0xFF112117),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline, size: 28),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.saveTransaction.replaceAll(' ', '\n'),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // No Spend Button
              if (widget.onNoSpend != null)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: theme.canvasColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: widget.onNoSpend,
                    icon: const Icon(
                      Icons.emoji_events_outlined,
                      color: Colors.amber,
                    ),
                    tooltip: 'Harcama Yapılmadı',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isEditing;
  final VoidCallback onTap;
  final Color? color;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isEditing,
    required this.onTap,
    this.color,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isEditing) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (!widget.isEditing) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (!widget.isEditing) {
          setState(() => _isPressed = false);
        }
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: widget.isEditing
              ? Colors.red.withValues(alpha: 0.1)
              : ((widget.isSelected || _isPressed)
                    ? (widget.color ?? Theme.of(context).colorScheme.primary)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isEditing
                ? Colors.red
                : ((widget.isSelected || _isPressed)
                      ? (widget.color ?? Theme.of(context).colorScheme.primary)
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
        ),
        child: Row(
          children: [
            if (widget.isEditing)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.edit, size: 16, color: Colors.red),
              )
            else
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected
                    ? const Color(0xFF112117)
                    : Colors.grey,
              ),
            if (widget.label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.isEditing
                      ? Colors.red
                      : (widget.isSelected
                            ? const Color(0xFF112117)
                            : Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

