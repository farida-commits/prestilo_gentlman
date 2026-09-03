class SuitStatEntity {
  final String suitId;
  final String suitName;
  final String suitImagePath;
  final String totalProfit;
  final int leaseCount;
  final bool isOverdue;

  const SuitStatEntity({
    required this.suitId,
    required this.suitName,
    required this.suitImagePath,
    required this.totalProfit,
    required this.leaseCount,
    required this.isOverdue,
  });
}

enum StatMetric { profit, rental, overdue }
enum StatPeriodType { monthly, annual }