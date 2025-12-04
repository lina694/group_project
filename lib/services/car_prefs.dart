import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../models/car.dart';

/// Service class to handle saving and retrieving the last entered Car data.
/// Uses EncryptedSharedPreferences for secure storage.
class CarPrefs {
  /// The instance of the encrypted shared preferences.
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Keys for storing data
  static const String _keyYear = 'last_car_year';
  static const String _keyMake = 'last_car_make';
  static const String _keyModel = 'last_car_model';
  static const String _keyPrice = 'last_car_price';
  static const String _keyKms = 'last_car_kms';

  /// Saves the [Car] details to encrypted storage.
  Future<void> saveLastCar(Car car) async {
    await _prefs.setString(_keyYear, car.year.toString());
    await _prefs.setString(_keyMake, car.make);
    await _prefs.setString(_keyModel, car.model);
    await _prefs.setString(_keyPrice, car.price.toString());
    await _prefs.setString(_keyKms, car.kilometers.toString());
  }

  /// Retrieves the last saved [Car] details.
  /// Returns `null` if no data is found.
  Future<Car?> getLastCar() async {
    String yearStr = await _prefs.getString(_keyYear);
    if (yearStr.isEmpty) return null;

    String make = await _prefs.getString(_keyMake);
    String model = await _prefs.getString(_keyModel);
    String priceStr = await _prefs.getString(_keyPrice);
    String kmsStr = await _prefs.getString(_keyKms);

    return Car(
      year: int.tryParse(yearStr) ?? 2020,
      make: make,
      model: model,
      price: double.tryParse(priceStr) ?? 0.0,
      kilometers: int.tryParse(kmsStr) ?? 0,
    );
  }
}