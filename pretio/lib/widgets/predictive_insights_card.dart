import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pretio/l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../providers/goals_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';
import '../utils/card_decoration.dart';

class PredictiveInsightsCard extends StatelessWidget {
  const PredictiveInsightsCard({super.key});

  int calculateDaysToSavingsGoal(double goalAmount, double dailySavings) {
    if (dailySavings <= 0) return -1;
    // DOĞRU MATEMATİK: Hedef Tutarı / Günlük Ortalama Tasarruf = Kalan Gün
    return (goalAmount / dailySavings).ceil();
  }

  int calculateDaysUntilBudgetEmpty(double remainingBudget, double averageDailySpend) {
    if (averageDailySpend <= 0) return 999;
    // DOĞRU MATEMATİK: Kalan Bütçe / Günlük Ortalama Harcama = Bütçenin Sıfırlanacağı Gün
    return (remainingBudget / averageDailySpend).floor();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final txProvider = Provider.of<TransactionProvider>(context);
    final goalsProvider = Provider.of<GoalsProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;

    final Color slate100 = isDark ? Colors.white10 : const Color(0xFFF1F5F9);
    final Color slate200 = isDark ? Colors.white24 : const Color(0xFFE2E8F0);
    final Color slate400 = isDark ? Colors.white54 : const Color(0xFF94A3B8);

    // Calculate arguments
    DateTime now = DateTime.now();
    int daysPassed = now.day;
    
    // Total spent this month
    double spentThisMonth = txProvider.transactions
        .where((t) => t.type == 'expense' && t.date.year == now.year && t.date.month == now.month && t.category != 'no_spend')
        .fold(0.0, (sum, t) => sum + t.amount);
        
    double averageDailySpend = daysPassed > 0 ? (spentThisMonth / daysPassed) : 0.0;
    
    double budget = txProvider.balanceAtStartOfMonth(now);
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    double dailyIncome = budget / daysInMonth;
    
    double dailySavings = dailyIncome - averageDailySpend;
    double goalAmount = txProvider.shadowGoalAmount - goalsProvider.bigGoalSavings;
    if (goalAmount < 0) goalAmount = 0;
    
    double remainingBudget = txProvider.currentBalance;
    
    int daysToGoal = calculateDaysToSavingsGoal(goalAmount, dailySavings);
    int daysToEmpty = calculateDaysUntilBudgetEmpty(remainingBudget, averageDailySpend);

    // AI INSIGHTS GENERATION
    List<Widget> insightsList = [];

    // 1. Budget Empty Warning
    if (daysToEmpty < 5) {
      insightsList.add(_buildInsightItem(
        context,
        icon: Icons.warning_amber_rounded,
        isWarning: true,
        text: l10n.budgetEmptyWarning(daysToEmpty),
      ));
    }

    // 2. Savings Projection
    double baseTarget = goalsProvider.baseMonthlyTargetSavings;
    double projectedSavings = dailySavings * daysInMonth;
    if (baseTarget > 0) {
      double diff = projectedSavings - baseTarget;
      double diffPercent = (diff.abs() / baseTarget) * 100;
      if (diffPercent > 5) {
        if (diff > 0) {
          insightsList.add(_buildInsightItem(
            context,
            icon: Icons.trending_up,
            isWarning: false,
            text: l10n.insightProjectionGood(diffPercent.toStringAsFixed(1)),
          ));
        } else {
          insightsList.add(_buildInsightItem(
            context,
            icon: Icons.trending_down,
            isWarning: true,
            text: l10n.insightProjectionBad(diffPercent.toStringAsFixed(1)),
          ));
        }
      }
    }

    // 3. Highest Category Alert
    Map<String, double> catTotals = {};
    for (var t in txProvider.transactions) {
      if (t.type == 'expense' && t.date.year == now.year && t.date.month == now.month && t.category != 'no_spend') {
        catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
      }
    }
    if (catTotals.isNotEmpty) {
      var topCat = catTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      if (topCat.value > 0) {
        insightsList.add(_buildInsightItem(
          context,
          icon: Icons.pie_chart,
          isWarning: false,
          text: l10n.insightCategoryAlert(topCat.key),
        ));
      }
    }

    // 4. Streak Alert
    final expenseTxns = txProvider.transactions.where((t) => t.type == 'expense' && t.category != 'no_spend').toList();
    expenseTxns.sort((a,b) => b.date.compareTo(a.date));
    int streak = 0;
    if (expenseTxns.isNotEmpty) {
      final lastDate = expenseTxns.first.date;
      final today = DateTime(now.year, now.month, now.day);
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      streak = today.difference(lastDay).inDays;
    } else {
      streak = 999;
    }
    if (streak > 2 && streak < 100) {
      insightsList.add(_buildInsightItem(
        context,
        icon: Icons.whatshot,
        isWarning: false,
        text: l10n.insightStreak(streak),
      ));
    }

    // Fallback if empty
    if (insightsList.isEmpty) {
      insightsList.add(_buildInsightItem(
        context,
        icon: Icons.track_changes,
        isWarning: daysToGoal == -1,
        text: daysToGoal == -1 
            ? l10n.goalUnreachable
            : l10n.goalReachableDesc(daysToGoal),
      ));
    }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.insightsTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: slate400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Daily Savings Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1)),
            ),
            child: Column(
              children: [
                Text(
                  l10n.dailyAverageSavings.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: slate400,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${currencyProvider.currency} ${currencyProvider.getDisplayValue(dailySavings)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: dailySavings > 0 ? (isDark ? Colors.greenAccent : Colors.green.shade700) : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Render the Insights List
          ...insightsList.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: insight,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, {required IconData icon, required bool isWarning, required String text}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Color textColor = isWarning 
        ? Colors.redAccent 
        : (isDark ? Colors.white70 : Colors.black87);
        
    Color iconColor = isWarning 
        ? Colors.redAccent 
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isWarning ? FontWeight.bold : FontWeight.w600,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
