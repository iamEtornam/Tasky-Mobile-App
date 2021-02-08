import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_app/services/auth_service.dart';

final AuthService _authService = GetIt.I.get<AuthService>();

class AuthManager {
  final FirebaseAuth auth = FirebaseAuth.instance;

  loginUser() async {
    UserCredential googleUserCredential = await _authService.signInWithGoogle();
    auth
        .signInWithCredential(googleUserCredential.credential)
        .then((UserCredential userCredential) async {
          User user = auth.currentUser;
          String token = await user.getIdToken();
          Response _response =
              await _authService.sendTokenToBackend(token: token);
          if (_response.statusCode == 200) {
            print(_response.body);
          } else {
            print(_response.body);
          }
        })
        .catchError((onError) {})
        .timeout(Duration(seconds: 60), onTimeout: () {});
  }
}
