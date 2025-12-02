// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Boats for Sale';

  @override
  String get instructions => 'Tap + to add a boat';

  @override
  String get addBoat => 'Add Boat';

  @override
  String get editBoat => 'Edit Boat';

  @override
  String get yearBuilt => 'Year built';

  @override
  String get length => 'Length';

  @override
  String get powerType => 'Power Type';

  @override
  String get price => 'Price';

  @override
  String get address => 'Address';

  @override
  String get submit => 'Submit';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get copyPrevious => 'Copy previous?';

  @override
  String get copyPreviousContent =>
      'Do you want to load the previous boat info?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
