// features/clients/presentation/widgets/lease_result.dart
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';

class LeaseResult {
  final ClientEntity client;
  final DateTime startDate;
  final DateTime endDate;

  const LeaseResult({
    required this.client,
    required this.startDate,
    required this.endDate,
  });
}