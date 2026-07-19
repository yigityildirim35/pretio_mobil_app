import 'package:flutter/material.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';

class BudgetProgressCard extends StatelessWidget {
  final double weeklySpent;
  final double weeklyLimit;
  final String weekDateRange;
  final double monthlySpent;
  final double monthlyLimit;
  final String monthDateRange;

  const BudgetProgressCard({
    super.key,
    required this.weeklySpent,
    required this.weeklyLimit,
    required this.weekDateRange,
    required this.monthlySpent,
    required this.monthlyLimit,
    required this.monthDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    // Values are already passed in the target currency by the Analytics Page.
    // No need to double-convert them here.
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(
        context: context,
        is3D: Provider.of<ThemeProvider>(context).is3DEnabled,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.pie_chart,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.budgetProgress,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weekly Progress
          _buildProgressRow(
            context,
            currencyProvider,
            label: AppLocalizations.of(context)!.weeklyLimit,
            spent: weeklySpent,
            limit: weeklyLimit,
            dateRange: weekDateRange,
            color: Theme.of(context).colorScheme.primary, // Green
          ),
          const SizedBox(height: 24),

          // Monthly Progress
          _buildProgressRow(
            context,
            currencyProvider,
            label: AppLocalizations.of(context)!.monthlyLimit,
            spent: monthlySpent,
            limit: monthlyLimit,
            dateRange: monthDateRange,
            color: Colors.blueAccent, // Blue
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    BuildContext context,
    CurrencyProvider currencyProvider, {
    required String label,
    required double spent,
    required double limit,
    required String dateRange,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final pct = (limit > 0 ? spent / limit : 0.0).clamp(0.0, 1.0);
    final pctString = (pct * 100).toInt();

    // Format numbers
    final String formattedSpent = spent.toInt().toString();
    final String formattedLimit = limit.toInt().toString();
    final String currencySymbol = currencyProvider.currency;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                // Spend / Limit
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                    ),
                    children: [
                      TextSpan(
                        text: currencyProvider.isPrivacyModeEnabled ? '***' : formattedSpent,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: currencyProvider.isPrivacyModeEnabled
                            ? ' / ***'
                            : ' / $formattedLimit $currencySymbol',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$pctString%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateRange,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Progress Bar
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: pct,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    if (is3D)
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: is3D
                    ? Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
