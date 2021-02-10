import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_app/utils/network_utils/endpoints.dart';

final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();
class OrganizationService {
  
  Future<Response> getOrganizationRequest({int organizationID}) async {
    return await _customHttpClient
        .getRequest('$organizationPath/$organizationID');
  }
}