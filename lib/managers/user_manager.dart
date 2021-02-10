import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/models/user.dart';
import 'package:tasky_app/services/user_service.dart';
import 'package:tasky_app/utils/local_storage.dart';

final UserService _userService = GetIt.I.get<UserService>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class UserManager with ChangeNotifier {
  String _message = '';
  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> updateUserDepartment({@required String department}) async {
    bool isSuccessful = false;
    setisLoading(true);
    await _userService
        .updateUserDepartmentRequest(department: department)
        .then((response) async {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        User _user = User.fromMap(body);
        await _localStorage.saveUserInfo(
            id: _user.data.id,
            name: _user.data.name,
            picture: _user.data.picture,
            userId: _user.data.userId,
            email: _user.data.email,
            signInProvider: _user.data.signInProvider,
            authToken: _user.data.authToken,
            organizationId: _user.data.organizationId,
            department: _user.data.department,
            fcmToken: _user.data.fcmToken,
            phoneNumber: _user.data.phoneNumber);
        isSuccessful = true;
        setMessage(body['message']);
      } else {
        isSuccessful = false;
      }
    }).catchError((onError) {
      isSuccessful = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(Duration(seconds: 60), onTimeout: () {
      isSuccessful = false;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return isSuccessful;
  }
}
