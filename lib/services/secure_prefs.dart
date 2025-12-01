import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePrefs {
  static const storage = FlutterSecureStorage();

  static Future<void> saveLastBoat(Map<String, String> data) async {
    for (var entry in data.entries) {
      await storage.write(key: entry.key, value: entry.value);
    }
  }

  static Future<Map<String, String>> loadLastBoat() async {
    final keys = ["year", "length", "powerType", "price", "address"];
    Map<String, String> data = {};

    for (var key in keys) {
      data[key] = await storage.read(key: key) ?? "";
    }
    return data;
  }
}
