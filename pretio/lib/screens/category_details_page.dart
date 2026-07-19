import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../models/category_model.dart';

import '../utils/card_decoration.dart';
import 'package:pretio/l10n/app_localizations.dart';

extension StringExtension on String {
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }
}

enum AnalyticsMetric { category, necessity, emotion }

class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({super.key});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  DateTime _selectedDate = DateTime.now();
  AnalyticsMetric _currentView = AnalyticsMetric.category;


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final is3D = context.watch<ThemeProvider>().is3DEnabled;
    final txProvider = context.watch<TransactionProvider>();
    final currencyProvider = context.watch<CurrencyProvider>();

    // Current month data
    final currentMonthTxs = txProvider.transactions.where((tx) =>
        tx.type == 'expense' &&
        tx.date.month == _selectedDate.month &&
        tx.date.year == _selectedDate.year).toList();

    Map<String, double> dataSums = {};
    for (var tx in currentMonthTxs) {
      String key;
      switch (_currentView) {
        case AnalyticsMetric.category:
          bool exists = txProvider.categories.any((c) => c.name.toLowerCase() == tx.category.toLowerCase());
          key = exists ? tx.category : (tx.category == 'Diğer' || tx.category == 'Other' ? 'Other' : (tx.category.toLowerCase() == 'kategorilendirilmemiş' ? 'Kategorilendirilmemiş' : (tx.category == 'Abonelik' || tx.category == 'Abonelikler' || tx.category == 'Subscriptions' ? 'Abonelikler' : 'Deleted Data')));
          break;
        case AnalyticsMetric.necessity:
          key = _getCanonicalNecessityKey(tx.necessity);
          break;
        case AnalyticsMetric.emotion:
          key = _getCanonicalEmotionKey(tx.emotion);
          break;
      }
      dataSums[key] = (dataSums[key] ?? 0) + tx.amount.abs();
    }

    // Category sums for the list (always show categories)
    Map<String, double> categorySums = {};
    // Per-category metric breakdown
    // Map<CategoryName, Map<MetricValue, Amount>>
    Map<String, Map<String, double>> categoryMetricBreakdown = {};

    for (var tx in currentMonthTxs) {
      bool exists = txProvider.categories.any((c) => c.name.toLowerCase() == tx.category.toLowerCase());
      String catKey = exists ? tx.category : (tx.category == 'Diğer' || tx.category == 'Other' ? 'Other' : (tx.category.toLowerCase() == 'kategorilendirilmemiş' ? 'Kategorilendirilmemiş' : (tx.category == 'Abonelik' || tx.category == 'Abonelikler' || tx.category == 'Subscriptions' ? 'Abonelikler' : 'Deleted Data')));
      
      categorySums[catKey] = (categorySums[catKey] ?? 0) + tx.amount.abs();
      
      if (_currentView != AnalyticsMetric.category) {
        if (!categoryMetricBreakdown.containsKey(catKey)) {
          categoryMetricBreakdown[catKey] = {};
        }
        String metricKey = _currentView == AnalyticsMetric.necessity ? _getCanonicalNecessityKey(tx.necessity) : _getCanonicalEmotionKey(tx.emotion);
        categoryMetricBreakdown[catKey]![metricKey] = 
            (categoryMetricBreakdown[catKey]![metricKey] ?? 0) + tx.amount.abs();
      }
    }

    double totalAmount = dataSums.values.fold(0, (sum, val) => sum + val);

    final sortedCategories = categorySums.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedEntries = dataSums.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Previous month category sums for comparison
    final prevMonthDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    final prevMonthTxs = txProvider.transactions.where((tx) =>
        tx.type == 'expense' &&
        tx.date.month == prevMonthDate.month &&
        tx.date.year == prevMonthDate.year).toList();

    Map<String, double> prevCategorySums = {};
    for (var tx in prevMonthTxs) {
      bool exists = txProvider.categories.any((c) => c.name.toLowerCase() == tx.category.toLowerCase());
      String catKey = exists ? tx.category : (tx.category == 'Diğer' || tx.category == 'Other' ? 'Other' : (tx.category.toLowerCase() == 'kategorilendirilmemiş' ? 'Kategorilendirilmemiş' : (tx.category == 'Abonelik' || tx.category == 'Abonelikler' || tx.category == 'Subscriptions' ? 'Abonelikler' : 'Deleted Data')));
      prevCategorySums[catKey] = (prevCategorySums[catKey] ?? 0) + tx.amount.abs();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            _buildHeader(context, isDark, is3D, theme),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    // Donut Section
                    _buildDonutSection(context, totalAmount, dataSums, sortedEntries, currencyProvider, isDark, is3D, theme),

                    // Filter Tab Buttons
                    _buildFilterTabs(context, theme),

                    const SizedBox(height: 32),

                    // List Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.categories,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...sortedCategories.map((entry) {
                            final catInfo = _getCategoryInfo(entry.key, txProvider.categories);
                            final prevAmount = prevCategorySums[entry.key] ?? 0;
                            final breakdown = categoryMetricBreakdown[entry.key];
                            
                            return _buildMetricCard(
                              context: context,
                              info: catInfo,
                              amount: entry.value,
                              totalAmount: totalAmount,
                              prevAmount: prevAmount,
                              currencyProvider: currencyProvider,
                              isDark: isDark,
                              theme: theme,
                              breakdown: breakdown,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildHeader(BuildContext context, bool isDark, bool is3D, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(_selectedDate).capitalizeWords(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Space to balance the back button
        ],
      ),
    );
  }



  Widget _buildDonutSection(
    BuildContext context,
    double totalAmount,
    Map<String, double> dataSums,
    List<MapEntry<String, double>> sortedEntries,
    CurrencyProvider currencyProvider,
    bool isDark,
    bool is3D,
    ThemeData theme,
  ) {
    return Column(
      children: [
        const SizedBox(height: 32),
        SizedBox(
          height: 180,
          width: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: sortedEntries.map((entry) {
                    final info = _getMetricInfo(context, entry.key, Provider.of<TransactionProvider>(context).categories);
                    return PieChartSectionData(
                      color: info.color,
                      value: entry.value,
                      radius: 30,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalUppercase,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      currencyProvider.isPrivacyModeEnabled
                          ? '***'
                          : currencyProvider.getDisplayValue(totalAmount),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: sortedEntries.take(3).map((entry) {
            final info = _getMetricInfo(context, entry.key, Provider.of<TransactionProvider>(context).categories);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: info.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: info.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    info.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(l10n.emotionalImpact, _currentView == AnalyticsMetric.emotion, theme, () {
            setState(() => _currentView = AnalyticsMetric.emotion);
          })),
          const SizedBox(width: 8),
          Expanded(child: _buildTabButton(l10n.spendingBalance, _currentView == AnalyticsMetric.necessity, theme, () {
            setState(() => _currentView = AnalyticsMetric.necessity);
          })),
          const SizedBox(width: 8),
          Expanded(child: _buildTabButton(l10n.spendingsTab, _currentView == AnalyticsMetric.category, theme, () {
            setState(() => _currentView = AnalyticsMetric.category);
          })),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected, ThemeData theme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required _MetricInfo info,
    required double amount,
    required double totalAmount,
    required double prevAmount,
    required CurrencyProvider currencyProvider,
    required bool isDark,
    required ThemeData theme,
    Map<String, double>? breakdown,
  }) {
    final double percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0;
    
    // Comparison text
    String comparisonText = AppLocalizations.of(context)!.newData;
    Color comparisonColor = Colors.grey;
    if (prevAmount > 0) {
      final diff = ((amount - prevAmount) / prevAmount) * 100;
      if (diff > 0) {
        comparisonText = AppLocalizations.of(context)!.lastMonthPlus(diff.toStringAsFixed(0));
        comparisonColor = Colors.redAccent;
      } else if (diff < 0) {
        comparisonText = AppLocalizations.of(context)!.lastMonthMinus(diff.toStringAsFixed(0));
        comparisonColor = Colors.green;
      } else {
        comparisonText = AppLocalizations.of(context)!.sameAsLastMonth;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: buildCardDecoration(
        context: context,
        is3D: false, // Always flat as requested
        shadowColor: isDark ? Colors.black26 : const Color(0xFFE2E8F0),
      ).copyWith(
        border: Border(
          bottom: BorderSide(color: info.color.withValues(alpha: 0.3), width: 4),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(info.icon, color: info.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    Text(
                      comparisonText,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: comparisonColor),
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
                        : currencyProvider.getDisplayValue(amount),
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  Text(
                    AppLocalizations.of(context)!.categoryBudgetShare(percentage.toStringAsFixed(0)).toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[400],
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (breakdown != null && breakdown.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildBreakdownBar(context, breakdown, amount),
            const SizedBox(height: 12),
          ] else ...[
            // Progress Bar
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (percentage / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: info.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(BuildContext context, Map<String, double> breakdown, double categoryTotal) {
    if (categoryTotal <= 0) return const SizedBox.shrink();
    final categories = Provider.of<TransactionProvider>(context).categories;
    
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 12,
            width: double.infinity,
            color: Colors.grey[200],
            child: Row(
              children: breakdown.entries.map((entry) {
                final ratio = entry.value / categoryTotal;
                final info = _getMetricInfo(context, entry.key, categories);
                return Flexible(
                  flex: (ratio * 1000).toInt(),
                  child: Container(color: info.color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: breakdown.entries.map((entry) {
            final ratio = (entry.value / categoryTotal) * 100;
            final info = _getMetricInfo(context, entry.key, categories);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: info.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(
                  '${info.name}: %${ratio.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  _MetricInfo _getMetricInfo(BuildContext context, String key, List<CategoryModel> categories) {
    switch (_currentView) {
      case AnalyticsMetric.category:
        return _getCategoryInfo(key, categories);
      case AnalyticsMetric.necessity:
        return _getNecessityInfo(context, key);
      case AnalyticsMetric.emotion:
        return _getEmotionInfo(context, key);
    }
  }

  _MetricInfo _getCategoryInfo(String name, List<CategoryModel> categories) {
    final l10n = AppLocalizations.of(context)!;
    try {
      final cat = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
      return _MetricInfo(name: cat.name, color: cat.color, icon: cat.iconData);
    } catch (e) {
      if (name == 'Diğer' || name == 'Other') {
        return _MetricInfo(
          name: l10n.otherCategory,
          color: Colors.pinkAccent,
          icon: Icons.star,
        );
      }
      if (name.toLowerCase() == 'kategorilendirilmemiş') {
        return _MetricInfo(
          name: 'Kategorilendirilmemiş',
          color: Colors.pink,
          icon: Icons.auto_awesome,
        );
      }
      if (name == 'Abonelik' || name == 'Abonelikler' || name == 'Subscriptions') {
        return _MetricInfo(
          name: l10n.subscriptions,
          color: Colors.purpleAccent,
          icon: Icons.autorenew,
        );
      }
      // Return specific info for deleted categories
      return _MetricInfo(
        name: l10n.deletedData,
        color: const Color(0xFFE1BEE7), // Light Purple
        icon: Icons.delete_outline,
      );
    }
  }

  String _getCanonicalNecessityKey(String key) {
    final lowerKey = key.toLowerCase().trim();
    if (lowerKey == 'ihtiyaç' || lowerKey == 'i̇htiyaç' || lowerKey == 'need') {
      return 'need';
    } else if (lowerKey == 'istek' || lowerKey == 'want') {
      return 'want';
    } else if (lowerKey == 'zorunluluk' || lowerKey == 'necessity' || lowerKey == 'obligation') {
      return 'necessity';
    } else if (lowerKey == 'none' || lowerKey.isEmpty) {
      return 'none';
    }
    return lowerKey;
  }

  String _getCanonicalEmotionKey(String key) {
    final lowerKey = key.toLowerCase().trim();
    if (lowerKey == 'mutlu' || lowerKey == 'happy') {
      return 'happy';
    } else if (lowerKey == 'nötr' || lowerKey == 'neutral') {
      return 'neutral';
    } else if (lowerKey == 'pişman' || lowerKey == 'regret') {
      return 'regret';
    } else if (lowerKey == 'none' || lowerKey.isEmpty) {
      return 'none';
    }
    return lowerKey;
  }

  _MetricInfo _getNecessityInfo(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key.toLowerCase()) {
      case 'ihtiyaç':
      case 'need':
        return _MetricInfo(name: l10n.needs, color: Colors.blue, icon: Icons.shopping_cart);
      case 'istek':
      case 'want':
        return _MetricInfo(name: l10n.wants, color: Colors.orange, icon: Icons.star_outline);
      case 'zorunluluk':
      case 'necessity':
      case 'obligation':
        return _MetricInfo(name: l10n.necessity, color: Colors.red, icon: Icons.warning_amber_rounded);
      case 'none':
        return _MetricInfo(name: l10n.notSpecified, color: Colors.grey[400]!, icon: Icons.remove);
      default:
        return _MetricInfo(name: key.capitalizeWords(), color: Colors.grey, icon: Icons.help_outline);
    }
  }

  _MetricInfo _getEmotionInfo(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key.toLowerCase()) {
      case 'mutlu':
      case 'happy':
        return _MetricInfo(name: l10n.happy, color: Colors.green, icon: Icons.sentiment_very_satisfied);
      case 'nötr':
      case 'neutral':
        return _MetricInfo(name: l10n.neutral, color: Colors.blueAccent, icon: Icons.sentiment_neutral);
      case 'pişman':
      case 'regret':
        return _MetricInfo(name: l10n.regret, color: Colors.red, icon: Icons.sentiment_very_dissatisfied);
      case 'none':
        return _MetricInfo(name: l10n.notSpecified, color: Colors.grey[400]!, icon: Icons.remove);
      default:
        return _MetricInfo(name: key.capitalizeWords(), color: Colors.grey, icon: Icons.help_outline);
    }
  }
}

class _MetricInfo {
  final String name;
  final Color color;
  final IconData icon;

  _MetricInfo({required this.name, required this.color, required this.icon});
}
