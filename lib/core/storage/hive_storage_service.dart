import 'package:hive/hive.dart';

class HiveStorageService {
  Future<void> saveData(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  Future<dynamic> getData(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    return box.get(key);
  }

  Future<void> clear(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}
