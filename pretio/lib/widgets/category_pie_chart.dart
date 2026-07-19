import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/card_decoration.dart';
import '../models/category_model.dart';
import 'package:pretio/l10n/app_localizations.dart';

class CategoryPieChart extends StatefulWidget {
  final VoidCallback? onPlusPressed;
  final Map<String, double> categoryData;
  final Map<String, int> categoryCounts; // Transaction counts per category
  final List<CategoryModel> categories;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.categoryCounts,
    required this.categories,
    this.onPlusPressed,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryData.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    double totalAmount = widget.categoryData.values.fold(
      0.0,
      (sum, val) => sum + val,
    );

    Map<String, double> groupedData = {};
    Map<String, int> groupedCounts = {};
    double otherAmount = 0;
    int otherCount = 0;
    double threshold = totalAmount * 0.03; // Group elements < 3%

    for (var entry in widget.categoryData.entries) {
      // Small elements that are not already "Other" or "Deleted Data" get grouped
      if (entry.value < threshold && 
          entry.key != 'Diğer' && entry.key != 'Other' &&
          entry.key != 'Abonelik' && entry.key != 'Abonelikler' && entry.key != 'Subscriptions' &&
          entry.key != 'Silinen Veri' && entry.key != 'Deleted Data') {
        otherAmount += entry.value;
        otherCount += widget.categoryCounts[entry.key] ?? 0;
      } else {
        groupedData[entry.key] = entry.value;
        groupedCounts[entry.key] = widget.categoryCounts[entry.key] ?? 0;
      }
    }

    if (otherAmount > 0) {
      groupedData['Diğer'] = (groupedData['Diğer'] ?? 0) + otherAmount;
      groupedCounts['Diğer'] = (groupedCounts['Diğer'] ?? 0) + otherCount;
    }

    // Sort categories by amount descending
    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Colors palette
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
    ];



    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(context: context, is3D: is3D),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pie_chart_outline,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.categoryDistribution,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (widget.onPlusPressed != null)
                IconButton(
                  onPressed: widget.onPlusPressed,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: List.generate(sortedEntries.length, (i) {
                  final isTouched = i == touchedIndex;
                  final radius = isTouched ? 60.0 : 50.0;
                  final entry = sortedEntries[i];
                  final percent = (entry.value / totalAmount * 100).toInt();
                  Color color;
                  if (entry.key == 'Silinen Veri' || entry.key == 'Deleted Data') {
                    color = const Color(0xFFE1BEE7);
                  } else if (entry.key == 'Diğer' || entry.key == 'Other') {
                    color = Colors.pinkAccent;
                  } else if (entry.key == 'Kategorilendirilmemiş') {
                    color = Colors.pink;
                  } else if (entry.key == 'Abonelik' || entry.key == 'Abonelikler' || entry.key == 'Subscriptions') {
                    color = Colors.purpleAccent;
                  } else {
                    try {
                      color = widget.categories.firstWhere((c) => c.name == entry.key).color;
                    } catch (e) {
                      color = colors[i % colors.length];
                    }
                  }

                  return PieChartSectionData(
                    color: color,
                    value: entry.value,
                    title: '$percent%',
                    showTitle: percent >= 4,
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    badgeWidget: isTouched
                        ? _buildBadge(
                            (entry.key == 'Silinen Veri' || entry.key == 'Deleted Data')
                                ? AppLocalizations.of(context)!.deletedData
                                : (entry.key == 'Diğer' || entry.key == 'Other'
                                    ? AppLocalizations.of(context)!.otherCategory
                                    : (entry.key == 'Abonelik' || entry.key == 'Abonelikler' || entry.key == 'Subscriptions'
                                        ? AppLocalizations.of(context)!.subscriptions
                                        : entry.key)),
                            entry.value,
                            groupedCounts[entry.key] ?? 0,
                            color,
                          )
                        : null,
                    badgePositionPercentageOffset: 1.3,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Legend / Selected Item Details
          if (touchedIndex != -1 && touchedIndex < sortedEntries.length)
            _buildCategoryDetail(
              sortedEntries[touchedIndex].key,
              sortedEntries[touchedIndex].value,
              groupedCounts[sortedEntries[touchedIndex].key] ?? 0,
              theme,
            )
          else
            Text(
              AppLocalizations.of(context)!.tapForDetails,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String category, double amount, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        category,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryDetail(
    String name,
    double amount,
    int count,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          (name == 'Silinen Veri' || name == 'Deleted Data')
              ? AppLocalizations.of(context)!.deletedData
              : (name == 'Diğer' || name == 'Other'
                  ? AppLocalizations.of(context)!.otherCategory
                  : (name == 'Abonelik' || name == 'Abonelikler' || name == 'Subscriptions'
                      ? AppLocalizations.of(context)!.subscriptions
                      : name)),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.transactionCount(count.toString()),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          Provider.of<CurrencyProvider>(context).isPrivacyModeEnabled
              ? '***'
              : '${amount.toInt()} ${Provider.of<CurrencyProvider>(context).currency}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
