import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_project/screens/purchase_offer_list_screen.dart';

import 'l10n/app_localizations.dart';


// sqflite base + web backend
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  // Make sure bindings are ready BEFORE we touch sqflite / async stuff
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 IMPORTANT: initialize sqflite for WEB
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  debugPrint('******** RUNNING PURCHASE OFFER MODULE ********');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purchase Offers',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // ⬇️ Just like your working main: one home widget
      // but here we start at the group main menu for purchase offers
      home: const PurchaseOfferListScreen(),

      // 🔹 Localization using your manual AppLocalizations
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
    );
  }
}
