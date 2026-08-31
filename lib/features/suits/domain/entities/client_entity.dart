// features/clients/domain/entities/client_entity.dart 
class ClientEntity {
  final String id;
  final String name;
  final String phone;
  final String? photoPath;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.photoPath,
  });

  ClientEntity copyWith({
    String? name,
    String? phone,
    String? photoPath,
    bool clearPhoto = false,
  }) {
    return ClientEntity(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photoPath': photoPath,
    };
  }

  factory ClientEntity.fromMap(Map<String, dynamic> map) {
    return ClientEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String? ?? '',
      photoPath: map['photoPath'] as String?,
    );
  }
}