// features/rental_history/domain/entities/rental_record_entity.dart
class RentalRecordEntity {
  final String id;
  final String suitId;
  final String suitName;
  final String suitImagePath;
  final String suitBrand;
  final String suitPrice;
  final String suitFabric;
  final String suitSize;
  final String clientId;
  final String clientName;
  final String rentalDate; // dd.MM.yyyy кайтарылган дата
  final String profit;

  const RentalRecordEntity({
    required this.id,
    required this.suitId,
    required this.suitName,
    required this.suitImagePath,
    required this.suitBrand,
    required this.suitPrice,
    required this.suitFabric,
    required this.suitSize,
    required this.clientId,
    required this.clientName,
    required this.rentalDate,
    required this.profit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'suitId': suitId,
      'suitName': suitName,
      'suitImagePath': suitImagePath,
      'suitBrand': suitBrand,
      'suitPrice': suitPrice,
      'suitFabric': suitFabric,
      'suitSize': suitSize,
      'clientId': clientId,
      'clientName': clientName,
      'rentalDate': rentalDate,
      'profit': profit,
    };
  }

  factory RentalRecordEntity.fromMap(Map<String, dynamic> map) {
    return RentalRecordEntity(
      id: map['id'] as String,
      suitId: map['suitId'] as String,
      suitName: map['suitName'] as String,
      suitImagePath: map['suitImagePath'] as String,
      suitBrand: map['suitBrand'] as String? ?? '',
      suitPrice: map['suitPrice'] as String? ?? '',
      suitFabric: map['suitFabric'] as String? ?? '',
      suitSize: map['suitSize'] as String? ?? '',
      clientId: map['clientId'] as String,
      clientName: map['clientName'] as String,
      rentalDate: map['rentalDate'] as String? ?? '',
      profit: map['profit'] as String? ?? '0',
    );
  }
}