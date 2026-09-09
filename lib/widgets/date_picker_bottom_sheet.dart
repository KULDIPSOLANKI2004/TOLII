import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;

  const DatePickerBottomSheet({
    super.key,
    required this.initialDate,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final List<String> _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        1,
      );
    });
  }

  String _formatWeekday(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _formatMonthShort(int month) {
    const monthsShort = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthsShort[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0, Monday = 1 ...

    final prevMonthDays = DateTime(year, month, 0).day;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Select Date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
          const SizedBox(height: 18),

          // Month / Navigation Row (e.g. August 2025  <  >)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_months[month - 1]} $year',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 22,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekdays header S M T W T F S
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((day) {
              return SizedBox(
                width: 38,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Days Grid (6 rows x 7 cols)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              int dayNumber;
              bool isCurrentMonth = true;

              if (index < firstWeekday) {
                // Previous month day
                dayNumber = prevMonthDays - (firstWeekday - index - 1);
                isCurrentMonth = false;
              } else if (index >= firstWeekday + daysInMonth) {
                // Next month day
                dayNumber = index - (firstWeekday + daysInMonth) + 1;
                isCurrentMonth = false;
              } else {
                // Current month day
                dayNumber = index - firstWeekday + 1;
                isCurrentMonth = true;
              }

              final cellDate = isCurrentMonth
                  ? DateTime(year, month, dayNumber)
                  : DateTime(2000, 1, 1);

              final bool isSelected = isCurrentMonth &&
                  cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;

              // Sample dot indicator for specific event dates (e.g. 26, 28)
              final bool hasDot = isCurrentMonth && (dayNumber == 26 || dayNumber == 28);

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          _selectedDate = cellDate;
                        });
                      }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : (isCurrentMonth ? FontWeight.w500 : FontWeight.w400),
                            color: isSelected
                                ? Colors.white
                                : (isCurrentMonth
                                    ? AppColors.textDark
                                    : const Color(0xFFCBD5E1)),
                          ),
                        ),
                      ),
                      if (hasDot && !isSelected)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 6),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Confirm Button
          GestureDetector(
            onTap: () {
              final formatted =
                  '${_formatWeekday(_selectedDate.weekday)}, ${_selectedDate.day} ${_formatMonthShort(_selectedDate.month)}';
              Navigator.of(context).pop({
                'date': _selectedDate,
                'formatted': formatted,
              });
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
