import 'package:flutter/material.dart';
import '../widgets/animated_layered_gauge.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';


import '../providers/transaction_provider.dart';
import '../providers/goals_provider.dart';
import '../services/local_storage_service.dart';
import '../widgets/budget_progress_card.dart';
import '../widgets/need_want_progress_bar.dart';
import '../widgets/emotional_impact_bar.dart';
import '../widgets/category_pie_chart.dart';
import '../providers/currency_provider.dart';
import 'package:pretio/l10n/app_localizations.dart';
import 'dart:math';
import '../widgets/transaction_item.dart';
import '../widgets/add_transaction_sheet.dart';
import '../utils/card_decoration.dart';
import '../providers/theme_provider.dart';
import 'category_details_page.dart';
import '../services/export_service.dart';

// ... Enums ...
enum AnalyticsView { calendar, trends }

enum TrendMetric { emotion, necessity, category }

enum TimeRange { weekly, monthly, yearly }

class _StackItemData {
  final double value;
  final Color color;
  final String label;

  _StackItemData(this.value, this.color, this.label);
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  // ... STATE ...
  AnalyticsView _currentView = AnalyticsView.calendar;
  DateTime _focusedDay = DateTime.now();

  TrendMetric _selectedMetric = TrendMetric.emotion;
  TimeRange _selectedTimeRange = TimeRange.weekly;

  // Cache
  List<BarChartGroupData>? _cachedBarGroups;
  double _cachedMaxY = 0;
  int _cachedTransactionsHash = 0;
  TimeRange? _cachedTimeRange;
  DateTime? _cachedFocusedDay;
  TrendMetric? _cachedMetric;



  // Dashboard panel order
  static const List<String> _defaultPanelOrder = [
    'monthlyAvg',
    'balanceSummary',
    'budgetProgress',
    'needWant',
    'emotionalImpact',
    'categoryPie',
  ];
  List<String> _panelOrder = List.from(_defaultPanelOrder);

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadPanelOrder();
  }

  Future<void> _loadPanelOrder() async {
    final saved = await _storageService.loadPanelOrder();
    if (saved != null && saved.length == _defaultPanelOrder.length && mounted) {
      setState(() {
        _panelOrder = saved;
      });
    }
  }

  void _onPanelReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _panelOrder.removeAt(oldIndex);
      _panelOrder.insert(newIndex, item);
    });
    _storageService.savePanelOrder(_panelOrder);
  }

  // --- Helpers ---

  // Helper for Trends View Date Range
  List<DateTime> _getDateRangeForTrends() {
    DateTime start;
    DateTime end;
    if (_selectedTimeRange == TimeRange.weekly) {
      start = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
      start = DateTime(start.year, start.month, start.day);
      end = start.add(
        const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
      );
    } else if (_selectedTimeRange == TimeRange.monthly) {
      start = DateTime(_focusedDay.year, _focusedDay.month, 1);
      final daysInMonth = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        0,
      ).day;
      end = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        daysInMonth,
        23,
        59,
        59,
      );
    } else {
      start = DateTime(_focusedDay.year, 1, 1);
      end = DateTime(_focusedDay.year, 12, 31, 23, 59, 59);
    }
    return [start, end];
  }

  // Helper to get Active Transactions based on View
  List<Transaction> _getActiveTransactions(List<Transaction> allTransactions) {
    DateTime start;
    DateTime end;

    if (_currentView == AnalyticsView.calendar) {
      // Calendar View: Filter by Focused Month
      start = DateTime(_focusedDay.year, _focusedDay.month, 1);
      final daysInMonth = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        0,
      ).day;
      end = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        daysInMonth,
        23,
        59,
        59,
      );
    } else {
      // Trends View: Filter by Selected Time Range
      final range = _getDateRangeForTrends();
      start = range[0];
      end = range[1];
    }

    return allTransactions
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(end.add(const Duration(seconds: 1))),
        )
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });

    // Güne tıklandığında (aynı gün olsa bile) detay sayfasını aç
    _showDayDetailsSheet(selectedDay);
  }

  void _showDayDetailsSheet(DateTime date) {
    // Gelecek tarih kontrolü: Eğer seçilen gün bugünden sonraysa butonu göstermeyeceğiz.
    final bool isFutureDate = date.isAfter(DateTime.now());

    final transactions = Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).transactions;

    final dayTransactions = transactions
        .where((t) => DateUtils.isSameDay(t.date, date))
        .toList();
    // GÜNLÜK ÖZET HESAPLAMALARI
    final double dayTotal = dayTransactions
        .where((t) => t.type == 'expense' && t.category != 'no_spend')
        .fold(0.0, (sum, t) => sum + t.amount);

    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final dailyLimit = goalsProvider.dailySpendingLimit;

    dayTransactions.sort(
      (a, b) => b.date.compareTo(a.date),
    ); // En yeni en üstte

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar (Gri Çizgi)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- HEADER TASARIMI ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Tarih Formatı: "5 February 2026"
                        DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(date).capitalizeWords(),
                        style: TextStyle(
                          fontSize: 20, // Başlık boyutu
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.transactionCount(dayTransactions.length.toString()),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Yeşil (+) Butonu - Sadece geçmiş veya bugün ise görünür
                  if (!isFutureDate)
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Detay listesini kapat

                        // Ekleme Ekranını SEÇİLEN TARİH ile aç
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (context) => AddTransactionSheet(
                            initialDate:
                                date, // <--- Kritik Nokta: Tarihi paslıyoruz
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary, // Neon Yeşil
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white, // Veya koyu tema için koyu renk
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // GÜNLÜK ÖZET (Harcama ve Bütçe Durumu)
              Builder(
                builder: (context) {
                  final currencyProvider = Provider.of<CurrencyProvider>(context);
                  final l10n = AppLocalizations.of(context)!;
                  
                  // Bütçe Durum Metni ve Rengi
                  String statusText = "";
                  Color statusColor = Colors.grey;

                  if (dailyLimit > 0) {
                    if (dayTotal > dailyLimit) {
                      final double overPercent = ((dayTotal - dailyLimit) / dailyLimit) * 100;
                      statusText = "%${overPercent.toStringAsFixed(0)} ${l10n.overDailyGoal}";
                      statusColor = Colors.red;
                    } else if (dayTotal > 0) {
                      final double underPercent = ((dailyLimit - dayTotal) / dailyLimit) * 100;
                      statusText = "%${underPercent.toStringAsFixed(0)} ${l10n.underDailyGoal}";
                      statusColor = Colors.green;
                    } else {
                      statusText = l10n.noTransactionsYet;
                      statusColor = Colors.grey;
                    }
                  } else {
                    statusText = "-";
                  }

                  final double discretionaryTotal = dayTransactions
                      .where((t) => t.type == 'expense' && t.category != 'no_spend' && t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk')
                      .fold(0.0, (sum, t) => sum + t.amount);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Sol: Harcama Toplamı
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.totalSpending.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyProvider.getDisplayValue(dayTotal),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          // Sağ: Bütçe Durumu
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.budgetProgress.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (discretionaryTotal > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${l10n.discretionarySpending}: ${currencyProvider.getDisplayValue(discretionaryTotal)} (${dailyLimit > 0 ? ((discretionaryTotal / dailyLimit) * 100).toStringAsFixed(0) : 0}%)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                }
              ),

              const SizedBox(height: 16),
              Divider(color: Colors.grey.withValues(alpha: 0.1), thickness: 1),
              const SizedBox(height: 8),

              // --- LİSTE ---
              Expanded(
                child: dayTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noRecordsToday,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: dayTransactions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final t = dayTransactions[index];
                          // Mevcut TransactionItem widget'ını kullanıyoruz
                          return TransactionItem(
                            transaction: t,
                            categories: Provider.of<TransactionProvider>(context, listen: false).categories,
                            onDelete: (tx) {
                              Provider.of<TransactionProvider>(
                                context,
                                listen: false,
                              ).deleteTransaction(tx);
                              Navigator.pop(context);
                            },
                            onEdit: (oldTx, newTx) {
                              Provider.of<TransactionProvider>(
                                context,
                                listen: false,
                              ).editTransaction(oldTx, newTx);
                            },
                            onToggleFavorite: (tx) {
                              Provider.of<TransactionProvider>(
                                context,
                                listen: false,
                              ).toggleFavorite(tx);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ... WIDGET BUILDERS ...
  Widget _buildSegmentedControl(ThemeData theme) {
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: buildCardDecoration(
        context: context,
        is3D: is3D,
        borderRadius: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              AppLocalizations.of(context)!.calendar,
              AnalyticsView.calendar,
              theme,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              AppLocalizations.of(context)!.trends,
              AnalyticsView.trends,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    String label,
    AnalyticsView view,
    ThemeData theme,
  ) {
    final isSelected = _currentView == view;
    return GestureDetector(
      onTap: () {
        setState(() => _currentView = view);
      },
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
            color: isSelected ? theme.colorScheme.onPrimary : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(ThemeData theme) {
    // Only visible in Trends View
    if (_currentView != AnalyticsView.trends) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeRangeButton(
              AppLocalizations.of(context)!.weekly,
              TimeRange.weekly,
              theme,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTimeRangeButton(
              AppLocalizations.of(context)!.monthly,
              TimeRange.monthly,
              theme,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTimeRangeButton(
              AppLocalizations.of(context)!.yearly,
              TimeRange.yearly,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(String label, TimeRange range, ThemeData theme) {
    final isSelected = _selectedTimeRange == range;
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTimeRange = range);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (is3D ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1))
              : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: is3D && isSelected
              ? [
                  BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 0)
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? (is3D ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary)
                : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapView(
    ThemeData theme,
    List<Transaction> transactions,
    double dailyGoal,
    CurrencyProvider currencyProvider, // Received provider
  ) {
    final Map<DateTime, double> dailySpending = {};
    for (var t in transactions) {
      if (t.type == 'expense' && t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk') {
        final date = DateTime(t.date.year, t.date.month, t.date.day);
        dailySpending[date] = (dailySpending[date] ?? 0.0) + t.amount;
      }
    }
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    return Container(
      decoration: buildCardDecoration(context: context, is3D: is3D),
      padding: const EdgeInsets.all(16),
      child: _buildInlineCalendar(
        theme,
        dailyGoal,
        dailySpending,
        currencyProvider,
      ),
    );
  }

  // --- INLINE CALENDAR ---
  Widget _buildInlineCalendar(
    ThemeData theme,
    double dailyGoal,
    Map<DateTime, double> dailySpending,
    CurrencyProvider currencyProvider,
  ) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final daysInMonth = _daysInMonth(_focusedDay);
    final startWeekday = firstDayOfMonth.weekday; // 1=Mon, 7=Sun

    final localeString = Localizations.localeOf(context).languageCode;
    final List<String> dayLabels = List.generate(7, (index) {
      final date = DateTime(2024, 1, 1 + index); // 2024-01-01 was Monday
      return DateFormat('E', localeString).format(date).capitalizeWords();
    });
    final today = DateTime.now();

    // Convert Daily Goal for Gauges
    final displayDailyGoal = currencyProvider.convertFromBase(
      dailyGoal,
      currencyProvider.currency,
    );

    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                  );
                });
              },
            ),
            Text(
              DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(_focusedDay).capitalizeWords(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                  );
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Day headers
        Row(
          children: dayLabels
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: ((startWeekday - 1) + daysInMonth),
          itemBuilder: (context, index) {
            if (index < startWeekday - 1) {
              return const SizedBox();
            }
            final day = index - (startWeekday - 1) + 1;
            final date = DateTime(_focusedDay.year, _focusedDay.month, day);
            final dateKey = DateTime(date.year, date.month, date.day);
            final baseSpent = dailySpending[dateKey] ?? 0;

            // Convert Spent Amount
            final displaySpent = currencyProvider.convertFromBase(
              baseSpent,
              currencyProvider.currency,
            );

            final isToday =
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;

            return AnimatedLayeredGauge(
              spent: displaySpent.toDouble(),
              dailyGoal: displayDailyGoal,
              dayNumber: day,
              isToday: isToday,
              onTap: () => _onDaySelected(date, _focusedDay),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrendsHeader(ThemeData theme) {
    final range = _getDateRangeForTrends();
    final start = range[0];
    final end = range[1];
    String dateText = '';
    if (_selectedTimeRange == TimeRange.weekly) {
      dateText =
          '${DateFormat('MMM d', Localizations.localeOf(context).languageCode).format(start).capitalizeWords()} - ${DateFormat('MMM d, y', Localizations.localeOf(context).languageCode).format(end).capitalizeWords()}';
    } else if (_selectedTimeRange == TimeRange.monthly) {
      dateText = DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(start).capitalizeWords();
    } else {
      dateText = DateFormat('yyyy').format(start);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left, color: theme.iconTheme.color),
          onPressed: () {
            setState(() {
              if (_selectedTimeRange == TimeRange.weekly) {
                _focusedDay = _focusedDay.subtract(const Duration(days: 7));
              } else if (_selectedTimeRange == TimeRange.monthly) {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              } else {
                _focusedDay = DateTime(_focusedDay.year - 1);
              }
            });
          },
        ),
        Expanded(
          child: Text(
            dateText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, color: theme.iconTheme.color),
          onPressed: () {
            setState(() {
              if (_selectedTimeRange == TimeRange.weekly) {
                _focusedDay = _focusedDay.add(const Duration(days: 7));
              } else if (_selectedTimeRange == TimeRange.monthly) {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              } else {
                _focusedDay = DateTime(_focusedDay.year + 1);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildMetricSelector(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMetricChip(
            theme,
            AppLocalizations.of(context)!.moodVsMoney,
            TrendMetric.emotion,
          ),
          const SizedBox(width: 8),
          _buildMetricChip(
            theme,
            AppLocalizations.of(context)!.needVsWant,
            TrendMetric.necessity,
          ),
          const SizedBox(width: 8),
          _buildMetricChip(
            theme,
            AppLocalizations.of(context)!.categories,
            TrendMetric.category,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(ThemeData theme, String label, TrendMetric metric) {
    final isSelected = _selectedMetric == metric;
    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedMetric = metric;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      elevation: is3D && isSelected ? 4 : (is3D && !isSelected ? 1 : 0),
      pressElevation: is3D ? 2 : 0,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      backgroundColor: theme.canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected && !is3D
              ? Colors.transparent
              : is3D && isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildTrendsView(ThemeData theme, List<Transaction> transactions) {
    final range = _getDateRangeForTrends();
    final filteredForChart = transactions
        .where(
          (t) =>
              t.date.isAfter(range[0].subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(range[1].add(const Duration(seconds: 1))),
        )
        .toList();

    // Width Calculation Logic
    int groupsCount = 0;
    double activeBarWidth = 16.0;
    double spacing = 12.0;

    if (_selectedTimeRange == TimeRange.weekly) {
      groupsCount = 7;
      activeBarWidth = 26.0;
      spacing = 4.0;
    } else if (_selectedTimeRange == TimeRange.monthly) {
      groupsCount = _daysInMonth(_focusedDay);
      activeBarWidth = 12.0;
      spacing = 8.0;
    } else {
      groupsCount = 12;
      activeBarWidth = 16.0;
      spacing = 12.0;
    }

    double totalChartWidth =
        (groupsCount * activeBarWidth) + ((groupsCount - 1) * spacing) + 40;

    totalChartWidth = max(
      totalChartWidth,
      MediaQuery.of(context).size.width - 48,
    );

    final is3D = Provider.of<ThemeProvider>(context).is3DEnabled;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildCardDecoration(context: context, is3D: is3D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrendsHeader(theme),
          const SizedBox(height: 16),
          _buildMetricSelector(theme),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: totalChartWidth,
              height: 300,
              padding: const EdgeInsets.only(right: 16),
              child: _buildTrendsChart(theme, filteredForChart),
            ),
          ),
          const SizedBox(height: 16),
          _buildTrendsLegend(theme),
        ],
      ),
    );
  }

  Widget _buildTrendsChart(ThemeData theme, List<Transaction> transactions) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final currentCurrency = currencyProvider.currency;
    final currentHash = transactions.length;

    bool isCacheValid =
        _cachedBarGroups != null &&
        _cachedTimeRange == _selectedTimeRange &&
        DateUtils.isSameDay(_cachedFocusedDay!, _focusedDay) &&
        _cachedMetric == _selectedMetric &&
        _cachedTransactionsHash == currentHash &&
        _cachedCurrency == currentCurrency; // Added currency check

    if (isCacheValid) {
      // Use Cached Data
    } else {
      _calculateChartData(theme, transactions, currencyProvider);
      _cachedTimeRange = _selectedTimeRange;
      _cachedFocusedDay = _focusedDay;
      _cachedMetric = _selectedMetric;
      _cachedTransactionsHash = currentHash;
      _cachedCurrency = currentCurrency;
    }

    double maxY = _cachedMaxY;
    if (maxY == 0) maxY = 100;

    double interval;
    if (maxY < 200) {
      interval = 25;
    } else if (maxY < 1000) {
      interval = 100;
    } else {
      interval = 1000;
    }

    double targetMax = maxY * 1.3;
    double finalMaxY = (targetMax / interval).ceil() * interval;

    if (finalMaxY == 0) finalMaxY = interval;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: finalMaxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey[900]!,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                _buildSmartTooltip(group, transactions),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return _getBottomTitles(value, meta);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox();
                if (value >= finalMaxY * 0.95) return const SizedBox();

                if (value % interval != 0) return const SizedBox();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _cachedBarGroups!,
      ),
    );
  }

  // Added String? _cachedCurrency to state variables needed
  String? _cachedCurrency;

  void _calculateChartData(
    ThemeData theme,
    List<Transaction> transactions,
    CurrencyProvider currencyProvider, // Added provider
  ) {
    List<BarChartGroupData> barGroups = [];
    double tempMaxY = 0;

    double barWidth = 16.0;

    if (_selectedTimeRange == TimeRange.weekly) {
      barWidth = 26.0;
    } else if (_selectedTimeRange == TimeRange.monthly) {
      barWidth = 12.0;
    } else if (_selectedTimeRange == TimeRange.yearly) {
      barWidth = 16.0;
    }

    if (_selectedTimeRange == TimeRange.weekly) {
      final startOfWeek = _focusedDay.subtract(
        Duration(days: _focusedDay.weekday - 1),
      );
      barGroups = List.generate(7, (index) {
        final day = startOfWeek.add(Duration(days: index));
        return _generateBarGroup(
          index,
          day,
          transactions,
          theme,
          (val) => tempMaxY = val > tempMaxY ? val : tempMaxY,
          barWidth,
          currencyProvider,
        );
      });
    } else if (_selectedTimeRange == TimeRange.monthly) {
      final daysInMonth = _daysInMonth(_focusedDay);
      barGroups = List.generate(daysInMonth, (index) {
        final day = DateTime(_focusedDay.year, _focusedDay.month, index + 1);
        return _generateBarGroup(
          index,
          day,
          transactions,
          theme,
          (val) => tempMaxY = val > tempMaxY ? val : tempMaxY,
          barWidth,
          currencyProvider,
        );
      });
    } else {
      barGroups = List.generate(12, (index) {
        final monthDate = DateTime(_focusedDay.year, index + 1, 1);
        return _generateBarGroupMonthly(
          index,
          monthDate,
          transactions,
          theme,
          (val) => tempMaxY = val > tempMaxY ? val : tempMaxY,
          barWidth,
          currencyProvider,
        );
      });
    }

    _cachedBarGroups = barGroups;
    _cachedMaxY = tempMaxY;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.grey,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    String text = '';
    if (_selectedTimeRange == TimeRange.weekly) {
      final startOfWeek = _focusedDay.subtract(
        Duration(days: _focusedDay.weekday - 1),
      );
      final date = startOfWeek.add(Duration(days: value.toInt()));
      text = DateFormat('E', Localizations.localeOf(context).languageCode).format(date);
    } else if (_selectedTimeRange == TimeRange.monthly) {
      if (value.toInt() % 4 == 0 || value.toInt() == 0) {
        text = (value.toInt() + 1).toString();
      }
    } else {
      final date = DateTime(0, value.toInt() + 1);
      text = DateFormat('MMM', Localizations.localeOf(context).languageCode).format(date);
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  BarTooltipItem? _buildSmartTooltip(
    BarChartGroupData group,
    List<Transaction> allTransactions,
  ) {
    DateTime date;
    List<Transaction> txns = [];
    if (_selectedTimeRange == TimeRange.weekly) {
      final startOfWeek = _focusedDay.subtract(
        Duration(days: _focusedDay.weekday - 1),
      );
      date = startOfWeek.add(Duration(days: group.x));
      txns = allTransactions
          .where((t) => DateUtils.isSameDay(t.date, date))
          .toList();
    } else if (_selectedTimeRange == TimeRange.monthly) {
      date = DateTime(_focusedDay.year, _focusedDay.month, group.x + 1);
      txns = allTransactions
          .where((t) => DateUtils.isSameDay(t.date, date))
          .toList();
    } else {
      date = DateTime(_focusedDay.year, group.x + 1, 1);
      txns = allTransactions
          .where((t) => t.date.year == date.year && t.date.month == date.month)
          .toList();
    }

    double totalY = txns.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);

    if (totalY == 0) return null;

    return BarTooltipItem(
      '',
      const TextStyle(fontSize: 0),
      children: [
        TextSpan(
          text: '${DateFormat('MMM d', Localizations.localeOf(context).languageCode).format(date)}\n',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        TextSpan(
          text: Provider.of<CurrencyProvider>(
            context,
            listen: false,
          ).getDisplayValue(totalY),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  BarChartGroupData _generateBarGroup(
    int x,
    DateTime date,
    List<Transaction> allTransactions,
    ThemeData theme,
    Function(double) updateMaxY,
    double width,
    CurrencyProvider currencyProvider,
  ) {
    final dailyTxns = allTransactions
        .where((t) => DateUtils.isSameDay(t.date, date))
        .toList();
    return _buildBarGroupFromTxns(
      x,
      dailyTxns,
      theme,
      updateMaxY,
      width,
      currencyProvider,
    );
  }

  BarChartGroupData _generateBarGroupMonthly(
    int x,
    DateTime monthDate,
    List<Transaction> allTransactions,
    ThemeData theme,
    Function(double) updateMaxY,
    double width,
    CurrencyProvider currencyProvider,
  ) {
    final monthlyTxns = allTransactions
        .where(
          (t) =>
              t.date.year == monthDate.year && t.date.month == monthDate.month,
        )
        .toList();
    return _buildBarGroupFromTxns(
      x,
      monthlyTxns,
      theme,
      updateMaxY,
      width,
      currencyProvider,
    );
  }

  BarChartGroupData _buildBarGroupFromTxns(
    int x,
    List<Transaction> transactions,
    ThemeData theme,
    Function(double) updateMaxY,
    double width,
    CurrencyProvider currencyProvider,
  ) {
    List<_StackItemData> items = [];
    // Calculate totals in BASE currency first
    if (_selectedMetric == TrendMetric.emotion) {
      double happy = 0;
      double neutral = 0;
      double regret = 0;
      double noneEmotion = 0;
    for (var t in transactions) {
      if (t.type != 'expense') continue;
      final emotion = t.emotion.toLowerCase().trim();
        if (emotion == 'happy' || emotion == 'mutlu') {
          happy += t.amount;
        } else if (emotion == 'neutral' || emotion == 'nötr') {
          neutral += t.amount;
        } else if (emotion == 'regret' || emotion == 'pişman') {
          regret += t.amount;
        } else if (emotion == 'none' || emotion.isEmpty) {
          noneEmotion += t.amount;
        }
      }
      // Convert to Display
      if (happy > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(happy, currencyProvider.currency),
            Theme.of(context).colorScheme.primary,
            AppLocalizations.of(context)!.happy,
          ),
        );
      }
      if (neutral > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(
              neutral,
              currencyProvider.currency,
            ),
            Colors.orange,
            AppLocalizations.of(context)!.neutral,
          ),
        );
      }
      if (regret > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(regret, currencyProvider.currency),
            Colors.red,
            AppLocalizations.of(context)!.regret,
          ),
        );
      }
      if (noneEmotion > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(noneEmotion, currencyProvider.currency),
            Colors.grey,
            AppLocalizations.of(context)!.notSpecified,
          ),
        );
      }
    } else if (_selectedMetric == TrendMetric.necessity) {
      double need = 0;
      double want = 0;
      double necessity = 0;
      double noneNecessity = 0;
      for (var t in transactions) {
        if (t.type != 'expense') continue;
        final necessityKey = t.necessity.toLowerCase().trim();
        if (necessityKey == 'need' || necessityKey == 'ihtiyaç' || necessityKey == 'i̇htiyaç') {
          need += t.amount;
        } else if (necessityKey == 'necessity' ||
            necessityKey == 'obligation' ||
            necessityKey == 'zorunluluk') {
          necessity += t.amount;
        } else if (necessityKey == 'none' || necessityKey.isEmpty) {
          noneNecessity += t.amount;
        } else if (necessityKey == 'want' || necessityKey == 'istek') {
          want += t.amount;
        } else {
          want += t.amount; // default to want if unknown
        }
      }
      if (need > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(need, currencyProvider.currency),
            const Color(0xFF26E581),
            AppLocalizations.of(context)!.need,
          ),
        );
      }
      if (necessity > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(
              necessity,
              currencyProvider.currency,
            ),
            const Color(0xFFFF6B6B),
            AppLocalizations.of(context)!.necessity,
          ),
        );
      }
      if (want > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(want, currencyProvider.currency),
            const Color(0xFF7B39ED),
            AppLocalizations.of(context)!.want,
          ),
        );
      }
      if (noneNecessity > 0) {
        items.add(
          _StackItemData(
            currencyProvider.convertFromBase(noneNecessity, currencyProvider.currency),
            Colors.grey,
            AppLocalizations.of(context)!.notSpecified,
          ),
        );
      }
    } else {
      Map<String, double> catTotals = {};
      for (var t in transactions) {
        if (t.type != 'expense') continue;
        catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
      }
      for (var catName in catTotals.keys) {
        final amount = catTotals[catName]!;
        // Convert to Display
        final displayAmount = currencyProvider.convertFromBase(
          amount,
          currencyProvider.currency,
        );

        Color catColor;
        String localizedCatName = catName;
        if (catName == 'Diğer' || catName == 'Other') {
          catColor = Colors.pinkAccent;
          localizedCatName = AppLocalizations.of(context)!.otherCategory;
        } else if (catName == 'Kategorilendirilmemiş') {
          catColor = Colors.pink;
          localizedCatName = 'Kategorilendirilmemiş';
        } else if (catName == 'Silinen Veri' || catName == 'Deleted Data') {
          catColor = const Color(0xFFE1BEE7);
          localizedCatName = AppLocalizations.of(context)!.deletedData;
        } else if (catName == 'Abonelik' || catName == 'Abonelikler' || catName == 'Subscriptions') {
          catColor = Colors.purpleAccent;
          localizedCatName = AppLocalizations.of(context)!.subscriptions;
        } else {
          try {
            catColor = Provider.of<TransactionProvider>(context, listen: false).categories.firstWhere((c) => c.name == catName).color;
          } catch (e) {
            catColor = Colors.grey;
          }
        }
        items.add(_StackItemData(displayAmount, catColor, localizedCatName));
      }
    }

    items.sort((a, b) => b.value.compareTo(a.value));

    List<BarChartRodStackItem> stackItems = [];
    double currentY = 0;

    for (var item in items) {
      stackItems.add(
        BarChartRodStackItem(
          currentY, 
          currentY + item.value, 
          item.color,
          borderSide: BorderSide.none,
        ),
      );
      currentY += item.value;
    }
    final totalY = currentY;

    updateMaxY(totalY);

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: totalY == 0 ? 0.5 : totalY,
          width: width,
          color: Colors.transparent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          rodStackItems: stackItems.isEmpty
              ? [
                  BarChartRodStackItem(
                    0,
                    0.1,
                    Colors.grey.withValues(alpha: 0.1),
                  ),
                ]
              : stackItems,
        ),
      ],
    );
  }

  Widget _buildTrendsLegend(ThemeData theme) {
    if (_selectedMetric == TrendMetric.emotion) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildLegendItem(Theme.of(context).colorScheme.primary, AppLocalizations.of(context)!.happy),
          _buildLegendItem(Colors.orange, AppLocalizations.of(context)!.neutral),
          _buildLegendItem(Colors.red, AppLocalizations.of(context)!.regret),
          _buildLegendItem(Colors.grey, AppLocalizations.of(context)!.notSpecified),
        ],
      );
    } else if (_selectedMetric == TrendMetric.necessity) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildLegendItem(
            const Color(0xFF26E581),
            AppLocalizations.of(context)!.need,
          ),
          _buildLegendItem(
            const Color(0xFF7B39ED),
            AppLocalizations.of(context)!.want,
          ),
          _buildLegendItem(
            const Color(0xFFFF6B6B),
            AppLocalizations.of(context)!.necessity,
          ),
          _buildLegendItem(
            Colors.grey,
            AppLocalizations.of(context)!.notSpecified,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.categories,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPanelWidget(
    String key, {
    required ThemeData theme,
    required CurrencyProvider currencyProvider,
    required TransactionProvider provider,
    required bool isUnder,
    required String status,
    required double baseDailyAvg,
    required double baseDailyAvgSoFar,
    required double baseDiff,
    required double baseMonthlySpent,
    required double baseMonthlyIncome,
    required double displayWeeklySpent,
    required double displayWeeklyLimit,
    required double displayMonthlySpent,
    required double displayMonthlyLimit,
    required double displayNeeds,
    required double displayWants,
    required double displayNecessities,
    required int happy,
    required int neutral,
    required int regret,
    required Map<String, double> displayCatData,
    required Map<String, int> catCounts,
    required bool is3D,
  }) {
    Widget content;
    switch (key) {
      case 'monthlyAvg':
        final bool isDark = theme.brightness == Brightness.dark;
        content = Container(
          padding: const EdgeInsets.all(20),
          decoration: buildCardDecoration(context: context, is3D: is3D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.analytics_outlined, color: theme.colorScheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.monthlyAvg,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isUnder ? Colors.teal : Colors.redAccent).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isUnder ? Colors.teal : Colors.redAccent).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isUnder ? Colors.teal : Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // ACTUAL AVERAGE (SO FAR)
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.averageSoFar,
                          style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              currencyProvider.isPrivacyModeEnabled ? '***' : currencyProvider.getDisplayValue(baseDailyAvgSoFar).replaceAll(RegExp(r'[^\d.,-]'), ''),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (!currencyProvider.isPrivacyModeEnabled)
                              Text(
                                ' ${currencyProvider.currency}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // DIVIDER
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 16),
                  
                  // EXPECTED AVERAGE (OVER WHOLE MONTH)
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.perDay,
                          style: TextStyle(fontSize: 11, color: Colors.grey[400], fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              currencyProvider.isPrivacyModeEnabled ? '***' : currencyProvider.getDisplayValue(baseDailyAvg).replaceAll(RegExp(r'[^\d.,-]'), ''),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            if (!currencyProvider.isPrivacyModeEnabled)
                              Text(
                                ' ${currencyProvider.currency}',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500]),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // STATUS BOTTOM PILL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: (isUnder ? Colors.teal : Colors.redAccent).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isUnder ? Colors.teal : Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isUnder ? Icons.trending_down : Icons.trending_up,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[800], 
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: currencyProvider.getDisplayValue(baseDiff),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: isUnder
                                  ? ' ${AppLocalizations.of(context)!.underDailyGoal}'
                                  : ' ${AppLocalizations.of(context)!.overDailyGoal}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case 'balanceSummary':
        content = Container(
          padding: const EdgeInsets.all(24),
          decoration: buildCardDecoration(context: context, is3D: is3D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.balanceSummary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // Total Pool (Starting + Income) — TOP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalPool,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    currencyProvider.getDisplayValue(
                      provider.balanceAtStartOfMonth(_focusedDay) + baseMonthlyIncome,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Starting / Income / Spent row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Starting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.starting,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.getDisplayValue(
                          provider.balanceAtStartOfMonth(_focusedDay),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  // Income (New)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.income,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[300],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.isPrivacyModeEnabled
                            ? currencyProvider.getDisplayValue(baseMonthlyIncome)
                            : '+${currencyProvider.getDisplayValue(baseMonthlyIncome)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  // Spent
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.spentAmount,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red[300],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyProvider.isPrivacyModeEnabled
                            ? currencyProvider.getDisplayValue(baseMonthlySpent)
                            : '-${currencyProvider.getDisplayValue(baseMonthlySpent)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.remainingBalanceText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      currencyProvider.getDisplayValue(
                        provider.balanceAtStartOfMonth(_focusedDay) + baseMonthlyIncome - baseMonthlySpent,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case 'budgetProgress':
        content = BudgetProgressCard(
          weeklySpent: displayWeeklySpent,
          weeklyLimit: displayWeeklyLimit,
          weekDateRange: '',
          monthlySpent: displayMonthlySpent,
          monthlyLimit: displayMonthlyLimit,
          monthDateRange: DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(_focusedDay),
        );
        break;

      case 'needWant':
        content = NeedWantProgressBar(
          needsAmount: displayNeeds,
          wantsAmount: displayWants,
          necessityAmount: displayNecessities,
        );
        break;

      case 'emotionalImpact':
        content = EmotionalImpactBar(
          happyCount: happy,
          neutralCount: neutral,
          regretCount: regret,
        );
        break;

      case 'categoryPie':
        content = CategoryPieChart(
          categoryData: displayCatData,
          categoryCounts: catCounts,
          categories: provider.categories,
          onPlusPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryDetailsPage()),
            );
          },
        );
        break;

      default:
        content = const SizedBox.shrink();
    }

    return Stack(
      children: [
        content,
        Positioned(
          top: 12,
          right: 12,
          child: _buildDragIndicator(theme),
        ),
      ],
    );
  }

  Widget _buildDragIndicator(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        2, // 2 rows
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3, // 3 dots per row
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        // --- VIEW LOGIC SEPARATION ---
        final currencyProvider = Provider.of<CurrencyProvider>(context);
        final activeTransactions = _getActiveTransactions(
          provider.transactions,
        );
        final activeExpenseTransactions = activeTransactions.where((t) => t.type == 'expense').toList();

        // Calculate totals in Base Currency (TRY) first

        double baseTotalSpentForGoalTracker = activeExpenseTransactions
            .where((t) => t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk')
            .fold(0.0, (sum, t) => sum + t.amount);

        // Logic for Progress Cards / Summary
        int daysInPeriod;
        int daysElapsedInPeriod;
        final now = DateTime.now();

        if (_currentView == AnalyticsView.calendar) {
          final daysInMonth = _daysInMonth(_focusedDay);
          daysInPeriod = daysInMonth;
          if (_focusedDay.year == now.year && _focusedDay.month == now.month) {
            daysElapsedInPeriod = now.day;
          } else if (_focusedDay.isBefore(now)) {
            daysElapsedInPeriod = daysInMonth;
          } else {
            daysElapsedInPeriod = 1;
          }
        } else {
          if (_selectedTimeRange == TimeRange.weekly) {
            daysInPeriod = 7;
            final startOfWeek = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
            // For weekly, only consider exact day if in current week
            if (now.isAfter(startOfWeek) && now.isBefore(startOfWeek.add(const Duration(days: 7)))) {
              daysElapsedInPeriod = now.weekday;
            } else if (now.isAfter(startOfWeek)) {
              daysElapsedInPeriod = 7;
            } else {
              daysElapsedInPeriod = 1;
            }
          } else if (_selectedTimeRange == TimeRange.monthly) {
            final daysInMonth = _daysInMonth(_focusedDay);
            daysInPeriod = daysInMonth;
            if (_focusedDay.year == now.year && _focusedDay.month == now.month) {
              daysElapsedInPeriod = now.day;
            } else if (_focusedDay.isBefore(now)) {
              daysElapsedInPeriod = daysInMonth;
            } else {
              daysElapsedInPeriod = 1;
            }
          } else {
            daysInPeriod = 365;
            if (_focusedDay.year == now.year) {
              daysElapsedInPeriod = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
            } else if (_focusedDay.year < now.year) {
              daysElapsedInPeriod = 365;
            } else {
              daysElapsedInPeriod = 1;
            }
          }
        }

        final baseDailyAvg = daysInPeriod > 0
            ? (baseTotalSpentForGoalTracker / daysInPeriod)
            : 0.0;
        final baseDailyAvgSoFar = daysElapsedInPeriod > 0
            ? (baseTotalSpentForGoalTracker / daysElapsedInPeriod)
            : 0.0;

        final baseDiff = (provider.dailyGoal - baseDailyAvgSoFar).abs();
        final isUnder = baseDailyAvgSoFar <= provider.dailyGoal;
        final status = isUnder
            ? AppLocalizations.of(context)!.onTrack
            : AppLocalizations.of(context)!.overBudget;

        // --- RESTORED AGGREGATION LOGIC ---
        double baseNeeds = 0, baseWants = 0, baseNecessities = 0;
        int happy = 0, neutral = 0, regret = 0;
        Map<String, double> baseCatData = {};
        Map<String, int> catCounts = {};

        for (var t in activeExpenseTransactions) {
          if (t.necessity == 'need') {
            baseNeeds += t.amount;
          } else if (t.necessity == 'necessity' ||
              t.necessity == 'obligation' ||
              t.necessity == 'zorunluluk') {
            baseNecessities += t.amount;
          } else {
            baseWants += t.amount;
          }
          if (t.emotion == 'happy') {
            happy++;
          } else if (t.emotion == 'neutral') {
            neutral++;
          } else if (t.emotion == 'regret') {
            regret++;
          }
          bool exists = provider.categories.any((c) => c.name.toLowerCase() == t.category.toLowerCase());
          String catKey = exists ? t.category : (t.category == 'Diğer' ? 'Diğer' : (t.category == 'Kategorilendirilmemiş' ? 'Kategorilendirilmemiş' : (t.category == 'Abonelik' || t.category == 'Abonelikler' || t.category == 'Subscriptions' ? 'Abonelikler' : 'Silinen Veri')));
          baseCatData[catKey] = (baseCatData[catKey] ?? 0) + t.amount;
          catCounts[catKey] = (catCounts[catKey] ?? 0) + 1;
        }

        // Convert aggregations to Display Currency
        final displayNeeds = currencyProvider.convertFromBase(
          baseNeeds,
          currencyProvider.currency,
        );
        final displayWants = currencyProvider.convertFromBase(
          baseWants,
          currencyProvider.currency,
        );
        final displayNecessities = currencyProvider.convertFromBase(
          baseNecessities,
          currencyProvider.currency,
        );

        final Map<String, double> displayCatData = baseCatData.map((
          key,
          value,
        ) {
          return MapEntry(
            key,
            currencyProvider.convertFromBase(value, currencyProvider.currency),
          );
        });

        // Weekly Params (Base -> Display)
        final baseWeeklySpentForGoal = provider.transactions
            .where(
              (t) =>
                  t.date.isAfter(
                    DateTime.now()
                        .subtract(Duration(days: DateTime.now().weekday - 1))
                        .subtract(const Duration(seconds: 1)),
                  ) &&
                  t.date.isBefore(
                    DateTime.now()
                        .add(Duration(days: 7 - DateTime.now().weekday))
                        .add(
                          const Duration(hours: 23, minutes: 59, seconds: 59),
                        ),
                  ) &&
                  t.type == 'expense' &&
                  t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk',
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final displayWeeklySpent = currencyProvider.convertFromBase(
          baseWeeklySpentForGoal,
          currencyProvider.currency,
        );
        final displayWeeklyLimit = currencyProvider.convertFromBase(
          provider.dailyGoal * 7,
          currencyProvider.currency,
        );

        // Monthly Params
        final baseMonthlySpent = provider.transactions
            .where(
              (t) =>
                  t.type == 'expense' &&
                  t.date.year == _focusedDay.year &&
                  t.date.month == _focusedDay.month,
            )
            .fold(0.0, (sum, t) => sum + t.amount);
            
        final baseMonthlyIncome = provider.transactions
            .where(
              (t) =>
                  t.type == 'income' &&
                  t.date.year == _focusedDay.year &&
                  t.date.month == _focusedDay.month,
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final baseMonthlySpentForGoal = provider.transactions
            .where(
              (t) =>
                  t.type == 'expense' &&
                  t.date.year == _focusedDay.year &&
                  t.date.month == _focusedDay.month &&
                  t.necessity != 'necessity' && t.necessity != 'obligation' && t.necessity != 'zorunluluk',
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        final displayMonthlySpent = currencyProvider.convertFromBase(
          baseMonthlySpentForGoal,
          currencyProvider.currency,
        );
        final displayMonthlyLimit = currencyProvider.convertFromBase(
          provider.dailyGoal * _daysInMonth(_focusedDay),
          currencyProvider.currency,
        );

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.analytics,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (_currentView == AnalyticsView.calendar ||
                                    _selectedTimeRange == TimeRange.weekly ||
                                    _selectedTimeRange == TimeRange.monthly)
                                ? DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(_focusedDay).capitalizeWords()
                                : DateFormat('yyyy', Localizations.localeOf(context).languageCode).format(_focusedDay),
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
                            tooltip: 'Dışa Aktar',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onSelected: (value) {
                              if (value == 'pdf') {
                                ExportService.exportToPdf(
                                  context,
                                  _getActiveTransactions(provider.transactions),
                                  currencyProvider,
                                );
                              } else if (value == 'excel') {
                                ExportService.exportToExcel(
                                  context,
                                  _getActiveTransactions(provider.transactions),
                                  currencyProvider,
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'pdf',
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
                                    const SizedBox(width: 12),
                                    Text('PDF İndir', style: TextStyle(color: theme.colorScheme.onSurface)),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'excel',
                                child: Row(
                                  children: [
                                    const Icon(Icons.table_chart, color: Colors.green, size: 20),
                                    const SizedBox(width: 12),
                                    Text('Excel İndir', style: TextStyle(color: theme.colorScheme.onSurface)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSegmentedControl(theme),
                  _buildTimeRangeSelector(theme),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentView == AnalyticsView.calendar
                        ? _buildHeatmapView(
                            theme,
                            provider.transactions,
                            provider.dailyGoal,
                            currencyProvider, // Pass provider
                          )
                        : _buildTrendsView(theme, provider.transactions),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.dashboard,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- REORDERABLE PANEL LIST ---
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        elevation: 8,
                        color: Colors.transparent,
                        shadowColor: theme.colorScheme.primary.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        child: child,
                      );
                    },
                    onReorder: _onPanelReorder,
                    itemCount: _panelOrder.length,
                    itemBuilder: (context, index) {
                      final key = _panelOrder[index];
                      return Padding(
                        key: ValueKey(key),
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPanelWidget(
                          key,
                          theme: theme,
                          currencyProvider: currencyProvider,
                          provider: provider,
                          isUnder: isUnder,
                          status: status,
                          baseDailyAvg: baseDailyAvg,
                          baseDailyAvgSoFar: baseDailyAvgSoFar,
                          baseDiff: baseDiff,
                          baseMonthlySpent: baseMonthlySpent,
                          baseMonthlyIncome: baseMonthlyIncome,
                          displayWeeklySpent: displayWeeklySpent,
                          displayWeeklyLimit: displayWeeklyLimit,
                          displayMonthlySpent: displayMonthlySpent,
                          displayMonthlyLimit: displayMonthlyLimit,
                          displayNeeds: displayNeeds,
                          displayWants: displayWants,
                          displayNecessities: displayNecessities,
                          happy: happy,
                          neutral: neutral,
                          regret: regret,
                          displayCatData: displayCatData,
                          catCounts: catCounts,
                          is3D: themeProvider.is3DEnabled,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
