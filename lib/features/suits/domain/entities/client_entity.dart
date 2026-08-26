// features/clients/domain/entities/client_entity.dart
class ClientEntity {
  final String id;
  final String name;
  final String phone;
  final int loyalty;
  final String favoriteSuit;
  final String imagePath;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.loyalty,
    required this.favoriteSuit,
    required this.imagePath,
  });
}