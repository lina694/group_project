import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_project/l10n/app_localizations.dart';

import 'screens/boat_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BoatApp());
}

/// Main Application with localization + routes
class BoatApp extends StatelessWidget {
  const BoatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: AppLocalizations.supportedLocales,

      home: const BoatListPage(),
    );
  }
}
