// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/car.dart';
//
// /// Helper class for managing encrypted shared preferences using FlutterSecureStorage.
// /// Stores the last car information for the "copy previous" feature.
// class SecureStorageHelper {
//   static const FlutterSecureStorage _storage = FlutterSecureStorage();
//
//   // Keys for storing car data
//   static const String _keyYear = 'last_car_year';
//   static const String _keyMake = 'last_car_make';
//   static const String _keyModel = 'last_car_model';
//   static const String _keyPrice = 'last_car_price';
//   static const String _keyKilometers = 'last_car_kilometers';
//
//   /// Saves the last car information to secure storage.
//   ///
//   /// [car] - The car object to save
//   static Future<void> saveLastCar(Car car) async {
//     await _storage.write(key: _keyYear, value: car.year.toString());
//     await _storage.write(key: _keyMake, value: car.make);
//     await _storage.write(key: _keyModel, value: car.model);
//     await _storage.write(key: _keyPrice, value: car.price.toString());
//     await _storage.write(key: _keyKilometers, value: car.kilometers.toString());
//   }
//
//   /// Retrieves the last saved car information from secure storage.
//   ///
//   /// Returns a Car object if data exists, null otherwise.
//   static Future<Car?> getLastCar() async {
//     try {
//       final year = await _storage.read(key: _keyYear);
//       final make = await _storage.read(key: _keyMake);
//       final model = await _storage.read(key: _keyModel);
//       final price = await _storage.read(key: _keyPrice);
//       final kilometers = await _storage.read(key: _keyKilometers);
//
//       if (year != null && make != null && model != null &&
//           price != null && kilometers != null) {
//         return Car(
//           year: int.parse(year),
//           make: make,
//           model: model,
//           price: double.parse(price),
//           kilometers: int.parse(kilometers),
//         );
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Clears all saved car information from secure storage.
//   static Future<void> clearLastCar() async {
//     await _storage.delete(key: _keyYear);
//     await _storage.delete(key: _keyMake);
//     await _storage.delete(key: _keyModel);
//     await _storage.delete(key: _keyPrice);
//     await _storage.delete(key: _keyKilometers);
//   }
// }