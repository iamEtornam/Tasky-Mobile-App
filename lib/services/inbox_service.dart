import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class InboxService{
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();


  Future<Response> getInboxRequest({int userId}) async {
    return await _customHttpClient.getRequest(getUserInboxPath(userId));
  }

    Future<Response> getInboxCommentRequest({int inbox}) async {
    return await _customHttpClient.getRequest(getUserInboxCommentPath(inbox));
  }
}