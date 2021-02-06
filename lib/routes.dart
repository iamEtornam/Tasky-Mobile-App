import 'package:flutter/material.dart';

import 'utils/custom_colors.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/task/create_task_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DashboardView());
      case '/createNewTaskView':
        return MaterialPageRoute(builder: (_) => CreateNewTaskView());
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: customRedColor,
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
