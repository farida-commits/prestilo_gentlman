// features/clients/presentation/widgets/lease_date_picker_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import 'lease_result.dart';

class LeaseDatePickerDialog extends StatefulWidget {
  final ClientEntity client;

  const LeaseDatePickerDialog({super.key, required this.client});

  @override
  State<LeaseDatePickerDialog> createState() => _LeaseDatePickerDialogState();
}

class _LeaseDatePickerDialogState extends State<LeaseDatePickerDialog> {
  late DateTime _visibleMonth;
  late DateTime _today;
  DateTime? _selectedDate;

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
    if (_selectedDate == null) return false;
    final start = DateTime(_today.year, _today.month, _today.day);
    final end = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
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

    return Dialog(
      backgroundColor: AppColors.navy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                  style: const TextStyle(color: Colors.white, fontFamily: 'Raleway', fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left, color: AppColors.accent),
                    ),
                    IconButton(
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right, color: AppColors.accent),
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
                          child: Text(d, style: const TextStyle(color: Colors.white38, fontSize: 12)),
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
                final bool isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);
                final bool isBetween = _isBetween(date);

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent
                          : (isToday ? Colors.white24 : Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text('$day', style: const TextStyle(color: Colors.white, fontSize: 14)),
                        if (isBetween)
                          Positioned(
                            bottom: 4,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedDate == null
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                          LeaseResult(
                            client: widget.client,
                            startDate: _today,
                            endDate: _selectedDate!,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}