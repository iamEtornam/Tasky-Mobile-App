import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class AuthService {
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final Logger _logger = Logger();

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('firstName');
    appleProvider.addScope('lastName');

    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  }

  Future<Response> sendTokenToBackend({String? token}) async {
    return await _customHttpClient.postRequest(
      path: loginPath,
      body: {'token': token},
    );
  }
}
