import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_app/utils/network_utils/endpoints.dart';

final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();

class TaskService {
  Future<Response> createTaskRequest(
      {String description,
      String dueDate,
      String department,
      bool isReminder,
      int organizationId,
      int createdBy,
      List<int> assignees}) async {
    Map<String, dynamic> body = {
      'description': description,
      'due_date': dueDate,
      'is_reminder': isReminder,
      'assignees': assignees,
      'organization_id': organizationId,
      'created_by': createdBy,
      'department': department
    };
    return await _customHttpClient.postRequest(
        path: createTaskPath, body: body);
  }

  Future<Response> getTaskRequest(int organizationId) async {
    return await _customHttpClient.getRequest(getTaskPath(organizationId));
  }
}
