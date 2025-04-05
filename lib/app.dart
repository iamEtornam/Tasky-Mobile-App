import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_mobile_app/routes.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_theme.dart';
import 'package:tasky_mobile_app/views/auth/login_view.dart';
import 'package:tasky_mobile_app/views/dashboard/dashboard_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                return <Route>[
                  MaterialPageRoute(builder: (context) => const DashboardView())
                ];
              } else {
                return <Route>[
                  MaterialPageRoute(builder: (context) => const LoginView())
                ];
              }
            },
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _analytics),
              BotToastNavigatorObserver(),
            ],
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
              return locale;
            },
          );
        });
  }
}
