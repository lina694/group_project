// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get customersTitle => 'Customers';

  @override
  String get helpTitle => 'Help - Customer List';

  @override
  String get helpContent =>
      'This page shows a list of all customers.\n\n- Tap a customer to see their details or edit them.\n- Tap the \"+\" button to add a new customer.';

  @override
  String get ok => 'OK';

  @override
  String get noCustomersFound => 'No customers found.';

  @override
  String get addCustomerTitle => 'Add New Customer';

  @override
  String get copyPrompt =>
      'Start with a blank form or copy data from the previous customer?';

  @override
  String get blank => 'Blank';

  @override
  String get copyPrevious => 'Copy Previous';

  @override
  String get deleteDialogTitle => 'Delete Customer';

  @override
  String get deleteDialogContent =>
      'Are you sure you want to delete this customer?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get allFieldsRequired => 'All fields must have a value.';

  @override
  String get customerCreated => 'Customer Created';

  @override
  String get customerUpdated => 'Customer Updated';

  @override
  String get customerDeleted => 'Customer Deleted';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get address => 'Address';

  @override
  String get dob => 'Date of Birth';

  @override
  String get license => 'Driver\'s License #';

  @override
  String get update => 'Update';

  @override
  String get submit => 'Submit';

  @override
  String get detailsPlaceholder => 'Select a customer or press + to add.';
}
