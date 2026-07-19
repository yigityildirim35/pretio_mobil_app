import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../models/transaction.dart';
import '../models/category_model.dart';

import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';
import 'package:pretio/l10n/app_localizations.dart';

// Görünüm Modları
enum BudgetView { shadow, timeCost }

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  // --- STATE ---
  BudgetView _currentView = BudgetView.shadow;

  // Shadow Budget Controllers
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  // Selected emotion for quick entry removed per user request

  // Time Cost Controllers
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];
  bool _isTimeCostExpanded = false;

  @override
  void initState() {
    super.initState();
    // Provider'dan verileri alıp controller'lara yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final txProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final currencyProvider = Provider.of<CurrencyProvider>(
        context,
        listen: false,
      );

      // getDisplayValue returns string with symbol. We just want the number for the text field.
      // We should use `convert`.
      final salaryVal = currencyProvider.convertFromBase(
        txProvider.timeValueSalary,
        currencyProvider.currency,
      );

      _salaryController.text = salaryVal.toStringAsFixed(0);
      _hoursController.text = txProvider.timeValueHours.toStringAsFixed(0);
    });
  }



  // --- LOGIC METHODS ---

  void _addShadowTransaction() {
    if (_itemController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    final enteredAmount = double.tryParse(_amountController.text);
    if (enteredAmount == null || enteredAmount < 0.01) return;

    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );
    final baseAmount = currencyProvider.convertToBase(
      enteredAmount,
      currencyProvider.currency,
    );

    final tx = ShadowTransaction(
      title: _itemController.text,
      amount: baseAmount,
      emotion: 'neutral',
      date: DateTime.now(),
      category: 'General',
    );

    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).addShadowTransaction(tx);

    _itemController.clear();
    _amountController.clear();
  }

  void _showEditGoalDialog(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );

    final nameController = TextEditingController(text: provider.shadowGoalName);
    // Display stored base amount in selected currency
    final displayAmount = currencyProvider.convertFromBase(
      provider.shadowGoalAmount,
      currencyProvider.currency,
    );

    final amountController = TextEditingController(
      text: displayAmount.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editGoal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.goalName,
              ),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.goalAmount,
                suffixText: currencyProvider.currency,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final enteredAmount =
                  double.tryParse(amountController.text) ?? 0.0;
              if (nameController.text.isNotEmpty && enteredAmount > 0) {
                // Convert back to base
                final baseAmount = currencyProvider.convertToBase(
                  enteredAmount,
                  currencyProvider.currency,
                );

                provider.updateShadowGoal(nameController.text, baseAmount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _updateTimeRate() {
    final enteredSalary = double.tryParse(_salaryController.text) ?? 0;
    final hours = double.tryParse(_hoursController.text) ?? 0;

    if (enteredSalary > 0 && hours > 0) {
      final currencyProvider = Provider.of<CurrencyProvider>(
        context,
        listen: false,
      );
      // Convert salary back to base
      final baseSalary = currencyProvider.convertToBase(
        enteredSalary,
        currencyProvider.currency,
      );

      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).updateTimeValueMetrics(baseSalary, hours);
    }
  }

  String _calculateWorkTime(double price, double hourlyWage) {
    if (hourlyWage <= 0) return '∞';

    double hours = price / hourlyWage;

    if (hours < 1) {
      return '${(hours * 60).toInt()}dk';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)}sa';
    } else if (hours < 160) {
      return '${(hours / 8).toStringAsFixed(1)} iş günü';
    } else {
      return '${(hours / 160).toStringAsFixed(1)} ay';
    }
  }

  // --- BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final is3D = context.watch<ThemeProvider>().is3DEnabled;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Text(
                  _currentView == BudgetView.shadow
                      ? AppLocalizations.of(context)!.shadowBudget
                      : AppLocalizations.of(context)!.timeValue,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildSegmentedControl(isDark, is3D),
              ),
              const SizedBox(height: 24),

              // Content Switcher
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentView == BudgetView.shadow
                    ? _buildShadowBudgetView(isDark, is3D)
                    : _buildTimeCostView(isDark, is3D),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isDark, bool is3D) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 16,
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              AppLocalizations.of(context)!.shadowBudget,
              BudgetView.shadow,
              isDark,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              AppLocalizations.of(context)!.timeValue,
              BudgetView.timeCost,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, BudgetView view, bool isDark) {
    final isSelected = _currentView == view;
    return GestureDetector(
      onTap: () => setState(() => _currentView = view),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).scaffoldBackgroundColor
                : (Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // VIEW 1: SHADOW BUDGET
  // ===========================================================================
  Widget _buildShadowBudgetView(bool isDark, bool is3D) {
    final provider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    final shadowTxs = provider.shadowTransactions;
    final totalSavedBase = shadowTxs.fold(0.0, (sum, tx) => sum + tx.amount);
    final hourlyWageBase = provider.hourlyWage;

    // Convert for display
    final totalSavedDisplay = currencyProvider.convertFromBase(
      totalSavedBase,
      currencyProvider.currency,
    );
    // Calculation of reclaimed hours uses Base/Base ratio which is currency independent
    final reclaimedHours = hourlyWageBase > 0
        ? totalSavedBase / hourlyWageBase
        : 0.0;

    return Column(
      key: const ValueKey('ShadowView'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildQuickEntry(isDark, is3D),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildHeroButton(isDark, is3D),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildStatsCards(
            currencyProvider,
            isDark,
            totalSavedDisplay,
            reclaimedHours,
            currencyProvider.currency,
            is3D,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildMountainSection(
            isDark,
            totalSavedBase, // Pass Base for logic (progress), but inside we might need display
            provider.shadowGoalName,
            provider.shadowGoalAmount,
            is3D,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildVictoriesList(isDark, shadowTxs, hourlyWageBase, is3D),
        ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 2: TIME COST CALCULATOR
  // ===========================================================================
  Widget _buildTimeCostView(bool isDark, bool is3D) {
    final provider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final currency = currencyProvider.currency;
    final hourlyWageBase = provider.hourlyWage;

    // Display Wage
    final hourlyWageDisplay = currencyProvider.convertFromBase(
      hourlyWageBase,
      currency,
    );

    final transactions = [...provider.transactions];
    transactions.sort((a, b) => b.date.compareTo(a.date));

    // Show 5 by default, all when expanded
    final itemCount = _isTimeCostExpanded ? transactions.length : 5;
    final visibleTransactions = transactions.take(itemCount).toList();

    return Padding(
      key: const ValueKey('TimeCostView'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // 1. Profil / Input Kartı
          Container(
            padding: const EdgeInsets.all(24),
            decoration: buildCardDecoration(
              context: context,
              is3D: is3D,
              shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.profile.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileInput(
                        controller: _salaryController,
                        label: AppLocalizations.of(context)!.monthlySalary,
                        icon: Icons.payments,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProfileInput(
                        controller: _hoursController,
                        label: AppLocalizations.of(context)!.weeklyHours,
                        icon: Icons.schedule,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updateTimeRate,
                    icon: const Icon(Icons.calculate),
                    label: Text(AppLocalizations.of(context)!.recalculateRate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. Hero Sonuç Kartı
          _buildLifeCurrencyCard(
            isDark,
            hourlyWageDisplay,
            currency,
            is3D,
            currencyProvider,
          ),

          const SizedBox(height: 24),

          // 3. Karşılaştırma Listesi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.howMuchLife,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (visibleTransactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.noTransactionsYet,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          ...visibleTransactions.map((tx) {
            final category = _getCategoryByName(tx.category, provider.categories);
            return _buildTimeCostItem(
              name: tx.title,
              price: tx.amount.abs(), // Still Base, will be converted in item
              icon: category.iconData,
              color: category.color,
              hourlyWage: hourlyWageBase, // Base required for timecalc
              currency: currency,
              isDark: isDark,
              is3D: is3D,
            );
          }),

          // Show More / Show Less Toggle
          if (transactions.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _isTimeCostExpanded = !_isTimeCostExpanded),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isTimeCostExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isTimeCostExpanded
                            ? AppLocalizations.of(context)!.viewAll
                            : '${AppLocalizations.of(context)!.viewAll} (${transactions.length - 5})',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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

  // --- WIDGET HELPERS FOR TIME COST ---

  Widget _buildProfileInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCostItem({
    required String name,
    required double price,
    required IconData icon,
    required Color color,
    required double hourlyWage,
    required String currency,
    required bool isDark,
    required bool is3D,
  }) {
    final workTime = _calculateWorkTime(price, hourlyWage);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final displayPrice = currencyProvider.convertFromBase(price, currency);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 20,
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  currencyProvider.isPrivacyModeEnabled
                      ? '***'
                      : '${NumberFormat('#,##0').format(displayPrice)} $currency',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                workTime,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.workShort,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SHADOW BUDGET COMPONENTS
  // ===========================================================================

  Widget _buildQuickEntry(bool isDark, bool is3D) {
    final currencyProvider = Provider.of<CurrencyProvider>(
      context,
      listen: false,
    );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.addQuickAmount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Ürün Girişi
          _buildLabel(AppLocalizations.of(context)!.whatDidYouBuy, isDark),
          _buildInput(
            controller: _itemController,
            hint: AppLocalizations.of(context)!.coffeeShoesEta,
            isDark: isDark,
            icon: Icons.shopping_bag_outlined,
          ),

          const SizedBox(height: 16),

          // 2. Kategori Çipleri
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Provider.of<TransactionProvider>(context).categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(cat.name),
                    avatar: Icon(
                      cat.iconData,
                      size: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    backgroundColor: Theme.of(context).canvasColor,
                    side: BorderSide.none,
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.87),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () {
                      _itemController.text = cat.name;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // 3. Fiyat Girişi
          _buildLabel(AppLocalizations.of(context)!.howMuchWasIt, isDark),
          _buildInput(
            controller: _amountController,
            hint: '0.00',
            isDark: isDark,
            isNumber: true,
            suffix: currencyProvider.currency,
            icon: Icons.attach_money,
          ),

          const SizedBox(height: 12),

          // 4. Hızlı Tutarlar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickAmounts.map((amount) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _amountController.text = amount.toStringAsFixed(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        currencyProvider.isPrivacyModeEnabled
                            ? '***'
                            : '${amount.toInt()} ${currencyProvider.currency}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 5. His Durumu removed as per user request
        ],
      ),
    );
  }

  // Sentiment buttons removed per user request

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    bool isNumber = false,
    String? suffix,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey[400], size: 20)
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixText: suffix,
          suffixStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }


  Widget _buildHeroButton(bool isDark, bool is3D) {
    return GestureDetector(
      onTap: _addShadowTransaction,
      child: Container(
        height: 64,
        decoration:
            buildCardDecoration(
              context: context,
              is3D: is3D,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shadowColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ).copyWith(
              border: is3D
                  ? Border(
                      bottom: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                        width: 4,
                      ),
                    )
                  : null,
              gradient: !is3D
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.iDidntBuyIt,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(
    CurrencyProvider currencyProvider,
    bool isDark,
    double saved,
    double reclaimed,
    String currency,
    bool is3D,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            isDark: isDark,
            icon: Icons.savings,
            iconColor: Theme.of(context).colorScheme.primary,
            label: AppLocalizations.of(
              context,
            )!.totalSaved(0).split(':').first.toUpperCase(),
            value: currencyProvider.isPrivacyModeEnabled
                ? '***'
                : NumberFormat('#,##0').format(saved),
            sub: currencyProvider.isPrivacyModeEnabled ? '' : currency,
            is3D: is3D,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            isDark: isDark,
            icon: Icons.hourglass_bottom,
            iconColor: Theme.of(context).colorScheme.primary,
            label: AppLocalizations.of(context)!.reclaimed,
            value: reclaimed.toStringAsFixed(1),
            sub: AppLocalizations.of(context)!.workHours,
            is3D: is3D,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String sub,
    required bool is3D,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMountainSection(
    bool isDark,
    double savedBase,
    String goalName,
    double goalAmountBase,
    bool is3D,
  ) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    // Progress is Ratio (Base/Base)
    final double progress = (savedBase / goalAmountBase).clamp(0.0, 1.0);
    final int level = (progress / 0.2).floor() + 1;

    // Display Amount
    final displayGoalAmount = currencyProvider.convertFromBase(
      goalAmountBase,
      currencyProvider.currency,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditGoalDialog(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag, color: Color(0xFFf59e0b)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.mountainOfSavings,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit, size: 14, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.isPrivacyModeEnabled
                            ? '$goalName (***)'
                            : '$goalName (${NumberFormat('#,##0').format(displayGoalAmount)} ${currencyProvider.currency})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.levelX(level),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: MountainPainter(
                progress: progress,
                color: Theme.of(context).canvasColor,
                fillColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.starting,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                AppLocalizations.of(
                  context,
                )!.leftToPeak(((1 - progress) * 100).toInt()),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVictoriesList(
    bool isDark,
    List<ShadowTransaction> txs,
    double hourlyWageBase,
    bool is3D,
  ) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.recentVictories,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (txs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.noVictoriesYet,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ...txs.take(5).map((tx) {
          final double savedHours = hourlyWageBase > 0
              ? tx.amount / hourlyWageBase
              : 0;
          final displayAmount = currencyProvider.convertFromBase(
            tx.amount,
            currencyProvider.currency,
          );
          
          // Shadow budget items always use shopping bag + theme primary color
          final shadowIconColor = Theme.of(context).colorScheme.primary;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Slidable(
              key: ValueKey(tx.date.toString()),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Provider.of<TransactionProvider>(
                        context,
                        listen: false,
                      ).toggleShadowFavorite(tx);
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: tx.isFavorite ? Icons.star : Icons.star_border,
                    label: AppLocalizations.of(context)!.favorite,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => _showEditDeleteDialog(tx),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: AppLocalizations.of(context)!.edit,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      Provider.of<TransactionProvider>(
                        context,
                        listen: false,
                      ).deleteShadowTransaction(tx);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: AppLocalizations.of(context)!.delete,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: buildCardDecoration(
                  context: context,
                  is3D: is3D,
                  shadowColor: isDark
                      ? Colors.black26
                      : const Color(0xFFE2E8F0),
                  borderRadius: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: is3D ? 52 : 44,
                      height: is3D ? 52 : 44,
                      decoration: BoxDecoration(
                        color: is3D
                            ? (isDark ? const Color(0xFF2D3748) : Colors.white)
                            : shadowIconColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(is3D ? 16 : 12),
                        boxShadow: is3D
                            ? [
                                BoxShadow(
                                  color: shadowIconColor.withValues(alpha: 0.5),
                                  offset: const Offset(0, 3),
                                  blurRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: shadowIconColor,
                          size: is3D ? 26 : 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (savedHours > 0)
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.savedHours(savedHours.toStringAsFixed(1)),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (tx.isFavorite)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.amber,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyProvider.isPrivacyModeEnabled
                              ? '***'
                              : '+${NumberFormat('#,##0').format(displayAmount)} ${currencyProvider.currency}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat('d MMM', Localizations.localeOf(context).languageCode).format(tx.date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showEditDeleteDialog(ShadowTransaction tx) {
    final titleCtrl = TextEditingController(text: tx.title);
    final amountCtrl = TextEditingController(text: tx.amount.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editVictory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.item,
              ),
            ),
            TextField(
              controller: amountCtrl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.price,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAmount = double.tryParse(amountCtrl.text);
              if (newAmount != null && titleCtrl.text.isNotEmpty) {
                final newTx = ShadowTransaction(
                  title: titleCtrl.text,
                  amount: newAmount,
                  emotion: tx.emotion,
                  date: tx.date,
                  category: tx.category,
                  isFavorite: tx.isFavorite,
                );
                Provider.of<TransactionProvider>(
                  context,
                  listen: false,
                ).editShadowTransaction(tx, newTx);
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  /// Helper to get a CategoryModel object by name
  CategoryModel _getCategoryByName(String name, List<CategoryModel> categories) {
    if (name.toLowerCase() == 'no_spend') {
      return CategoryModel(
        id: 'no_spend',
        name: name,
        iconCode: Icons.emoji_events.codePoint,
        colorValue: Colors.amber.toARGB32(),
        isDefault: true,
      );
    } else if (name.toLowerCase() == 'abonelik') {
      return CategoryModel(
        id: 'abonelik',
        name: name,
        iconCode: Icons.autorenew_rounded.codePoint,
        colorValue: Colors.orange.toARGB32(),
        isDefault: true,
      );
    } else if (name.toLowerCase() == 'silinen veri' || name.toLowerCase() == 'deleted data') {
      return CategoryModel(
        id: 'deleted',
        name: name,
        iconCode: Icons.delete_outline.codePoint,
        colorValue: const Color(0xFFE1BEE7).toARGB32(),
        isDefault: true,
      );
    } else if (name.toLowerCase() == 'kategorilendirilmemiş' || name.toLowerCase() == 'diğer' || name.toLowerCase() == 'other') {
      return CategoryModel(
        id: 'uncategorized',
        name: name,
        iconCode: Icons.auto_awesome.codePoint,
        colorValue: Colors.pink.toARGB32(),
        isDefault: true,
      );
    }

    // Dynamic Localization Checks
    if (AppLocalizations.of(context) != null) {
      final loc = AppLocalizations.of(context)!;
      if (name == loc.subscriptions || name == loc.subscriptionManagement) {
        return CategoryModel(
          id: 'abonelik',
          name: name,
          iconCode: Icons.autorenew_rounded.codePoint,
          colorValue: Colors.orange.toARGB32(),
          isDefault: true,
        );
      }
      if (name == loc.deletedData) {
        return CategoryModel(
          id: 'deleted',
          name: name,
          iconCode: Icons.delete_outline.codePoint,
          colorValue: const Color(0xFFE1BEE7).toARGB32(),
          isDefault: true,
        );
      }
      if (name == 'Kategorilendirilmemiş' || name == loc.otherCategory) {
        return CategoryModel(
          id: 'uncategorized',
          name: name,
          iconCode: Icons.auto_awesome.codePoint,
          colorValue: Colors.pink.toARGB32(),
          isDefault: true,
        );
      }
    }

    try {
      return categories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      // If NOT FOUND in _categories (and not a system match above),
      // it means this category was deleted! We should render it as "Silinen Veri"
      return CategoryModel(
        id: 'deleted',
        name: AppLocalizations.of(context)?.deletedData ?? 'Silinen Veri',
        iconCode: Icons.delete_outline.codePoint,
        colorValue: const Color(0xFFE1BEE7).toARGB32(),
        isDefault: true,
      );
    }
  }

  Widget _buildLifeCurrencyCard(
    bool isDark,
    double hourlyWage,
    String currency,
    bool is3D,
    CurrencyProvider currencyProvider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration:
          buildCardDecoration(
            context: context,
            is3D: is3D,
            backgroundColor: isDark ? Theme.of(context).cardColor : Theme.of(context).colorScheme.primary,
            shadowColor: isDark ? Colors.black26 : Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          ).copyWith(
            gradient: is3D
                ? null
                : LinearGradient(
                    colors: isDark
                        ? [
                            Theme.of(context).cardColor,
                            Theme.of(context).canvasColor,
                          ]
                        : [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle Background Pattern
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.timer_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),

          // Content
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currencyProvider.isPrivacyModeEnabled
                    ? '***'
                    : hourlyWage.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              if (!currencyProvider.isPrivacyModeEnabled) ...[
                const SizedBox(width: 6),
                Text(
                  '${currencyProvider.currency}${AppLocalizations.of(context)!.tlPhr}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class MountainPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color fillColor;

  MountainPainter({
    required this.progress,
    required this.color,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.4, size.height * 0.2);
    path.lineTo(size.width * 0.6, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    if (progress > 0) {
      final fillPaint = Paint()
        ..color = fillColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
      canvas.drawPath(path, fillPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
