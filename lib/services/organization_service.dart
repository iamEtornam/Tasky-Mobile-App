import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class OrganizationService {
  final Logger _logger = Logger();

  Future<Response> getOrganizationRequest({int organizationID}) async {
    return await _customHttpClient
        .getRequest('$organizationPath/$organizationID');
  }

  Future<Response> createOrganizationRequest(
      {String imageUrl, String name, List<String> teams}) async {
    Map<String, dynamic> body = {
      "name": name,
      "logo": imageUrl,
      "teams": teams
    };
    _logger.d(body);
    return await _customHttpClient.postRequest(
        path: createOrganizationPath, body: body);
  }

  Future<Response> fileUploaderRequest({File file}) async {
    final token = await _localStorage.authToken();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    final multipartRequest =
        MultipartRequest('POST', Uri.parse(fileUploaderPath));
    String fileName = basename(file.path);
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(
      await MultipartFile.fromPath('file', file.path,
          filename: fileName, contentType: MediaType("image", "png")),
    );

    Response response = await Response.fromStream(await multipartRequest.send())
        .timeout(const Duration(seconds: 120));

    return response;
  }

  Future<Response> getMemberListRequest({int organizationId}) async {
    return await _customHttpClient.getRequest(listMembersPath(organizationId));
  }
}
