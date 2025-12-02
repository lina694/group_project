// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

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
  String get address => 'آدرس';

  @override
  String get submit => 'ثبت';

  @override
  String get update => 'به‌روزرسانی';

  @override
  String get delete => 'حذف';

  @override
  String get copyPrevious => 'کپی قبلی';

  @override
  String get copyPreviousContent =>
      'Do you want to load the previous boat info?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
