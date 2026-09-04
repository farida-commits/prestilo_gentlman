import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gentleman/features/settings/settings_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../rental_history/data/datasources/rental_local_datasource.dart';
import '../../../rental_history/domain/entities/rental_record_entity.dart';
import '../../../suits/data/datasources/suit_local_datasource.dart';
import '../../../suits/domain/entities/suit_entity.dart';
import '../../../suits/presentation/widgets/suits_bottom_nav.dart';
import '../../../suits/presentation/pages/suits_main_screen.dart';
import '../../../rental_history/presentation/pages/rental_history_main_screen.dart';
import '../widgets/suit_stat_card.dart';
import '../widgets/month_year_picker_dialog.dart';

double _normalizeAngle(double angle) {
  var a = angle % (2 * pi);
  if (a > pi) a -= 2 * pi;
  if (a < -pi) a += 2 * pi;
  return a;
}

Path _buildRoundedSegmentPath({
  required Offset center,
  required double innerRadius,
  required double outerRadius,
  required double startAngle,
  required double endAngle,
  required double cornerRadius,
}) {
  final ringWidth = outerRadius - innerRadius;
  var r = cornerRadius.clamp(0.0, ringWidth / 2 - 0.01);

  Offset pointAt(double radius, double angle, Offset c) =>
      c + Offset(radius * cos(angle), radius * sin(angle));

  Path plainSegment() {
    final p = Path()
      ..moveTo(
        pointAt(outerRadius, startAngle, center).dx,
        pointAt(outerRadius, startAngle, center).dy,
      );
    p.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      endAngle - startAngle,
      false,
    );
    p.lineTo(
      pointAt(innerRadius, endAngle, center).dx,
      pointAt(innerRadius, endAngle, center).dy,
    );
    p.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      endAngle,
      startAngle - endAngle,
      false,
    );
    p.close();
    return p;
  }

  if (r <= 0.01) return plainSegment();

  final phiOuter = asin((r / (outerRadius - r)).clamp(0.0, 1.0));
  final phiInner = asin((r / (innerRadius + r)).clamp(0.0, 1.0));

  if (phiOuter * 2 >= (endAngle - startAngle).abs() ||
      phiInner * 2 >= (endAngle - startAngle).abs()) {
    return plainSegment();
  }

  final a0 = startAngle;
  final a1 = endAngle;

  final oOuterStart =
      center +
      Offset(
        (outerRadius - r) * cos(a0 + phiOuter),
        (outerRadius - r) * sin(a0 + phiOuter),
      );
  final angT2os = a0 - pi / 2;
  final angT1os = a0 + phiOuter;

  final path = Path();
  path.moveTo(
    pointAt(r, angT2os, oOuterStart).dx,
    pointAt(r, angT2os, oOuterStart).dy,
  );
  path.arcTo(
    Rect.fromCircle(center: oOuterStart, radius: r),
    angT2os,
    angT1os - angT2os,
    false,
  );

  path.arcTo(
    Rect.fromCircle(center: center, radius: outerRadius),
    a0 + phiOuter,
    (a1 - phiOuter) - (a0 + phiOuter),
    false,
  );

  final oOuterEnd =
      center +
      Offset(
        (outerRadius - r) * cos(a1 - phiOuter),
        (outerRadius - r) * sin(a1 - phiOuter),
      );
  final angT1oe = a1 - phiOuter;
  final angT2oe = a1 + pi / 2;
  path.arcTo(
    Rect.fromCircle(center: oOuterEnd, radius: r),
    angT1oe,
    angT2oe - angT1oe,
    false,
  );

  final oInnerEnd =
      center +
      Offset(
        (innerRadius + r) * cos(a1 - phiInner),
        (innerRadius + r) * sin(a1 - phiInner),
      );
  final angT2ie = a1 + pi / 2;
  final angT1ie = (a1 - phiInner) + pi;

  path.lineTo(
    pointAt(r, angT2ie, oInnerEnd).dx,
    pointAt(r, angT2ie, oInnerEnd).dy,
  );
  path.arcTo(
    Rect.fromCircle(center: oInnerEnd, radius: r),
    angT2ie,
    _normalizeAngle(angT1ie - angT2ie),
    false,
  );

  path.arcTo(
    Rect.fromCircle(center: center, radius: innerRadius),
    a1 - phiInner,
    (a0 + phiInner) - (a1 - phiInner),
    false,
  );

  final oInnerStart =
      center +
      Offset(
        (innerRadius + r) * cos(a0 + phiInner),
        (innerRadius + r) * sin(a0 + phiInner),
      );
  final angT1is = (a0 + phiInner) + pi;
  final angT2is = a0 - pi / 2;
  path.arcTo(
    Rect.fromCircle(center: oInnerStart, radius: r),
    angT1is,
    _normalizeAngle(angT2is - angT1is),
    false,
  );

  path.close();
  return path;
}

enum StatMetric { profit, rental, overdue }

enum StatPeriod { monthly, annual }

class _SuitStat {
  final String suitId;
  final String suitName;
  final String suitImagePath;
  final double totalProfit;
  final int leaseCount;
  final bool isOverdue;

  _SuitStat({
    required this.suitId,
    required this.suitName,
    required this.suitImagePath,
    required this.totalProfit,
    required this.leaseCount,
    required this.isOverdue,
  });
}

class StatisticsMainScreen extends StatefulWidget {
  const StatisticsMainScreen({super.key});

  @override
  State<StatisticsMainScreen> createState() => _StatisticsMainScreenState();
}

class _StatisticsMainScreenState extends State<StatisticsMainScreen> {
  final RentalLocalDataSource _rentalDataSource = RentalLocalDataSource();
  final SuitLocalDataSource _suitDataSource = SuitLocalDataSource();

  List<RentalRecordEntity> _records = [];
  List<SuitEntity> _suits = [];
  bool _isLoading = true;

  StatPeriod _period = StatPeriod.monthly;
  StatMetric _metric = StatMetric.profit;
  String? _selectedSuitId;

  final DateTime _now = DateTime.now();
  late int _month;
  late int _year;
  bool _customDateSelected = false;

  static const List<Color> _palette = [
    Color(0xFFCDE6FB),
    Color(0xFF3B82D6),

    Color(0xFF37A1ED),
    Color(0xFFC6DDFF),
    Color(0xFF80BCFF),
    Color(0xFF005A99),
    Color(0xFFFFFFFF),
  ];

  @override
  void initState() {
    super.initState();
    _month = _now.month;
    _year = _now.year;
    _load();
  }

  Future<void> _load() async {
    final records = await _rentalDataSource.getAllRecords();
    final suits = await _suitDataSource.getAllSuits();
    setState(() {
      _records = records;
      _suits = suits;
      _isLoading = false;
    });
  }

  DateTime? _parseDate(String s) {
    final parts = s.split('.');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  bool get _hasEnoughData => _records.length >= 1;

  List<RentalRecordEntity> get _periodRecords {
    return _records.where((r) {
      final d = _parseDate(r.rentalDate);
      if (d == null) return false;
      if (_period == StatPeriod.monthly) {
        return d.month == _month && d.year == _year;
      }
      return d.year == _year;
    }).toList();
  }

  List<_SuitStat> get _stats {
    if (_metric == StatMetric.overdue) {
      // Overdue — учурдагы SuitEntity.status боюнча
      final overdueSuits = _suits
          .where((s) => s.status == SuitStatus.overdue)
          .toList();
      return overdueSuits.map((s) {
        final leaseCount = _records.where((r) => r.suitId == s.id).length;
        double profit = 0;
        for (final r in _records.where((r) => r.suitId == s.id)) {
          profit += double.tryParse(r.profit) ?? 0;
        }
        return _SuitStat(
          suitId: s.id,
          suitName: s.name,
          suitImagePath: s.imagePath,
          totalProfit: profit,
          leaseCount: leaseCount,
          isOverdue: true,
        );
      }).toList();
    }

    final grouped = <String, List<RentalRecordEntity>>{};
    for (final r in _periodRecords) {
      grouped.putIfAbsent(r.suitId, () => []).add(r);
    }

    return grouped.entries.map((entry) {
      final list = entry.value;
      final last = list.last;
      double profit = 0;
      for (final r in list) {
        profit += double.tryParse(r.profit) ?? 0;
      }
      final suit = _suits.where((s) => s.id == entry.key).isNotEmpty
          ? _suits.firstWhere((s) => s.id == entry.key)
          : null;
      return _SuitStat(
        suitId: entry.key,
        suitName: last.suitName,
        suitImagePath: last.suitImagePath,
        totalProfit: profit,
        leaseCount: list.length,
        isOverdue: suit?.status == SuitStatus.overdue,
      );
    }).toList();
  }

  double _statValue(_SuitStat s) {
    switch (_metric) {
      case StatMetric.profit:
        return s.totalProfit;
      case StatMetric.rental:
        return s.leaseCount.toDouble();
      case StatMetric.overdue:
        return 1; // ар бир overdue костюм — 1 сектор
    }
  }

  String get _centerLabel {
    final stats = _stats;
    if (stats.isEmpty) {
      if (_metric == StatMetric.overdue) return 'All suits\nreturned on time';
      return '\$0';
    }
    switch (_metric) {
      case StatMetric.profit:
        final total = stats.fold<double>(0, (a, b) => a + b.totalProfit);
        return '\$${total.toStringAsFixed(0)}';
      case StatMetric.rental:
        final total = stats.fold<int>(0, (a, b) => a + b.leaseCount);
        return '$total\nRentals';
      case StatMetric.overdue:
        return '${stats.length}\nOverdue';
    }
  }

  Future<void> _openDatePicker() async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (_) =>
          MonthYearPickerDialog(initialMonth: _month, initialYear: _year),
    );
    if (result != null) {
      setState(() {
        _month = result['month']!;
        _year = result['year']!;
        _customDateSelected = !(_month == _now.month && _year == _now.year);
      });
    }
  }

  static const List<String> _monthNames = [
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgMain,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final stats = _stats;
    // Тандалган суйт биринчи болуп чыгуу үчүн сорттоо
    stats.sort((a, b) {
      if (a.suitId == _selectedSuitId) return -1;
      if (b.suitId == _selectedSuitId) return 1;
      return 0;
    });

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/fon.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.bmain,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Text(
                            'Statistics',
                            style: AppTextStyles.headline28,
                          ),
                        ),
                      ),
                      if (_hasEnoughData) ...[
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _openDatePicker,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.bmain,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Image.asset(
                              'assets/images/calendar.png',
                              color: Colors.white,
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: !_hasEnoughData
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          children: [
                            const SizedBox(height: 16),
                            if (_customDateSelected)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${_monthNames[_month - 1]} $_year',
                                  style: AppTextStyles.title21,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _periodTab('Monthly', StatPeriod.monthly),
                                const SizedBox(width: 20),
                                _periodTab('Annual', StatPeriod.annual),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildChart(stats),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _metricTab('Profit', StatMetric.profit),
                                _metricTab('Rental', StatMetric.rental),
                                _metricTab('Overdue', StatMetric.overdue),
                              ],
                            ),
                            const SizedBox(height: 19),
                            stats.isNotEmpty
                                ? Text(
                                    'Your suits',
                                    style: AppTextStyles.script20,
                                  )
                                : SizedBox(height: 32),
                            ...stats.asMap().entries.map((entry) {
                              final index = entry.key;
                              final s = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SuitStatCard(
                                    suitName: s.suitName,
                                    suitImagePath: s.suitImagePath,
                                    totalProfit: s.totalProfit.toStringAsFixed(
                                      0,
                                    ),
                                    leaseCount: s.leaseCount,
                                    sliceColor:
                                        _palette[index % _palette.length],
                                    isSelected: _selectedSuitId == s.suitId,
                                    status: _suits
                                        .firstWhere(
                                          (suit) => suit.id == s.suitId,
                                          orElse: () => SuitEntity(
                                            id: s.suitId,
                                            name: s.suitName,
                                            brand: '',
                                            price: '',
                                            deposit: '',
                                            fabric: '',
                                            size: '',
                                            description: '',
                                            imagePath: s.suitImagePath,
                                            status: SuitStatus.inStock,
                                          ),
                                        )
                                        .status,
                                    onTap: () => setState(() {
                                      _selectedSuitId =
                                          _selectedSuitId == s.suitId
                                          ? null
                                          : s.suitId;
                                    }),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 90),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SuitsBottomNav(
              currentIndex: 2,
              onTap: (index) {
                if (index == 2) return;
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SuitsMainScreen(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RentalHistoryMainScreen(),
                      ),
                    );
                    break;
                  case 3:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<_SuitStat> stats) {
    return SizedBox(
      height: 269,
      child: Stack(
        alignment: Alignment.center,
        children: [
          stats.isEmpty
              ? const _EmptyRingPlaceholder()
              : _RoundedDonutChart(
                  values: stats.map((s) => _statValue(s)).toList(),
                  colors: List.generate(
                    stats.length,
                    (i) => _palette[i % _palette.length],
                  ),
                  selectedIndex: _selectedSuitId == null
                      ? null
                      : stats.indexWhere((s) => s.suitId == _selectedSuitId),
                  cornerRadius: 5,
                ),
          Text(
            _centerLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline28,
          ),
        ],
      ),
    );
  }

  Widget _periodTab(String label, StatPeriod value) {
    final isActive = _period == value;
    return GestureDetector(
      onTap: () => setState(() => _period = value),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.title21.copyWith(
                color: isActive ? AppColors.accent : Colors.white,
              ),
            ),
            SizedBox(height: 1),
            if (isActive)
              Builder(
                builder: (context) {
                  final textPainter = TextPainter(
                    text: TextSpan(text: label, style: AppTextStyles.title21),
                    textDirection: TextDirection.ltr,
                  )..layout();
                  return Container(
                    height: 2,
                    width: textPainter.width,
                    color: AppColors.accent,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _metricTab(String label, StatMetric value) {
    final isActive = _metric == value;
    return GestureDetector(
      onTap: () => setState(() {
        _metric = value;
        _selectedSuitId = null;
      }),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.title21.copyWith(
                color: isActive ? AppColors.accent : Colors.white,
              ),
            ),
            const SizedBox(height: 1),
            if (isActive)
              Builder(
                builder: (context) {
                  final textPainter = TextPainter(
                    text: TextSpan(text: label, style: AppTextStyles.title21),
                    textDirection: TextDirection.ltr,
                  )..layout();
                  return Container(
                    height: 2,
                    width: textPainter.width,
                    color: AppColors.accent,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bmain,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No statistics', style: AppTextStyles.headline52),
            const SizedBox(height: 8),
            Text(
              'You need to add more than one\nlease for the statistics to appear',
              textAlign: TextAlign.center,
              style: AppTextStyles.body16.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// файлдын аягына (класстардын соңуна) кошуласың — жаңы placeholder widget:
class _EmptyRingPlaceholder extends StatelessWidget {
  const _EmptyRingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(269, 269),
      painter: _EmptyRingPainter(),
    );
  }
}

class _EmptyRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 135.0;
    const strokeWidth = 31.0;
    const innerRadius = outerRadius - strokeWidth;

    const gapDegrees = 1.3;
    final gapRad = gapDegrees * pi / 180;

    final startAngle = gapRad / 2;
    final endAngle = startAngle + (2 * pi) - gapRad;

    final path = _buildRoundedSegmentPath(
      center: center,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      startAngle: startAngle,
      endAngle: endAngle,
      cornerRadius: 5,
    );

    final paint = Paint()
      ..color = const Color(0xFF141927)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EmptyRingPainter oldDelegate) => false;
}

// _RoundedDonutChart виджети — PieChart ордуна колдонобуз
class _RoundedDonutChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final int? selectedIndex;
  final double cornerRadius;

  const _RoundedDonutChart({
    required this.values,
    required this.colors,
    this.selectedIndex,
    this.cornerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(269, 269),
      painter: _DonutPainter(
        values: values,
        colors: colors,
        selectedIndex: selectedIndex,
        cornerRadius: cornerRadius,
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final int? selectedIndex;
  final double cornerRadius;

  _DonutPainter({
    required this.values,
    required this.colors,
    this.selectedIndex,
    this.cornerRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    const gapDegrees = 1.8;
    final gapRad = gapDegrees * 3.14159 / 180;

    const outerRadius = 135.0;
    const strokeWidth = 31.0;
    const innerRadius = outerRadius - strokeWidth;
    const explodeOffset = 8.0; // сыртка карай канча пиксел жылат

    double startAngle = -3.14159 / 2;

    for (int i = 0; i < values.length; i++) {
      final isSelected = i == selectedIndex;

      final sweep = (values[i] / total) * (2 * 3.14159) - gapRad;
      final segStart = startAngle + gapRad / 2;
      final segEnd = segStart + sweep;

      final path = _buildRoundedSegment(
        center: center,
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        startAngle: segStart,
        endAngle: segEnd,
        cornerRadius: cornerRadius,
      );

      final paint = Paint()
        ..color = isSelected ? Colors.white : colors[i % colors.length]
        ..style = PaintingStyle.fill;

      if (isSelected) {
        final midAngle = (segStart + segEnd) / 2;
        final dx = explodeOffset * cos(midAngle);
        final dy = explodeOffset * sin(midAngle);

        canvas.save();
        canvas.translate(dx, dy);
        canvas.drawPath(path, paint);
        canvas.restore();
      } else {
        canvas.drawPath(path, paint);
      }

      startAngle += (values[i] / total) * (2 * 3.14159);
    }
  }

  double _normalize(double angle) {
    var a = angle % (2 * pi);
    if (a > pi) a -= 2 * pi;
    if (a < -pi) a += 2 * pi;
    return a;
  }

  Path _buildRoundedSegment({
    required Offset center,
    required double innerRadius,
    required double outerRadius,
    required double startAngle,
    required double endAngle,
    required double cornerRadius,
  }) {
    final ringWidth = outerRadius - innerRadius;
    var r = cornerRadius.clamp(0.0, ringWidth / 2 - 0.01);

    Offset pointAt(double radius, double angle, Offset c) =>
        c + Offset(radius * cos(angle), radius * sin(angle));

    Path plainSegment() {
      final p = Path()
        ..moveTo(
          pointAt(outerRadius, startAngle, center).dx,
          pointAt(outerRadius, startAngle, center).dy,
        );
      p.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        endAngle - startAngle,
        false,
      );
      p.lineTo(
        pointAt(innerRadius, endAngle, center).dx,
        pointAt(innerRadius, endAngle, center).dy,
      );
      p.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        endAngle,
        startAngle - endAngle,
        false,
      );
      p.close();
      return p;
    }

    if (r <= 0.01) return plainSegment();

    final phiOuter = asin((r / (outerRadius - r)).clamp(0.0, 1.0));
    final phiInner = asin((r / (innerRadius + r)).clamp(0.0, 1.0));

    if (phiOuter * 2 >= (endAngle - startAngle).abs() ||
        phiInner * 2 >= (endAngle - startAngle).abs()) {
      return plainSegment();
    }

    final a0 = startAngle;
    final a1 = endAngle;

    final oOuterStart =
        center +
        Offset(
          (outerRadius - r) * cos(a0 + phiOuter),
          (outerRadius - r) * sin(a0 + phiOuter),
        );
    final angT2os = a0 - pi / 2;
    final angT1os = a0 + phiOuter;

    final path = Path();
    path.moveTo(
      pointAt(r, angT2os, oOuterStart).dx,
      pointAt(r, angT2os, oOuterStart).dy,
    );
    path.arcTo(
      Rect.fromCircle(center: oOuterStart, radius: r),
      angT2os,
      angT1os - angT2os,
      false,
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      a0 + phiOuter,
      (a1 - phiOuter) - (a0 + phiOuter),
      false,
    );

    final oOuterEnd =
        center +
        Offset(
          (outerRadius - r) * cos(a1 - phiOuter),
          (outerRadius - r) * sin(a1 - phiOuter),
        );
    final angT1oe = a1 - phiOuter;
    final angT2oe = a1 + pi / 2;
    path.arcTo(
      Rect.fromCircle(center: oOuterEnd, radius: r),
      angT1oe,
      angT2oe - angT1oe,
      false,
    );

    final oInnerEnd =
        center +
        Offset(
          (innerRadius + r) * cos(a1 - phiInner),
          (innerRadius + r) * sin(a1 - phiInner),
        );
    final angT2ie = a1 + pi / 2;
    final angT1ie = (a1 - phiInner) + pi;

    path.lineTo(
      pointAt(r, angT2ie, oInnerEnd).dx,
      pointAt(r, angT2ie, oInnerEnd).dy,
    );
    path.arcTo(
      Rect.fromCircle(center: oInnerEnd, radius: r),
      angT2ie,
      _normalize(angT1ie - angT2ie),
      false,
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      a1 - phiInner,
      (a0 + phiInner) - (a1 - phiInner),
      false,
    );

    final oInnerStart =
        center +
        Offset(
          (innerRadius + r) * cos(a0 + phiInner),
          (innerRadius + r) * sin(a0 + phiInner),
        );
    final angT1is = (a0 + phiInner) + pi;
    final angT2is = a0 - pi / 2;
    path.arcTo(
      Rect.fromCircle(center: oInnerStart, radius: r),
      angT1is,
      _normalize(angT2is - angT1is),
      false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}
