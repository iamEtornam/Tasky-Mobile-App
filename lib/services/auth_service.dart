
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';



class AuthService {
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final Logger _logger = Logger();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    AppleIdCredential appleIdCredential = result.credential;

    OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    OAuthCredential credential = oAuthProvider.credential(
      idToken: String.fromCharCodes(appleIdCredential.identityToken),
      accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    );

    return await auth.signInWithCredential(credential);
  }

  Future<Response> sendTokenToBackend({String token}) async {
    return await _customHttpClient
        .postRequest(path: loginPath, body: {'token': token});
  }
}
