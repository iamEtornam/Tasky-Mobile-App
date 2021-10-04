import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/user.dart' as _member;
import 'package:tasky_mobile_app/services/auth_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final AuthService _authService = GetIt.I.get<AuthService>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
final Logger _logger = Logger();

class AuthManager with ChangeNotifier {
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

  Future<bool> loginUserwithGoogle() async {
    try {
      bool isSuccessful = false;
      setisLoading(true);
      await _authService
          .signInWithGoogle()
          .then((UserCredential googleUserCredential) async {
        if (googleUserCredential != null) {
          String token = await googleUserCredential.user.getIdToken();

          Response _response =
              await _authService.sendTokenToBackend(token: token);
          int statusCode = _response.statusCode;
          Map<String, dynamic> body = json.decode(_response.body);
          _logger.d(body);

          setisLoading(false);
          if (statusCode == 201) {
            _member.User member = _member.User.fromMap(body);

            await _localStorage.saveUserInfo(
                id: member.data.id,
                name: member.data.name,
                picture: member.data.picture,
                userId: member.data.userId,
                email: member.data.email,
                signInProvider: member.data.signInProvider,
                authToken: member.data.authToken,
                organizationId: member.data.organizationId,
                team: member.data.team,
                fcmToken: member.data.fcmToken,
                phoneNumber: member.data.phoneNumber);
            setMessage(body['message']);

            isSuccessful = true;
          } else {
            isSuccessful = false;
            setMessage(body['message']);
            _logger.d('message ${body['message']}');
          }
        } else {
          isSuccessful = false;
          setMessage('Authentication failed. Try gain!');
        }
      }).catchError((onError) {
        isSuccessful = false;
        setMessage('Process has been cancelled!');
        setisLoading(false);
        _logger.d('catchError $onError');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSuccessful = false;
        setMessage('Timeout! Check your internet connection.');
        setisLoading(false);
      });
      return isSuccessful;
    } catch (e) {
      _logger.d('catch $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    bool isSuccessful = false;
    // 1. perform the sign-in request
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        await _authService.signInWithApple().then((appleUserCredential) async {
          if (appleUserCredential != null) {
            String token = await appleUserCredential.user.getIdToken();

            Response _response =
                await _authService.sendTokenToBackend(token: token);
            int statusCode = _response.statusCode;
            Map<String, dynamic> body = json.decode(_response.body);
            _member.User member = _member.User.fromMap(body);
            setisLoading(false);
            if (statusCode == 201) {
              await _localStorage.saveUserInfo(
                  id: member.data.id,
                  name: member.data.name,
                  picture: member.data.picture,
                  userId: member.data.userId,
                  email: member.data.email,
                  signInProvider: member.data.signInProvider,
                  authToken: member.data.authToken,
                  organizationId: member.data.organizationId,
                  team: member.data.team,
                  fcmToken: member.data.fcmToken,
                  phoneNumber: member.data.phoneNumber);
              isSuccessful = true;
              setMessage(body['message']);
            } else {
              _logger.d(_response.body);
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
          setisLoading(false);
        }).timeout(const Duration(seconds: 60), onTimeout: () {
          isSuccessful = false;
          setMessage('Timeout! Check your internet connection.');
          setisLoading(false);
        });
        break;
      case AuthorizationStatus.error:
        _logger.d('error ${result.error.localizedDescription}');
        isSuccessful = false;
        setMessage(result.error.localizedDescription);
        setisLoading(false);
        break;
      case AuthorizationStatus.cancelled:
        _logger.d('cancelled ${result.error.localizedDescription}');
        isSuccessful = false;
        setMessage('Sign in aborted by user');
        setisLoading(false);
        break;
      default:
        _logger.d('userCredential ${result.error.toString()}');
        isSuccessful = false;
        setMessage(result.error.localizedDescription);
        setisLoading(false);
    }
    return isSuccessful;
  }
}
