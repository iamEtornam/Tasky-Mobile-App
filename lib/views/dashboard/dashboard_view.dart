import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/views/inbox/inbox_view.dart';
import 'package:tasky_app/views/overview/over_view.dart';
import 'package:tasky_app/views/account/account_view.dart';
import 'package:tasky_app/views/task/task_view.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    OverView(),
    TaskView(),
    InboxView(),
    AccountView()
  ];

  _onChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onChanged,
        selectedIconTheme:
            Theme.of(context).iconTheme.copyWith(color: customRedColor),
        selectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: customRedColor),
        unselectedIconTheme:
            Theme.of(context).iconTheme.copyWith(color: customGreyColor),
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: customGreyColor),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: customRedColor,
        unselectedItemColor: customGreyColor,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/chart_pie.svg'),
              label: 'Overview',
              activeIcon: SvgPicture.asset(
                'assets/chart_pie.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/lightning_bolt.svg'),
              label: 'Task',
              activeIcon: SvgPicture.asset(
                'assets/lightning_bolt.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/inbox.svg'),
              label: 'Inbox',
              activeIcon: SvgPicture.asset(
                'assets/inbox.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/user_circle.svg'),
              label: 'Account',
              activeIcon: SvgPicture.asset(
                'assets/user_circle.svg',
                color: customRedColor,
              ))
        ],
      ),
    );
  }
}
