import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_app/services/auth_service.dart';

final AuthService _authService = GetIt.I.get<AuthService>();

class AuthManager with ChangeNotifier {
  String _message = '';

  String get message => _message;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  Future<bool> loginUserwithGoogle() async {
    bool isSuccessful = false;
    await _authService
        .signInWithGoogle()
        .then((UserCredential googleUserCredential) async {
      if (googleUserCredential != null) {
        User user = auth.currentUser;
        String token = await user.getIdToken();

        Response _response =
            await _authService.sendTokenToBackend(token: token);
        int statusCode = _response.statusCode;
        Map<String, dynamic> body = json.decode(_response.body);

        if (statusCode == 200) {
          isSuccessful = true;
          setMessage(body['message']);
        } else {
          print(_response.body);
          isSuccessful = false;
          setMessage(body['message']);
        }
      } else {
        isSuccessful = false;
        setMessage('Authentication failed. Try gain!');
      }
    }).catchError((onError) {
      isSuccessful = false;
      setMessage('$onError');
    }).timeout(Duration(seconds: 60), onTimeout: () {
      isSuccessful = false;
      setMessage('Timeout! Check your internet connection.');
    });
    return isSuccessful;
  }

  Future<bool> loginUserwithApple() async {
    bool isSuccessful = false;

    await _authService
        .signInWithApple()
        .then((UserCredential googleUserCredential) async {
      if (googleUserCredential != null) {
        print('userCredential is working');
        User user = auth.currentUser;
        String token = await user.getIdToken();
        print('''$token''');
        Response _response =
            await _authService.sendTokenToBackend(token: token);
        if (_response.statusCode == 200) {
          print('body: ${_response.body}');
          isSuccessful = true;
        } else {
          print(_response.body);
          isSuccessful = false;
        }
      } else {
        print('userCredential is null');
        isSuccessful = false;
      }
    }).catchError((onError) {
      print('userCredential $onError');
      isSuccessful = false;
    }).timeout(Duration(seconds: 60), onTimeout: () {
      isSuccessful = false;
    });
    return isSuccessful;
  }
}
