import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasky_mobile_app/app.dart';
import 'package:tasky_mobile_app/firebase_options.dart';
import 'package:tasky_mobile_app/managers/auth_manager.dart';
import 'package:tasky_mobile_app/managers/file_upload_manager.dart';
import 'package:tasky_mobile_app/managers/task_manager.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/services/auth_service.dart';
import 'package:tasky_mobile_app/services/file_upload_service.dart';
import 'package:tasky_mobile_app/services/organization_service.dart';
import 'package:tasky_mobile_app/services/task_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/network_utils/background_message_handler.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';

import 'managers/inbox_manager.dart';
import 'managers/organization_manager.dart';
import 'services/inbox_service.dart';
import 'services/user_service.dart';

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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await Hive.initFlutter();
  runApp(const MyApp());
}
