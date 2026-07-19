import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goals_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/goals_settings_sheet.dart';
import '../widgets/target_goal_update_sheet.dart';
import '../widgets/animated_amount.dart';
import '../utils/card_decoration.dart';
import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';

import 'package:pretio/l10n/app_localizations.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color primary = theme.colorScheme.primary;
    final Color primaryDark = HSLColor.fromColor(primary)
        .withLightness(
          (HSLColor.fromColor(primary).lightness - 0.15).clamp(0.0, 1.0),
        )
        .toColor();
    final Color primaryBorder = theme.colorScheme.primary.withValues(alpha: 0.5);

    final Color slate100 = isDark ? Colors.white10 : const Color(0xFFF1F5F9);
    final Color slate200 = isDark ? Colors.white24 : const Color(0xFFE2E8F0);
    final Color slate400 = isDark ? Colors.white54 : const Color(0xFF94A3B8);
    final Color slate700 = isDark ? Colors.white70 : const Color(0xFF334155);
    final Color slate800 = theme.colorScheme.onSurface;

    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;

    return Consumer<GoalsProvider>(
      builder: (context, goalsProvider, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 120, // Extra padding for bottom nav
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.goals,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Card 1: Current Goal
                _buildCurrentGoalCard(
                  context: context,
                  provider: goalsProvider,
                  currencyProvider: currencyProvider,
                  primary: primary,
                  primaryDark: primaryDark,
                  primaryBorder: primaryBorder,
                  slate100: slate100,
                  slate200: slate200,
                  slate400: slate400,
                  slate700: slate700,
                  slate800: slate800,
                  is3D: is3D,
                ),

                const SizedBox(height: 24),


                // Card 2: Spending Power
                _buildSpendingPowerCard(
                  context: context,
                  provider: goalsProvider,
                  currencyProvider: currencyProvider,
                  primary: primary,
                  primaryDark: primaryDark,
                  slate100: slate100,
                  slate200: slate200,
                  slate400: slate400,
                  slate800: slate800,
                  is3D: is3D,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildCurrentGoalCard({
    required BuildContext context,
    required GoalsProvider provider,
    required CurrencyProvider currencyProvider,
    required Color primary,
    required Color primaryDark,
    required Color primaryBorder,
    required Color slate100,
    required Color slate200,
    required Color slate400,
    required Color slate700,
    required Color slate800,
    required bool is3D,
  }) {
    final txProvider = Provider.of<TransactionProvider>(context, listen: true);
    final String goalName = txProvider.shadowGoalName;
    double targetAmount = txProvider.shadowGoalAmount;

    double realizedSavings = provider.bigGoalSavings;
    double potentialSavings = provider.monthlyTargetSavings;
    double baseMonthlyTarget = provider.baseMonthlyTargetSavings;

    double netRemaining = targetAmount - realizedSavings;
    if (netRemaining < 0) netRemaining = 0;

    double ifProtectedRemaining =
        targetAmount - realizedSavings - potentialSavings;
    if (ifProtectedRemaining < 0) ifProtectedRemaining = 0;

    double realizedPercent = targetAmount > 0
        ? (realizedSavings / targetAmount).clamp(0.0, 1.0)
        : 0.0;

    // The "Health Bar" percent based on the initial monthly target
    double potentialPercent = baseMonthlyTarget > 0
        ? (potentialSavings / baseMonthlyTarget).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 28,
        borderColor: slate100,
        shadowColor: slate200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.goalCurrentGoal.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: slate400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goalName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: slate800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AnimatedAmount(
                      amount: targetAmount,
                      formatter: (val) => currencyProvider.getDisplayValue(val),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showResetGoalDialog(context, provider, txProvider),
                    icon: Icon(Icons.refresh_rounded, color: slate400, size: 20),
                    tooltip: AppLocalizations.of(context)!.goalResetBtn,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bar 1: TOPLAM BİRİKİM (KASADAKİ)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.goalTotalSavings.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: slate400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedAmount(
                amount: realizedSavings,
                formatter: (val) => currencyProvider.getDisplayValue(val),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
              color: slate100,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                // Main Background Bar
                Container(
                  height: 32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: slate100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // Progress Fill
                FractionallySizedBox(
                  widthFactor: realizedPercent == 0.0 ? 0.02 : realizedPercent,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: primaryDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        if (is3D)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        if (realizedPercent > 0.1)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '%${(realizedPercent * 100).toInt()}',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Milestones Overlay
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMilestoneMarker(0.0, realizedPercent, primaryDark),
                      _buildMilestoneMarker(0.25, realizedPercent, primaryDark),
                      _buildMilestoneMarker(0.50, realizedPercent, primaryDark),
                      _buildMilestoneMarker(0.75, realizedPercent, primaryDark),
                      _buildMilestoneMarker(1.0, realizedPercent, primaryDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bar 2: BU AYKİ GÖREV (KORUNAN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.goalThisMonthTask.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: slate400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedAmount(
                amount: potentialSavings,
                formatter: (val) => currencyProvider.getDisplayValue(val),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
              color: slate100,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: potentialPercent == 0.0
                      ? 0.02
                      : potentialPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        if (is3D)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        if (potentialPercent > 0.1)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '%${(potentialPercent * 100).toInt()}',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Motivational Math
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.goalRemainingNet.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: slate400,
                        ),
                      ),
                      AnimatedAmount(
                        amount: netRemaining,
                        formatter: (val) => currencyProvider.getDisplayValue(val),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: slate700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.goalIfProtected.toUpperCase(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: slate400,
                        ),
                      ),
                      AnimatedAmount(
                        amount: ifProtectedRemaining,
                        formatter: (val) => currencyProvider.getDisplayValue(val),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Update and Add Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: is3D
                        ? [
                            BoxShadow(
                              color: primaryDark.withValues(alpha: 0.25),
                              offset: const Offset(0, 5),
                              blurRadius: 0,
                            ),
                          ]
                        : [],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      foregroundColor: primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: primaryBorder,
                          width: is3D ? 2 : 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (context) => const TargetGoalUpdateSheet(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.goalUpdateBtn.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: is3D
                        ? [
                            BoxShadow(
                              color: primaryDark,
                              offset: const Offset(0, 5),
                              blurRadius: 0,
                            ),
                          ]
                        : [],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: primaryDark,
                          width: is3D ? 2 : 0,
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _showExtraIncomeDialog(context, provider, currencyProvider),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.goalAddBtn.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneMarker(
    double milestone,
    double currentProgress,
    Color primaryDark,
  ) {
    bool isReached = currentProgress >= milestone;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 14,
          color: isReached ? Colors.amber : Colors.white54,
        ),
      ],
    );
  }

  void _showExtraIncomeDialog(BuildContext context, GoalsProvider provider, CurrencyProvider currencyProvider) {
    final TextEditingController controller = TextEditingController();
    bool isAdding = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.goalBalanceAction),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(
                          AppLocalizations.of(context)!.addIncome,
                          style: TextStyle(
                            color: isAdding
                                ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                                : (isDark ? Colors.white54 : Colors.black54),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isAdding,
                        onSelected: (val) => setState(() => isAdding = true),
                        selectedColor: isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.shade100,
                        backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                        side: BorderSide.none,
                      ),
                      ChoiceChip(
                        label: Text(
                          AppLocalizations.of(context)!.goalWithdrawMoney,
                          style: TextStyle(
                            color: !isAdding
                                ? (isDark ? Colors.red.shade300 : Colors.red.shade800)
                                : (isDark ? Colors.white54 : Colors.black54),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: !isAdding,
                        onSelected: (val) => setState(() => isAdding = false),
                        selectedColor: isDark ? Colors.red.withValues(alpha: 0.2) : Colors.red.shade100,
                        backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.goalEnterAmountHint,
                      prefixText: '${currencyProvider.currency} ',
                      suffixIcon: Icon(
                        isAdding ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isAdding ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.goalCancelBtn.toUpperCase()),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdding ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final amount = double.tryParse(controller.text) ?? 0.0;
                    if (amount > 0) {
                      if (isAdding) {
                        provider.addExtraIncome(amount);
                      } else {
                        provider.withdrawExtramIncome(amount);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(isAdding ? AppLocalizations.of(context)!.goalAddBtn.toUpperCase() : AppLocalizations.of(context)!.goalWithdrawBtn.toUpperCase()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSpendingPowerCard({
    required BuildContext context,
    required GoalsProvider provider,
    required CurrencyProvider currencyProvider,
    required Color primary,
    required Color primaryDark,
    required Color slate100,
    required Color slate200,
    required Color slate400,
    required Color slate800,
    required bool is3D,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 28,
        borderColor: slate100,
        shadowColor: slate200,
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.goalSpendingPower.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: slate400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.goalDailyLimit.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: slate400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withValues(alpha: 0.3), width: 2),
                ),
                child: Icon(Icons.bolt, color: primaryDark),
              ),
            ],
          ),

          const SizedBox(height: 32),

          const SizedBox(height: 12),
          // Simple spending text instead of Gauge
          Column(
            children: [
              AnimatedAmount(
                amount: provider.remainingToday,
                formatter: (val) => currencyProvider.getDisplayValue(val),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w300,
                  color: provider.isOverBudget ? Colors.redAccent : slate800,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 8),
              if (!provider.isOverBudget)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.goalOnTarget.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              if (provider.isOverBudget)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.goalLimitExceeded.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 32),

          // Summary Grid inside the card
          _buildSummaryGrid(
            context: context,
            provider: provider,
            currencyProvider: currencyProvider,
            slate200: slate200,
            slate400: slate400,
            slate800: slate800,
            is3D: is3D,
          ),

          const SizedBox(height: 24),

          // Bottom Action Button inside the card
          Container(
            decoration: BoxDecoration(
              boxShadow: is3D
                  ? [
                      BoxShadow(
                        color: primaryDark.withValues(alpha: 0.3),
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
              borderRadius: BorderRadius.circular(24),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) => const GoalsSettingsSheet(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 24, weight: 900),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.goalEditPlan.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid({
    required BuildContext context,
    required GoalsProvider provider,
    required CurrencyProvider currencyProvider,
    required Color slate200,
    required Color slate400,
    required Color slate800,
    required bool is3D,
  }) {
    void openSettings() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => const GoalsSettingsSheet(),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.payments,
            iconColor: Colors.green[500]!,
            iconBgColor: Colors.green[100]!,
            iconBorderColor: Colors.green[200]!,
            title: AppLocalizations.of(context)!.goalDistributable.toUpperCase(),
            amount: provider.distributableBalance,
            currencyProvider: currencyProvider,
            slate200: slate200,
            slate400: slate400,
            slate800: slate800,
            onTap: openSettings,
            context: context,
            is3D: is3D,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.star,
            iconColor: Colors.blue[500]!,
            iconBgColor: Colors.blue[100]!,
            iconBorderColor: Colors.blue[200]!,
            title: AppLocalizations.of(context)!.goalMonthlyTarget.toUpperCase(),
            amount: provider.monthlyTargetSavings,
            currencyProvider: currencyProvider,
            slate200: slate200,
            slate400: slate400,
            slate800: slate800,
            onTap: openSettings,
            context: context,
            is3D: is3D,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.shopping_bag,
            iconColor: Colors.orange[500]!,
            iconBgColor: Colors.orange[100]!,
            iconBorderColor: Colors.orange[200]!,
            title: AppLocalizations.of(context)!.goalDaily.toUpperCase(),
            amount: provider.dailySpendingLimit,
            currencyProvider: currencyProvider,
            slate200: slate200,
            slate400: slate400,
            slate800: slate800,
            onTap: openSettings,
            context: context,
            is3D: is3D,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color iconBorderColor,
    required String title,
    required double amount,
    required CurrencyProvider currencyProvider,
    required Color slate200,
    required Color slate400,
    required Color slate800,
    required VoidCallback onTap,
    required BuildContext context,
    required bool is3D,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: buildCardDecoration(
          context: context,
          is3D: is3D,
          borderRadius: 28,
          borderColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : const Color(0xFFF1F5F9),
          shadowColor: slate200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
                border: is3D
                    ? Border(
                        bottom: BorderSide(color: iconBorderColor, width: 2),
                      )
                    : null,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: slate400,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedAmount(
                amount: amount,
                formatter: (val) => currencyProvider.getDisplayValue(val),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: slate800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showResetGoalDialog(
    BuildContext context,
    GoalsProvider provider,
    TransactionProvider txProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.goalResetTitle),
          content: Text(
            AppLocalizations.of(context)!.goalResetDesc,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.goalCancelBtn.toUpperCase()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                provider.resetGoal(txProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.goalResetSuccessMsg),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.goalResetBtn.toUpperCase()),
            ),
          ],
        );
      },
    );
  }
}
