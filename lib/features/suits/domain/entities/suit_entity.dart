// features/suits/domain/entities/suit_entity.dart
enum SuitStatus { inStock, leased, overdue }

class SuitEntity {
  final String id;
  final String name;
  final String brand;
  final String price;
  final String deposit;
  final String fabric;
  final String size;
  final String description;
  final String imagePath;
  final SuitStatus status;
  final String? dateLabel;

  const SuitEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.deposit,
    required this.fabric,
    required this.size,
    required this.description,
    required this.imagePath,
    required this.status,
    this.dateLabel,
  });

  SuitEntity copyWith({
    SuitStatus? status,
    String? dateLabel,
    bool clearDateLabel = false,
  }) {
    return SuitEntity(
      id: id,
      name: name,
      brand: brand,
      price: price,
      deposit: deposit,
      fabric: fabric,
      size: size,
      description: description,
      imagePath: imagePath,
      status: status ?? this.status,
      dateLabel: dateLabel ?? this.dateLabel,
    );
  }
}