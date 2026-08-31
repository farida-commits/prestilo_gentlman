// features/suits/domain/entities/suit_entity.dart — толук алмаштыр
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
  final String? currentClientId;
  final String? currentClientName;

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
    this.currentClientId,
    this.currentClientName,
  });

  SuitEntity copyWith({
    SuitStatus? status,
    String? dateLabel,
    bool clearDateLabel = false,
    String? currentClientId,
    String? currentClientName,
    bool clearCurrentClient = false,
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
      dateLabel: clearDateLabel ? null : (dateLabel ?? this.dateLabel),
      currentClientId: clearCurrentClient ? null : (currentClientId ?? this.currentClientId),
      currentClientName: clearCurrentClient ? null : (currentClientName ?? this.currentClientName),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'deposit': deposit,
      'fabric': fabric,
      'size': size,
      'description': description,
      'imagePath': imagePath,
      'status': status.name,
      'dateLabel': dateLabel,
      'currentClientId': currentClientId,
      'currentClientName': currentClientName,
    };
  }

  factory SuitEntity.fromMap(Map<String, dynamic> map) {
    return SuitEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String? ?? '',
      price: map['price'] as String? ?? '',
      deposit: map['deposit'] as String? ?? '',
      fabric: map['fabric'] as String? ?? '',
      size: map['size'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imagePath: map['imagePath'] as String,
      status: SuitStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => SuitStatus.inStock,
      ),
      dateLabel: map['dateLabel'] as String?,
      currentClientId: map['currentClientId'] as String?,
      currentClientName: map['currentClientName'] as String?,
    );
  }
}