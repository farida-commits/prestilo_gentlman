// features/clients/data/datasources/client_local_datasource.dart
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import 'package:hive/hive.dart';

class ClientLocalDataSource {
  static const String boxName = 'clients_box';

  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<List<ClientEntity>> getAllClients() async {
    final box = await _openBox();
    return box.values
        .map((e) => ClientEntity.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveClient(ClientEntity client) async {
    final box = await _openBox();
    await box.put(client.id, client.toMap());
  }

  Future<void> deleteClient(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}