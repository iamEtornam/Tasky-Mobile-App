import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/auth_manager.dart';
import 'package:tasky_app/routes.dart';
import 'package:tasky_app/services/auth_service.dart';

import 'shared_widgets/custom_theme.dart';

GetIt locator = GetIt.instance;

setupSingletons() async {
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<AuthManager>(() => AuthManager());
}

main() async {
  await setupSingletons();
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
