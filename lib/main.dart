import 'package:flutter/material.dart';
import 'package:tasky_app/routes.dart';

import 'shared_widgets/custom_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      theme: customLightTheme(context),
      darkTheme: customDarkTheme(context),
      themeMode: ThemeMode.system,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginView',
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
    );
  }
}
