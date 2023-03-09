import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final UserManager _userManager = GetIt.I.get<UserManager>();
  Data? userData;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    await _userManager.getUserInformation();
    userData = await _localStorage.getUserInfo();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant SupportView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Tawk(
          directChatLink: tawkDirectChatLink,
          visitor: TawkVisitor(
            name: userData?.name,
            email: userData?.email,
          ),
        ),
      ),
    );
  }
}
