import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class InboxService {
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();

  Future<Response> getInboxRequest({required int userId}) async {
    return await _customHttpClient.getRequest(getUserInboxPath(userId));
  }

  Future<Response> getInboxCommentRequest({required int inbox}) async {
    return await _customHttpClient.getRequest(getUserInboxCommentPath(inbox));
  }

  Future<Response> submitInboxCommentRequest({required int inbox, required String comment}) async {
    return await _customHttpClient
        .postRequest(path: submitUserInboxCommentPath(inbox), body: {'comment': comment});
  }

    Future<Response> submitInboxRequest({required String title, required String message, required String team, required int userId}) async {
    return await _customHttpClient
        .postRequest(path: submitUserInbox, body: {'title': title,'message': message, 'team':team, 'userId': userId,'status':"Pending",'like':[userId]});
  }
}
