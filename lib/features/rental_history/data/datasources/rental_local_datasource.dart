// features/rental_history/data/datasources/rental_local_datasource.dart
import 'package:hive/hive.dart';
import '../../domain/entities/rental_record_entity.dart';

class RentalLocalDataSource {
  static const String boxName = 'rental_history_box';

  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<List<RentalRecordEntity>> getAllRecords() async {
    final box = await _openBox();
    return box.values
        .map((e) => RentalRecordEntity.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addRecord(RentalRecordEntity record) async {
    final box = await _openBox();
    await box.put(record.id, record.toMap());
  }

  Future<void> deleteRecord(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> deleteRecordsByClient(String clientId) async {
    final box = await _openBox();
    final keysToDelete = box.keys.where((key) {
      final map = Map<String, dynamic>.from(box.get(key) as Map);
      return map['clientId'] == clientId;
    }).toList();
    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}