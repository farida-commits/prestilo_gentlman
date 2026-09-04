import 'package:flutter/material.dart';
import 'package:gentleman/core/constants/app_text_styles.dart';
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

  Future<void> _openYearPicker() async {
  final picked = await showDialog<int>(
    context: context,
    builder: (_) => _YearGridDialog(years: _years, selectedYear: _year),
  );
  if (picked != null) {
    setState(() => _year = picked);
    _yearController.jumpToItem(_years.indexOf(picked));
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bmain,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Row(
                children: [
                  const SizedBox(width: 24,),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select a month',
                        style: AppTextStyles.title21,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 35,
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          controller: _monthController,
                          itemExtent: 40,
                          diameterRatio: 1.6,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (i) =>
                              setState(() => _month = i + 1),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: _months.length,
                            builder: (context, i) {
                              final selected = i == _month - 1;
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  _months[i],
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.white54,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    fontSize: selected ? 18 : 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openYearPicker,
                          child: ListWheelScrollView.useDelegate(
                            controller: _yearController,
                            itemExtent: 40,
                            diameterRatio: 1.6,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (i) =>
                                setState(() => _year = _years[i]),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: _years.length,
                              builder: (context, i) {
                                final selected = _years[i] == _year;
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${_years[i]}',
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.white54,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      fontSize: selected ? 18 : 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, {'month': _month, 'year': _year}),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearGridDialog extends StatefulWidget {
  final List<int> years;
  final int selectedYear;

  const _YearGridDialog({required this.years, required this.selectedYear});

  @override
  State<_YearGridDialog> createState() => _YearGridDialogState();
}

class _YearGridDialogState extends State<_YearGridDialog> {
  late int _year;
  late FixedExtentScrollController _yearController;

  @override
  void initState() {
    super.initState();
    _year = widget.selectedYear;
    _yearController = FixedExtentScrollController(
      initialItem: widget.years.indexOf(_year).clamp(0, widget.years.length - 1),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bmain,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select a year',
                        style: AppTextStyles.title21,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 19),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: _yearController,
                    itemExtent: 40,
                    diameterRatio: 1.6,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (i) => setState(() => _year = widget.years[i]),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: widget.years.length,
                      builder: (context, i) {
                        final selected = widget.years[i] == _year;
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.years[i]}',
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
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _year),
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