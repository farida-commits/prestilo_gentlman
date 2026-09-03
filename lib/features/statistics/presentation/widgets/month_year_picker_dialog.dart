import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final int initialMonth; // 1-12
  final int initialYear;

  const MonthYearPickerDialog({
    super.key,
    required this.initialMonth,
    required this.initialYear,
  });

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  late int _month;
  late int _year;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  final List<int> _years = List.generate(10, (i) => 2021 + i);

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _year = widget.initialYear;
    _monthController = FixedExtentScrollController(initialItem: _month - 1);
    _yearController = FixedExtentScrollController(
      initialItem: _years.indexOf(_year).clamp(0, _years.length - 1),
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const Text('Select a month', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _monthController,
                      itemExtent: 40,
                      diameterRatio: 1.6,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _month = i + 1),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _months.length,
                        builder: (context, i) {
                          final selected = i == _month - 1;
                          return Container(
                            alignment: Alignment.center,
                            decoration: selected
                                ? BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8))
                                : null,
                            child: Text(
                              _months[i],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white54,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                fontSize: selected ? 18 : 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _yearController,
                      itemExtent: 40,
                      diameterRatio: 1.6,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _year = _years[i]),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _years.length,
                        builder: (context, i) {
                          final selected = _years[i] == _year;
                          return Container(
                            alignment: Alignment.center,
                            decoration: selected
                                ? BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8))
                                : null,
                            child: Text(
                              '${_years[i]}',
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white54,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                fontSize: selected ? 18 : 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, {'month': _month, 'year': _year}),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Select', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}