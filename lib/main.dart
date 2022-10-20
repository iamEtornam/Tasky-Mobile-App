import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tasky_mobile_app/managers/auth_manager.dart';
import 'package:tasky_mobile_app/managers/file_upload_manager.dart';
import 'package:tasky_mobile_app/managers/task_manager.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/routes.dart';
import 'package:tasky_mobile_app/services/auth_service.dart';
import 'package:tasky_mobile_app/services/file_upload_service.dart';
import 'package:tasky_mobile_app/services/organization_service.dart';
import 'package:tasky_mobile_app/services/task_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/network_utils/background_message_handler.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/views/auth/login_view.dart';
import 'package:tasky_mobile_app/views/dashboard/dashboard_view.dart';

import 'managers/inbox_manager.dart';
import 'managers/organization_manager.dart';
import 'services/inbox_service.dart';
import 'services/user_service.dart';
import 'shared_widgets/custom_theme.dart';

final FirebaseMessaging messaging = FirebaseMessaging.instance;
GetIt locator = GetIt.instance;

setupSingletons() async {
  locator.registerLazySingleton<CustomHttpClient>(() => CustomHttpClient());

  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<AuthManager>(() => AuthManager());

  locator.registerLazySingleton<LocalStorage>(() => LocalStorage());

  locator.registerLazySingleton<OrganizationService>(() => OrganizationService());
  locator.registerLazySingleton<OrganizationManager>(() => OrganizationManager());

  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<UserManager>(() => UserManager());

  locator.registerLazySingleton<TaskService>(() => TaskService());
  locator.registerLazySingleton<TaskManager>(() => TaskManager());

  locator.registerLazySingleton<InboxService>(() => InboxService());
  locator.registerLazySingleton<InboxManager>(() => InboxManager());

  locator.registerLazySingleton<FileUploadService>(() => FileUploadService());
  locator.registerLazySingleton<FileUploadManager>(() => FileUploadManager());
}

main() async {
  await setupSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await Hive.initFlutter();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Tasky',
            builder: BotToastInit(),
            theme: customLightTheme(context),
            darkTheme: customDarkTheme(context),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            onGenerateInitialRoutes: (_) {
              if (_auth.currentUser != null) {
                return <Route>[MaterialPageRoute(builder: (context) => const DashboardView())];
              } else {
                return <Route>[MaterialPageRoute(builder: (context) => LoginView())];
              }
            },
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _analytics),
              BotToastNavigatorObserver(),
            ],
            localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
              return locale;
            },
          );
        });
  }
}
