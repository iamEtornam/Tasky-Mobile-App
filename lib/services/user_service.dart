import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';


class UserService {
final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();


  Future<Response> updateUserTeamRequest({String? team}) async {
    return await _customHttpClient
        .patchRequest(path: updateTeamPath, body: {'team': team});
  }

  Future<Response> getUserInformationRequest() async {
    return await _customHttpClient.getRequest(getUserInformationPath);
  }

  Future<Response> sendNotificationTokenRequest({String? token}) async {
    return await _customHttpClient
        .patchRequest(path: updateTokenPath, body: {'fcm_token': token});
  }


    Future<Response> updateUserRequest({String? name, String? phone, String? pic}) async {
    return await _customHttpClient
        .patchRequest(path: updateUserPath, body: {'name': name, 'picture':pic,'phone_number':phone});
  }
}
