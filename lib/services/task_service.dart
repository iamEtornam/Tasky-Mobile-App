import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tasky_mobile_app/utils/network_utils/custom_http_client.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class TaskService {
  final CustomHttpClient _customHttpClient = GetIt.I.get<CustomHttpClient>();

  Future<Response> createTaskRequest(
      {String? description,
      String? dueDate,
      String? team,
      bool? isReminder,
      int? organizationId,
      int? createdBy,
      List<int?>? assignees}) async {
    Map<String, dynamic> body = {
      'description': description,
      'due_date': dueDate,
      'is_reminder': isReminder,
      'assignees': assignees,
      'organizationId': organizationId,
      'created_by': createdBy,
      'team': team
    };
    return await _customHttpClient.postRequest(path: createTaskPath, body: body);
  }

  Future<Response> getTaskRequest(int organizationId) async {
    return await _customHttpClient.getRequest(getTaskPath(organizationId));
  }

  Future<Response> getTaskStatisticsRequest(int? userId) async {
    return await _customHttpClient.getRequest(getTaskStatisticsPath(userId));
  }

  Future<Response> updateTaskRequest(
      {int? taskId,
      String? status,
      String? description,
      String? dueDate,
      bool? isReminder,
      List<int>? assignees,
      String? team,
      String? priorityLevel}) async {
    Map body = {
      'status': status,
      'description': description,
      'due_date': dueDate,
      'is_reminder': isReminder,
      'assignees': assignees,
      'team': team,
      'priority_level': priorityLevel
    };
    return await _customHttpClient.patchRequest(path: '$updateTaskPath/$taskId', body: body);
  }

  Future<Response> markAsCompletedRequest({required int taskId, required String status}) async {
    Map body = {'status': status};
    return await _customHttpClient.patchRequest(path: '$updateTaskPath/$taskId', body: body);
  }
}
