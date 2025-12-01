import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A wrapper class around FlutterSecureStorage.
///
/// This class is used to save and load encrypted data
/// related to the most recently entered boat form fields.
/// It fulfills the requirement of using EncryptedSharedPreferences.
class SecurePrefs {
  /// Internal secure storage instance.
  static const storage = FlutterSecureStorage();

  /// Saves the last entered boat information securely.
  ///
  /// The [data] map must contain:
  /// - "year"
  /// - "length"
  /// - "powerType"
  /// - "price"
  /// - "address"
  static Future<void> saveLastBoat(Map<String, String> data) async {
    for (var entry in data.entries) {
      await storage.write(key: entry.key, value: entry.value);
    }
  }

  /// Loads the previously stored boat data.
  ///
  /// Returns a map containing the boat fields.
  static Future<Map<String, String>> loadLastBoat() async {
    final keys = ["year", "length", "powerType", "price", "address"];
    Map<String, String> data = {};

    for (var key in keys) {
      data[key] = await storage.read(key: key) ?? "";
    }

    return data;
  }
}
