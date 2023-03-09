import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/managers/file_upload_manager.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/services/user_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class UserManager with ChangeNotifier {
  final UserService _userService = GetIt.I.get<UserService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final FileUploadManager _fileUploadManager = GetIt.I.get<FileUploadManager>();
  final Logger _logger = Logger();
  String? _message = '';
  bool _isLoading = false;

  String? get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> updateUserTeam({required String? team}) async {
    bool isSuccessful = false;
    setisLoading(true);
    await _userService.updateUserTeamRequest(team: team).then((response) async {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setisLoading(false);
      _logger.d(body['message']);
      if (statusCode == 200) {
        User user = User.fromMap(body);
        await _localStorage.saveUserInfo(
            id: user.data!.id,
            name: user.data?.name,
            picture: user.data?.picture,
            userId: user.data?.userId,
            email: user.data?.email,
            signInProvider: user.data?.signInProvider,
            authToken: user.data?.authToken,
            organizationId: user.data?.organizationId,
            team: user.data?.team,
            fcmToken: user.data?.fcmToken,
            phoneNumber: user.data?.phoneNumber,
            createdAt: user.data?.createdAt,
            updatedAt: user.data?.updatedAt,
            organization: user.data?.organization?.toMap());
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

  Future<User?> getUserInformation() async {
    setisLoading(true);
    await _userService.getUserInformationRequest().then((response) async {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        User u = User.fromMap(body);
        await _localStorage.saveUserInfo(
            id: u.data!.id,
            name: u.data!.name,
            picture: u.data!.picture,
            userId: u.data!.userId,
            email: u.data!.email,
            signInProvider: u.data!.signInProvider,
            authToken: u.data!.authToken,
            organizationId: u.data!.organizationId,
            team: u.data!.team,
            fcmToken: u.data!.fcmToken,
            phoneNumber: u.data!.phoneNumber,
            createdAt: u.data!.createdAt,
            updatedAt: u.data!.updatedAt,
            organization: u.data?.organization?.toMap());
        return u;
      } else {
        return null;
      }
    }).catchError((onError) {
      setMessage('$onError');
      setisLoading(false);
      return null;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      return null;
    });
    return null;
  }

 

  Future<void> sendNotificationToken({String? token}) async {
    await _userService.sendNotificationTokenRequest(token: token);
  }

  Future<bool> updateProfile({String? name, String? phone, File? image}) async {
    bool isUpdated = false;
    String? fileUrl = await _fileUploadManager.imageFileUploader(image!);

    await _userService.updateUserRequest(name: name, phone: phone, pic: fileUrl).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        isUpdated = true;
      } else {
        isUpdated = false;
      }
    }).catchError((onError) {
      isUpdated = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      isUpdated = false;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return isUpdated;
  }
}
