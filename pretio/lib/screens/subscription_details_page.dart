import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../models/subscription.dart';
import '../features/brand_search/presentation/widgets/brand_logo_avatar.dart';
import 'package:pretio/l10n/app_localizations.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  const SubscriptionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final mutedColor = isDark
        ? Colors.white54
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final borderColor = isDark
        ? Colors.white10
        : theme.dividerColor.withValues(alpha: 0.1);

    final subProvider = Provider.of<SubscriptionProvider>(context);
    final txProvider = Provider.of<TransactionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    // Calculate Monthly Total (prices are stored in TRY, convert to current user currency)
    double monthlyTotal = 0;
    for (var sub in subProvider.subscriptions) {
      final rawPrice = double.tryParse(sub.price) ?? 0.0;
      final convertedPrice = currencyProvider.convertFromBase(
        rawPrice,
        currencyProvider.currency,
      );

      if (sub.cycle == 'Aylık') {
        monthlyTotal += convertedPrice;
      } else if (sub.cycle == 'Yıllık') {
        monthlyTotal += convertedPrice / 12;
      } else {
        monthlyTotal += convertedPrice;
      }
    }
    final monthlyTotalStr = currencyProvider.formatCurrency(
      monthlyTotal,
      currencyProvider.currency,
    );

    double lastMonthTotal = 0;
    double allTimeTotal = 0;
    final now = DateTime.now();
    for (var tx in txProvider.transactions) {
      if (tx.category == 'Abonelik') {
        // tx.amount is already stored in Base Currency (TRY)
        final convertedTxAmount = currencyProvider.convertFromBase(
          tx.amount,
          currencyProvider.currency,
        );
        allTimeTotal += convertedTxAmount;
        if (tx.date.month == now.month && tx.date.year == now.year) {
          // Changed to current month since we want trends for the current period
        }
        if (tx.date.month == (now.month == 1 ? 12 : now.month - 1) &&
            tx.date.year == (now.month == 1 ? now.year - 1 : now.year)) {
          lastMonthTotal += convertedTxAmount;
        }
      }
    }

    final allTimeTotalStr = currencyProvider.formatCurrency(
      allTimeTotal,
      currencyProvider.currency,
    );

    // Trend calculation
    double trendPercentage = 0;
    bool isTrendDown = false;
    if (lastMonthTotal > 0) {
      trendPercentage =
          ((monthlyTotal - lastMonthTotal) / lastMonthTotal).abs() * 100;
      isTrendDown =
          monthlyTotal <= lastMonthTotal; // we want subscriptions to go down
    }

    final sortedSubsByCost = List<Subscription>.from(subProvider.subscriptions);
    sortedSubsByCost.sort((a, b) {
      final rawPriceA = double.tryParse(a.price) ?? 0.0;
      final rawPriceB = double.tryParse(b.price) ?? 0.0;
      double costA = currencyProvider.convertFromBase(
        rawPriceA,
        currencyProvider.currency,
      );
      if (a.cycle == 'Yıllık') costA /= 12;
      double costB = currencyProvider.convertFromBase(
        rawPriceB,
        currencyProvider.currency,
      );
      if (b.cycle == 'Yıllık') costB /= 12;
      return costB.compareTo(costA);
    });

    // Calculate percentages for all subscriptions
    List<Map<String, dynamic>> donutData = [];
    double remainingPercentage = 100.0;

    for (var sub in sortedSubsByCost) {
      final rawPrice = double.tryParse(sub.price) ?? 0.0;
      double cost = currencyProvider.convertFromBase(
        rawPrice,
        currencyProvider.currency,
      );
      if (sub.cycle == 'Yıllık') cost /= 12;
      double percentage = monthlyTotal > 0 ? (cost / monthlyTotal) * 100 : 0;

      donutData.add({'subscription': sub, 'percentage': percentage});
      remainingPercentage -= percentage;
    }

    // Sort subscriptions by days remaining
    final sortedSubsByDays = List<Subscription>.from(subProvider.subscriptions);
    sortedSubsByDays.sort((a, b) {
      int daysA = _calculateDaysRemaining(a.date);
      int daysB = _calculateDaysRemaining(b.date);
      return daysA.compareTo(daysB);
    });

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildDuoButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
            isDark: isDark,
            context: context,
          ),
        ),
        title: Text(
          l10n.monthlyReport,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textColor,
            fontFamily: 'Manrope',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: borderColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Card
            _buildDuoCard(
              context: context,
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.monthlyTotalLabel.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white54 : mutedColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                monthlyTotalStr,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  fontFamily: 'Manrope',
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              l10n.totalSpent,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white54 : mutedColor,
                                letterSpacing: 1.0,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                allTimeTotalStr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: textColor.withValues(alpha: 0.9),
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (trendPercentage > 0)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isTrendDown
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isTrendDown
                                    ? Icons.trending_down
                                    : Icons.trending_up,
                                size: 16,
                                color: isTrendDown
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '%${trendPercentage.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isTrendDown
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.comparedToLastMonth(
                              trendPercentage.toStringAsFixed(0),
                              isTrendDown ? l10n.trendLess : l10n.trendMore,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white30 : mutedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Distribution Card
            if (subProvider.subscriptions.isNotEmpty)
              _buildDuoCard(
                context: context,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subscriptionDistribution,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Donut Chart
                        SizedBox(
                          width: 128,
                          height: 128,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(128, 128),
                                painter: DonutChartPainter(
                                  data: donutData,
                                  remainingPercentage: remainingPercentage,
                                ),
                              ),
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.payments,
                                    color: isDark
                                        ? Colors.white24
                                        : const Color(0xFFE2E8F0),
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        // Legend
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: donutData.map((data) {
                              final Subscription sub = data['subscription'];
                              final double pct = data['percentage'];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: sub.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              sub.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? Colors.white70
                                                    : const Color(0xFF475569),
                                                fontFamily: 'Manrope',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '%${pct.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? Colors.white54
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Upcoming Payments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                l10n.upcomingPayments,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (sortedSubsByDays.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(l10n.noUpcomingPayments),
              )
            else
              _buildPremiumTimeline(
                context: context,
                subscriptions: sortedSubsByDays,
                isDark: isDark,
                currencyProvider: currencyProvider,
                l10n: l10n,
                primaryColor: Theme.of(context).colorScheme.primary,
              ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildDuoButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white10
                : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : const Color(0xFFE2E8F0),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: isDark
                ? Colors.white70
                : Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildDuoCard({
    required Widget child,
    required bool isDark,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : const Color(0xFFE2E8F0),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPremiumTimeline({
    required BuildContext context,
    required List<Subscription> subscriptions,
    required bool isDark,
    required CurrencyProvider currencyProvider,
    required AppLocalizations l10n,
    required Color primaryColor,
  }) {
    return Stack(
      children: [
        // Gradient timeline line
        Positioned(
          left: 27,
          top: 20,
          bottom: 20,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor.withValues(alpha: 0.8),
                  primaryColor.withValues(alpha: 0.3),
                  isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Column(
          children: subscriptions.asMap().entries.map((entry) {
            final index = entry.key;
            final sub = entry.value;
            final daysRemaining = _calculateDaysRemaining(sub.date);
            final isFirst = index == 0;
            final isUrgent = daysRemaining <= 3;
            final isWarning = daysRemaining <= 7 && !isUrgent;
            return _buildPremiumTimelineItem(
              context: context,
              subscription: sub,
              daysRemaining: daysRemaining,
              isFirst: isFirst,
              isUrgent: isUrgent,
              isWarning: isWarning,
              isDark: isDark,
              currencyProvider: currencyProvider,
              l10n: l10n,
              primaryColor: primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPremiumTimelineItem({
    required BuildContext context,
    required Subscription subscription,
    required int daysRemaining,
    required bool isFirst,
    required bool isUrgent,
    required bool isWarning,
    required bool isDark,
    required CurrencyProvider currencyProvider,
    required AppLocalizations l10n,
    required Color primaryColor,
  }) {
    final bgColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? Colors.white38 : const Color(0xFF94A3B8);

    final rawPrice = double.tryParse(subscription.price) ?? 0.0;
    final displayPrice = currencyProvider.formatCurrency(
      currencyProvider.convertFromBase(rawPrice, currencyProvider.currency),
      currencyProvider.currency,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Clean uniform dot — all same size, theme color
          SizedBox(
            width: 56,
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  border: Border.all(
                    color: isDark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black12 : const Color(0xFFEAEFF4),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  subscription.logoUrl != null &&
                          subscription.logoUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: subscription.logoUrl!.startsWith('http')
                              ? BrandLogoAvatar(
                                  networkLogoUrl: subscription.logoUrl!,
                                  domain: '',
                                  size: 38,
                                )
                              : Container(
                                  width: 38,
                                  height: 38,
                                  color: subscription.color.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Icon(
                                    subscription.icon,
                                    color: subscription.color,
                                    size: 18,
                                  ),
                                ),
                        )
                      : Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: subscription.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Icon(
                              subscription.icon,
                              color: subscription.color,
                              size: 18,
                            ),
                          ),
                        ),
                  const SizedBox(width: 12),
                  // Name + days badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subscription.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.daysRemainingText(daysRemaining),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isUrgent ? Colors.red.shade400 : mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Price
                  Text(
                    displayPrice,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textColor,
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

  bool isNaN(num value) => value.isNaN;

  int _calculateDaysRemaining(String dateString) {
    if (dateString == 'Belirtilmedi' || dateString.isEmpty) {
      return 30; // Default fallback
    }

    try {
      final parts = dateString.split('.');
      if (parts.isNotEmpty) {
        final billingDay = int.tryParse(parts[0]) ?? 1;
        final now = DateTime.now();

        DateTime nextBillingDate;
        if (now.day > billingDay) {
          int nextMonth = now.month + 1;
          int nextYear = now.year;
          if (nextMonth > 12) {
            nextMonth = 1;
            nextYear++;
          }
          nextBillingDate = DateTime(nextYear, nextMonth, billingDay);
        } else {
          nextBillingDate = DateTime(now.year, now.month, billingDay);
        }

        return nextBillingDate
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
      }
    } catch (e) {
      // ignore
    }
    return 30;
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double remainingPercentage;

  DonutChartPainter({required this.data, required this.remainingPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw base circle for remaining/other
    final bgPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    if (data.isEmpty) return;

    // Draw slices
    double startAngle = -pi / 2; // Start from top

    for (var slice in data) {
      final double pct = slice['percentage'];
      if (pct <= 0) continue;

      final sweepAngle = (pct / 100) * 2 * pi;
      final Subscription sub = slice['subscription'];

      final paint = Paint()
        ..color = sub.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
