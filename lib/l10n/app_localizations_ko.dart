// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

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
  String get copyPrevious => '이전 항목 불러오기?';

  @override
  String get deleteDialogTitle => 'Delete Customer';

  @override
  String get deleteDialogContent =>
      'Are you sure you want to delete this customer?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => '삭제';

  @override
  String get save => 'Save';

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
  String get address => '주소';

  @override
  String get dob => 'Date of Birth';

  @override
  String get license => 'Driver\'s License #';

  @override
  String get update => '수정';

  @override
  String get submit => '등록';

  @override
  String get detailsPlaceholder => 'Select a customer or press + to add.';

  @override
  String get appTitle => '판매용 보트';

  @override
  String get instructions => '+ 버튼을 눌러 보트를 추가하세요.\n목록을 눌러 수정 또는 삭제할 수 있습니다.';

  @override
  String get addBoat => '보트 추가';

  @override
  String get editBoat => '보트 수정';

  @override
  String get yearBuilt => '제작 연도';

  @override
  String get length => '길이';

  @override
  String get powerType => '동력 유형';

  @override
  String get price => '가격';

  @override
  String get copyPreviousContent => '이전 보트 입력 정보를 불러올까요?';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';
}
