import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class OrganizationService {
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();

  Future<Response> getOrganizationRequest({int? organizationID}) async {
    return await _customHttpClient.getRequest('$organizationPath/$organizationID');
  }

  Future<Response> createOrganizationRequest(
      {String? imageUrl, String? name, List<String>? teams}) async {
    Map<String, dynamic> body = {"name": name, "logo": imageUrl, "teams": teams};
    return await _customHttpClient.postRequest(path: createOrganizationPath, body: body);
  }

  Future<Response> getMemberListRequest({int? organizationId}) async {
    return await _customHttpClient.getRequest(
      listMembersPath(organizationId),
    );
  }

  Future<Response> inviteMembersRequest({List<String>? emails}) async {
    return await _customHttpClient.postRequest(path: inviteMembersPath, body: {'emails': emails});
  }
}
