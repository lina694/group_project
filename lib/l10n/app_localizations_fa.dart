// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get customersTitle => 'مشتریان';

  @override
  String get helpTitle => 'راهنما - لیست مشتریان';

  @override
  String get helpContent =>
      'این صفحه لیست تمام مشتریان را نشان می‌دهد.\n\n- برای دیدن جزئیات یا ویرایش، روی یک مشتری ضربه بزنید.\n- برای افزودن مشتری جدید، روی دکمه \"+\" ضربه بزنید.';

  @override
  String get ok => 'باشه';

  @override
  String get noCustomersFound => 'هیچ مشتری یافت نشد.';

  @override
  String get addCustomerTitle => 'افزودن مشتری جدید';

  @override
  String get copyPrompt =>
      'با فرم خالی شروع می‌کنید یا اطلاعات مشتری قبلی کپی شود؟';

  @override
  String get blank => 'فرم خالی';

  @override
  String get copyPrevious => 'کپی قبلی';

  @override
  String get deleteDialogTitle => 'حذف مشتری';

  @override
  String get deleteDialogContent => 'آیا از حذف این مشتری مطمئن هستید؟';

  @override
  String get cancel => 'لغو';

  @override
  String get delete => 'حذف';

  @override
  String get allFieldsRequired => 'همه فیلدها باید پر شوند.';

  @override
  String get customerCreated => 'مشتری ایجاد شد';

  @override
  String get customerUpdated => 'مشتری به‌روزرسانی شد';

  @override
  String get customerDeleted => 'مشتری حذف شد';

  @override
  String get editCustomer => 'ویرایش مشتری';

  @override
  String get addCustomer => 'افزودن مشتری';

  @override
  String get firstName => 'نام';

  @override
  String get lastName => 'نام خانوادگی';

  @override
  String get address => 'آدرس';

  @override
  String get dob => 'تاریخ تولد';

  @override
  String get license => 'شماره گواهینامه رانندگی';

  @override
  String get update => 'به‌روزرسانی';

  @override
  String get submit => 'ثبت';

  @override
  String get detailsPlaceholder =>
      'یک مشتری را انتخاب کنید یا برای افزودن، + را بزنید.';
}
