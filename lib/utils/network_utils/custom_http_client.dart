import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class CustomHttpClient {
  final Logger _logger = Logger();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  CustomHttpClient._privateConstructor();

  static final CustomHttpClient _instance =
      CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers;
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      String? token = await user.getIdToken();
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
    } else {
      headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
    }
    return headers;
  }

  Future<Response> getRequest(String path) async {
    _logger.d(path);
    return await get(Uri.tryParse(path)!, headers: await getHeaders());
  }

  Future<Response> postRequest(
      {required String path, required Map body}) async {
    _logger.d(path);
    _logger.d(jsonEncode(body));

    Response response = await post(Uri.tryParse(path)!,
        body: jsonEncode(body), headers: await getHeaders());
    return response;
  }

  Future<Response> postStringRequest(
      {required String path, required String body}) async {
    _logger.d(path);

    Response response = await post(Uri.tryParse(path)!,
        body: jsonEncode(body), headers: await getHeaders());
    return response;
  }

  Future<Response> putRequest({required String path, required Map body}) async {
    _logger.d(path);

    Response response = await put(Uri.tryParse(path)!,
        body: jsonEncode(body), headers: await getHeaders());
    _logger.d(response.body);
    return response;
  }

  Future<Response> patchRequest(
      {required String path, required Map body}) async {
    _logger.d(path);

    Response response = await patch(Uri.tryParse(path)!,
        body: jsonEncode(body), headers: await getHeaders());
    return response;
  }

  Future<Response> deleteRequest(String path) async {
    _logger.d(path);
    Response response =
        await delete(Uri.tryParse(path)!, headers: await getHeaders());
    return response;
  }
}
