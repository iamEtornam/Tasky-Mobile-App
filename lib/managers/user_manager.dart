import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/services/user_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

final UserService _userService = GetIt.I.get<UserService>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class UserManager with ChangeNotifier {
  final Logger _logger = Logger();
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

  Future<bool> updateUserTeam({@required String team}) async {
    bool isSuccessful = false;
    setisLoading(true);
    await _userService.updateUserTeamRequest(team: team).then((response) async {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setisLoading(false);
      _logger.d(body['message']);
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
            team: _user.data.team,
            fcmToken: _user.data.fcmToken,
            phoneNumber: _user.data.phoneNumber);
        isSuccessful = true;
        setMessage(body['message']);
      } else {
        setMessage(body['message']);
        isSuccessful = false;
      }
    }).catchError((onError) {
      isSuccessful = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      isSuccessful = false;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return isSuccessful;
  }

  Future<User> getUserInformation() async {
    User user;
    setisLoading(true);
    await _userService.getUserInformationRequest().then((response) async {
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
            team: _user.data.team,
            fcmToken: _user.data.fcmToken,
            phoneNumber: _user.data.phoneNumber);
        user = _user;
      } else {
        user = null;
      }
    }).catchError((onError) {
      user = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      user = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return user;
  }

  Future<bool> inviteMember({@required List<String> emails}) async {
    bool isSent = false;
    await _userService.inviteMembersRequest(emails: emails).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        isSent = true;
      } else {
        isSent = false;
      }
    }).catchError((onError) {
      isSent = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      isSent = false;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return isSent;
  }

  sendNotificationToken({String token}) async {
    await _userService.sendNotificationTokenRequest(token: token);
  }
}
