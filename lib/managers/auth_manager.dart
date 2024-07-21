import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/user.dart' as m;
import 'package:tasky_mobile_app/services/auth_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class AuthManager with ChangeNotifier {
  final AuthService _authService = GetIt.I.get<AuthService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final Logger _logger = Logger();

  String? _message = '';
  bool _isLoading = false;

  String? get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> loginUserwithGoogle() async {
    try {
      bool isSuccessful = false;
      setIsLoading(true);
      await _authService.signInWithGoogle().then((UserCredential? googleUserCredential) async {
        if (googleUserCredential != null) {
          String? token = await googleUserCredential.user!.getIdToken();

          Response response = await _authService.sendTokenToBackend(token: token);
          int statusCode = response.statusCode;
          Map<String, dynamic>? body = json.decode(response.body);
          _logger.d(body);

          setIsLoading(false);
          if (statusCode == 201) {
            m.User member = m.User.fromMap(body!);

            await _localStorage.saveUserInfo(
                id: member.data!.id,
                name: member.data!.name,
                picture: member.data!.picture,
                userId: member.data!.userId,
                email: member.data!.email,
                signInProvider: member.data!.signInProvider,
                authToken: member.data!.authToken,
                organizationId: member.data!.organizationId,
                team: member.data!.team,
                fcmToken: member.data!.fcmToken,
                phoneNumber: member.data!.phoneNumber,
                createdAt: member.data!.createdAt,
                updatedAt: member.data!.updatedAt,
                organization: member.data?.organization?.toMap());
            setMessage(body['message']);

            isSuccessful = true;
          } else {
            isSuccessful = false;
            setMessage(body!['message']);
            _logger.d('message ${body['message']}');
          }
        } else {
          isSuccessful = false;
          setMessage('Authentication failed. Try gain!');
        }
      }).catchError((onError) {
        log(onError);
        isSuccessful = false;
        setMessage('Process has been cancelled!');
        setIsLoading(false);
        _logger.d('catchError $onError');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSuccessful = false;
        setMessage('Timeout! Check your internet connection.');
        setIsLoading(false);
      });
      return isSuccessful;
    } catch (e) {
      _logger.d('catch $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    bool isSuccessful = false;
    await _authService.signInWithApple().then((appleUserCredential) async {
      if (appleUserCredential != null) {
        String? token = await appleUserCredential.user!.getIdToken();

        Response response = await _authService.sendTokenToBackend(token: token);
        int statusCode = response.statusCode;
        Map<String, dynamic> body = json.decode(response.body);
        m.User member = m.User.fromMap(body);
        setIsLoading(false);
        if (statusCode == 201) {
          await _localStorage.saveUserInfo(
              id: member.data!.id,
              name: member.data!.name,
              picture: member.data!.picture,
              userId: member.data!.userId,
              email: member.data!.email,
              signInProvider: member.data!.signInProvider,
              authToken: member.data!.authToken,
              organizationId: member.data!.organizationId,
              team: member.data!.team,
              fcmToken: member.data!.fcmToken,
              phoneNumber: member.data!.phoneNumber,
              createdAt: member.data!.createdAt,
              updatedAt: member.data!.updatedAt,
              organization: member.data?.organization?.toMap());
          isSuccessful = true;
          setMessage(body['message']);
        } else {
          _logger.d(response.body);
          isSuccessful = false;
          setMessage(body['message']);
        }
      } else {
        _logger.d('userCredential is null');
        isSuccessful = false;
        setMessage('Authentication failed. Try gain!');
      }
    }).catchError((onError) {
      _logger.d('userCredential $onError');
      isSuccessful = false;
      setMessage('$onError');
      setIsLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      isSuccessful = false;
      setMessage('Timeout! Check your internet connection.');
      setIsLoading(false);
    });
    return isSuccessful;
  }
}
