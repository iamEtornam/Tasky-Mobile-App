import 'package:flutter/material.dart';
import 'package:tasky_mobile_app/views/inbox/create_inbox_view.dart';
import 'package:tasky_mobile_app/views/support/support_view.dart';

import 'utils/ui_utils/custom_colors.dart';
import 'views/account/account_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/organization_view.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/task/create_task_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        final int currentIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(builder: (_) => DashboardView(currentIndex: currentIndex));
      case '/createNewTaskView':
        return MaterialPageRoute(builder: (_) => const CreateNewTaskView());
      case '/loginView':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/organizationView':
        return MaterialPageRoute(builder: (_) => const OrganizationView());
      case '/accountView':
        return MaterialPageRoute(builder: (_) => const AccountView());
      case '/supportView':
        return MaterialPageRoute(builder: (_) => const SupportView());
      case '/createInboxView':
        return MaterialPageRoute(builder: (_) => const CreateInboxView(), fullscreenDialog: true);
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: customRedColor,
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
