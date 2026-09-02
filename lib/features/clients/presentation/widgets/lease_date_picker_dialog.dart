// features/clients/presentation/widgets/lease_date_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:gentleman/core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class LeaseDatePickerCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const LeaseDatePickerCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<LeaseDatePickerCalendar> createState() => _LeaseDatePickerCalendarState();
}

class _LeaseDatePickerCalendarState extends State<LeaseDatePickerCalendar> {
  late DateTime _visibleMonth;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _visibleMonth = DateTime(_today.year, _today.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBetween(DateTime day) {
    final sel = widget.selectedDate;
    if (sel == null) return false;
    final start = DateTime(_today.year, _today.month, _today.day);
    final end = DateTime(sel.year, sel.month, sel.day);
    return day.isAfter(start) && day.isBefore(end);
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday % 7;
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bmain,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.06),
            offset: const Offset(0, 0),
            blurRadius: 100,
            spreadRadius: 0, 
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                style: AppTextStyles.body16.copyWith(color: Colors.white),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(Icons.chevron_left,size: 30, color: AppColors.accent),
                  ),
                  IconButton(
                    onPressed: () => _changeMonth(1),
                    icon: const Icon(Icons.chevron_right, size: 30, color: AppColors.accent),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          Row(
            children: ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: AppTextStyles.body16.copyWith(color: AppColors.grey)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: daysInMonth + firstWeekday,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox();
              final day = index - firstWeekday + 1;
              final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
              final bool isToday = _isSameDay(date, _today);
              final bool isSelected =
                  widget.selectedDate != null && _isSameDay(date, widget.selectedDate!);
              final bool isBetween = _isBetween(date);

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : (isToday ? Color(0xff404859) : Colors.transparent),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$day', style: AppTextStyles.body16.copyWith(color: Colors.white)),
                      SizedBox(height: 4,),
                        SizedBox(
                          width: 5,
                          height: 5,
                          child: isBetween
                          ? const DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          )
                          : null,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}