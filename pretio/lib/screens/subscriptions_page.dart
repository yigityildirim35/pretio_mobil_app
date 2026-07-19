import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/currency_provider.dart';
import '../models/subscription.dart';
import 'add_subscription_page.dart';
import 'subscription_details_page.dart';
import 'dart:io';
import '../features/brand_search/presentation/widgets/brand_logo_avatar.dart';
import '../widgets/animated_amount.dart';
import '../utils/card_decoration.dart';
import '../providers/theme_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final cardBgColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);
    final primaryColor = theme.colorScheme.primary;

    final subProvider = Provider.of<SubscriptionProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    final l10n = AppLocalizations.of(context)!;

    // Calculate Monthly Total (prices are stored in TRY, convert to current user currency)
    double monthlyTotal = 0;
    for (var sub in subProvider.subscriptions) {
      final rawPrice = double.tryParse(sub.price) ?? 0.0;
      final convertedPrice = currencyProvider.convertFromBase(rawPrice, currencyProvider.currency);
      
      if (sub.cycle == 'Aylık') {
        monthlyTotal += convertedPrice;
      } else if (sub.cycle == 'Yıllık') {
        monthlyTotal += convertedPrice / 12;
      } else {
        monthlyTotal += convertedPrice;
      }
    }

    // Calculate distribution
    final distributionChildren = <Widget>[];
    if (monthlyTotal > 0) {
      final sortedSubsForDist = List<Subscription>.from(
        subProvider.subscriptions,
      );
      sortedSubsForDist.sort((a, b) {
        double costA = double.tryParse(a.price) ?? 0;
        if (a.cycle == 'Yıllık') costA /= 12;
        double costB = double.tryParse(b.price) ?? 0;
        if (b.cycle == 'Yıllık') costB /= 12;
        return costB.compareTo(costA);
      });

      for (var sub in sortedSubsForDist) {
        final rawPrice = double.tryParse(sub.price) ?? 0.0;
        final convertedPrice = currencyProvider.convertFromBase(rawPrice, currencyProvider.currency);
        
        double subMonthly = 0;
        if (sub.cycle == 'Aylık') {
          subMonthly = convertedPrice;
        } else if (sub.cycle == 'Yıllık') {
          subMonthly = convertedPrice / 12;
        } else {
          subMonthly = convertedPrice;
        }

        if (subMonthly > 0) {
          int flex = ((subMonthly / monthlyTotal) * 1000).round();
          if (flex > 0) {
            distributionChildren.add(
              Expanded(
                flex: flex,
                child: Container(color: sub.color),
              ),
            );
          }
        }
      }
    }

    if (distributionChildren.isEmpty) {
      distributionChildren.add(
        Expanded(
          child: Container(color: isDark ? Colors.white30 : Colors.black26),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: (!isDark && is3D)
                  ? [
                      BoxShadow(
                        color: borderColor,
                        offset: const Offset(0, 2),
                        blurRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          l10n.subscriptionManagement,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        centerTitle: true,
        // Removed actions list
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: borderColor),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: buildCardDecoration(
                    context: context,
                    is3D: is3D,
                    borderRadius: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.monthlyTotalLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: mutedColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AnimatedAmount(
                            amount: monthlyTotal,
                            formatter: (val) => currencyProvider.formatCurrency(
                              val,
                              currencyProvider.currency,
                            ),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.trending_up,
                            color: primaryColor,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.expenseDistribution.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: mutedColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 12,
                                    width: double.infinity,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.black.withValues(alpha: 0.05),
                                    child: Row(children: distributionChildren),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SubscriptionDetailsPage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                border: is3D ? Border(
                                  bottom: BorderSide(
                                    color: isDark
                                        ? Colors.black.withValues(alpha: 0.3)
                                        : Colors.black.withValues(alpha: 0.2),
                                    width: 4,
                                  ),
                                ) : null,
                              ),
                              child: Text(
                                l10n.detailsButton.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.onPrimary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Subscriptions List
                Text(
                  l10n.mySubscriptions,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),

                Consumer<SubscriptionProvider>(
                  builder: (context, subscriptionProvider, child) {
                    final subscriptions = subscriptionProvider.subscriptions;
                    if (subscriptions.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(l10n.noSubscriptionsAdded),
                        ),
                      );
                    }
                    return Column(
                      children: subscriptions.map((subscription) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildSubscriptionItem(
                            context,
                            subscription: subscription,
                            statusText:
                                l10n.onDate(subscription.date), // Simplified text since we don't have calculation logic here yet
                            statusColor: mutedColor,
                            is3D: is3D,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Action Button
          Positioned(
            bottom: 24,
            left: 32, // Increased padding
            right: 32,
            child: Container(
              height: 56, // Shrinked height from 64 to 56
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: is3D ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
                border: is3D ? Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.2),
                    width: 4,
                  ),
                ) : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddSubscriptionPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: theme.colorScheme.onPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.addNewSubscription.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionItem(
    BuildContext context, {
    required Subscription subscription,
    required String statusText,
    required Color statusColor,
    required bool is3D,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final borderColor = theme.dividerColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 20,
      ),
      child: Row(
        children: [
          subscription.logoUrl != null && subscription.logoUrl!.isNotEmpty
              ? (subscription.logoUrl!.startsWith('http')
                    ? BrandLogoAvatar(
                        networkLogoUrl: subscription.logoUrl!,
                        domain: '',
                        size: 56,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(subscription.logoUrl!),
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ))
              : Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: subscription.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: subscription.color.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    subscription.icon,
                    color: subscription.color,
                    size: 28,
                  ),
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          AnimatedAmount(
            amount: () {
              final rawPrice = double.tryParse(subscription.price) ?? 0.0;
              return Provider.of<CurrencyProvider>(context, listen: false)
                  .convertFromBase(rawPrice, Provider.of<CurrencyProvider>(context, listen: false).currency);
            }(),
            formatter: (val) => Provider.of<CurrencyProvider>(context, listen: false)
                .formatCurrency(val, Provider.of<CurrencyProvider>(context, listen: false).currency),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubscriptionPage(
                    isEditing: true,
                    subscription: subscription,
                  ),
                ),
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Icon(
                Icons.edit,
                color: textColor.withValues(alpha: 0.5),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
