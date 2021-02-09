import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/auth_manager.dart';
import 'package:tasky_app/routes.dart';
import 'package:tasky_app/services/auth_service.dart';
import 'package:tasky_app/utils/network_utils/custom_http_client.dart';

import 'shared_widgets/custom_theme.dart';

GetIt locator = GetIt.instance;

setupSingletons() async {
  locator.registerLazySingleton<CustomHttpClient>(() => CustomHttpClient());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<AuthManager>(() => AuthManager());
}

main() async {
  await setupSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
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
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
    );
  }
}
