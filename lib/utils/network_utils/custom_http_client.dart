import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CustomHttpClient {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  CustomHttpClient._privateConstructor();

  static final CustomHttpClient _instance =
      CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<Response> getRequest(String path) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    debugPrint("$path");
    return await get(path, headers: headers);
  }

  Future<Response> postRequest(
      {@required String path, @required Map body}) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    debugPrint(path);
    debugPrint(jsonEncode(body));

    Response response =
        await post(path, body: jsonEncode(body), headers: headers);
    return response;
  }

  Future<Response> postStringRequest(
      {@required String path, @required String body}) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    debugPrint(path);

    Response response =
        await post(path, body: jsonEncode(body), headers: headers);
    return response;
  }

  Future<Response> putRequest(
      {@required String path, @required Map body}) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    debugPrint(path);

    Response response =
        await put(path, body: jsonEncode(body), headers: headers);
    debugPrint(response.body);
    return response;
  }

  Future<Response> patchRequest(
      {@required String path, @required Map body}) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    debugPrint(path);

    Response response =
        await patch(path, body: jsonEncode(body), headers: headers);
    return response;
  }

  Future<Response> deleteRequest(String path) async {
    User user = firebaseAuth.currentUser;
    String token = await user.getIdToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    debugPrint(path);
    Response response = await delete(path, headers: headers);
    return response;
  }
}
