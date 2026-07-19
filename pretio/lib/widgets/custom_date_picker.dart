import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretio/l10n/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _currentDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  void _onMonthChanged(int months) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + months,
      );
    });
  }

  void _onDateSelected(DateTime date) {
    if (date.isAfter(widget.lastDate)) return;
    setState(() {
      _currentDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(
        0xFFF1F5F2,
      ), // Light greenish/grey bg from image
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarih seçin', // Header from image
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('d MMMM EEE', locale).format(_currentDate),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.edit, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
          const Divider(height: 1),

          // MONTH SELECTOR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('MMMM yyyy', locale).format(_displayedMonth),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _onMonthChanged(-1),
                      color: Colors.grey[600],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed:
                          _displayedMonth.month == DateTime.now().month &&
                              _displayedMonth.year == DateTime.now().year
                          ? null // Disable next month if current month is present
                          : () => _onMonthChanged(1),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CALENDAR GRID
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCalendarGrid(theme, locale),
          ),

          const SizedBox(height: 24),

          // ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary, // Green color from image
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context, _currentDate),
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary, // Green color from image
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme, String locale) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstDayOffset =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    // Weekday headers using locale-aware short day names
    // Generate Mon-Sun labels from DateFormat based on current locale
    final baseMonday = DateTime(2024, 1, 1); // This is a Monday
    final weekDays = List.generate(7, (i) {
      final day = baseMonday.add(Duration(days: i));
      return DateFormat('EEE', locale).format(day).substring(0, 1).toUpperCase();
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map(
                (d) => SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + firstDayOffset,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 0,
            childAspectRatio: 1, // Square cells
          ),
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox();

            final day = index - firstDayOffset + 1;
            final date = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              day,
            );
            final isSelected = DateUtils.isSameDay(date, _currentDate);
            final isToday = DateUtils.isSameDay(date, DateTime.now());
            final isFuture = date.isAfter(widget.lastDate);

            return InkWell(
              onTap: isFuture ? null : () => _onDateSelected(date),
              customBorder: const CircleBorder(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : (isToday && !isSelected
                            ? Colors.grey
                            : Colors.transparent),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF112117)
                        : (isFuture
                              ? Colors.grey.withValues(alpha: 0.3)
                              : (isToday && !isSelected
                                    ? Colors.white
                                    : Colors.grey[700])),
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
