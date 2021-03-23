import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_app/utils/network_utils/endpoints.dart';

final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();

class UserService {
  Future<Response> updateUserDepartmentRequest({String department}) async {
    return await _customHttpClient.putRequest(
        path: updateDepartmentPath, body: {'department': department});
  }

  Future<Response> getUserInformationRequest() async {
    return await _customHttpClient.getRequest(getUserInformationPath);
  }

  Future<Response> inviteMembersRequest({List<String> emails}) async {
    return await _customHttpClient
        .postRequest(path: inviteMembersPath, body: {'emails': emails});
  }

  Future<Response> sendNotificationTokenRequest({String token}) async {
    return await _customHttpClient
        .putRequest(path: updateTokenPath, body: {'fcm_token': token});
  }
}
