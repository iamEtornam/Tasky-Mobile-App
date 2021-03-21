import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/auth_manager.dart';
import 'package:tasky_app/managers/task_manager.dart';
import 'package:tasky_app/managers/user_manager.dart';
import 'package:tasky_app/routes.dart';
import 'package:tasky_app/services/auth_service.dart';
import 'package:tasky_app/services/organization_service.dart';
import 'package:tasky_app/services/task_service.dart';
import 'package:tasky_app/utils/local_storage.dart';
import 'package:tasky_app/utils/network_utils/custom_http_client.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'managers/organization_manager.dart';
import 'services/user_service.dart';
import 'shared_widgets/custom_theme.dart';

GetIt locator = GetIt.instance;

setupSingletons() async {
  locator.registerLazySingleton<CustomHttpClient>(() => CustomHttpClient());

  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<AuthManager>(() => AuthManager());

  locator.registerLazySingleton<LocalStorage>(() => LocalStorage());

  locator
      .registerLazySingleton<OrganizationService>(() => OrganizationService());
  locator
      .registerLazySingleton<OrganizationManager>(() => OrganizationManager());

  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<UserManager>(() => UserManager());

  locator.registerLazySingleton<TaskService>(() => TaskService());
  locator.registerLazySingleton<TaskManager>(() => TaskManager());
}

main() async {
  await setupSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: _auth.userChanges(),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Tasky',
            builder: BotToastInit(),
            theme: customLightTheme(context),
            darkTheme: customDarkTheme(context),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _analytics),
              BotToastNavigatorObserver(),
            ],
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) {
              return locale;
            },
          );
        });
  }
}
