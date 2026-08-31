// features/suits/data/datasources/suit_local_datasource.dart
import 'package:hive/hive.dart';
import '../../domain/entities/suit_entity.dart';

class SuitLocalDataSource {
  static const String boxName = 'suits_box';

  Future<Box> _openBox() => Hive.openBox(boxName);

  Future<List<SuitEntity>> getAllSuits() async {
    final box = await _openBox();
    return box.values
        .map((e) => SuitEntity.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveSuit(SuitEntity suit) async {
    final box = await _openBox();
    await box.put(suit.id, suit.toMap());
  }

  Future<void> deleteSuit(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<bool> isEmpty() async {
    final box = await _openBox();
    return box.isEmpty;
  }

  Future<void> seedMockData(List<SuitEntity> mockSuits) async {
    final box = await _openBox();
    for (final suit in mockSuits) {
      await box.put(suit.id, suit.toMap());
    }
  }
}