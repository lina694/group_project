import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../models/customer.dart';

/// A service class for managing customer data in [EncryptedSharedPreferences].
///
/// This is used for the project requirement to save the last created
/// customer's data for a "copy" feature.
class CustomerPrefs {
  /// The [EncryptedSharedPreferences] instance.
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  /// Saves the details of a [Customer] to encrypted shared preferences.
  Future<void> saveLastCustomer(Customer customer) async {
    await _prefs.setString('lastFirstName', customer.firstName);
    await _prefs.setString('lastLastName', customer.lastName);
    await _prefs.setString('lastAddress', customer.address);
    await _prefs.setString('lastDob', customer.dob);
    await _prefs.setString('lastLicense', customer.licenseNumber);
  }

  /// Retrieves the last saved customer's details.
  ///
  /// Returns a [Customer] object if data is found, otherwise returns null.
  Future<Customer?> getLastCustomer() async {
    String? firstName = await _prefs.getString('lastFirstName');
    // If first name is empty, assume no data is saved.
    if (firstName.isEmpty) return null;

    String lastName = await _prefs.getString('lastLastName');
    String address = await _prefs.getString('lastAddress');
    String dob = await _prefs.getString('lastDob');
    String license = await _prefs.getString('lastLicense');

    // Return a new Customer object (ID is null because this is just copied data)
    return Customer(
      firstName: firstName,
      lastName: lastName,
      address: address,
      dob: dob,
      licenseNumber: license,
    );
  }
}