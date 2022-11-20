const String baseUrl =  String.fromEnvironment('BASE_URL');
const String loginPath = '$baseUrl/login';
const String organizationPath = '$baseUrl/getOrganizationById';
const String updateTeamPath = '$baseUrl/updateUserTeam';
const String createOrganizationPath = '$baseUrl/createOrganization';
const String getUserInformationPath = '$baseUrl/getUserInformation';
const String inviteMembersPath = '$baseUrl/inviteMembers';
const String createTaskPath = '$baseUrl/createTask';
String listMembersPath(int? organizationId) =>
    '$baseUrl/listMembers/$organizationId';
 String fileUploaderPath =
    '${const String.fromEnvironment('FILE_UPLOAD_URL')}/api/v0/upload';
const String updateTokenPath = '$baseUrl/updateUserToken';
const String updateUserPath = '$baseUrl/updateUserInformation';
String getTaskPath(int? organizationId) => '$baseUrl/getTasks/$organizationId';
String getTaskStatisticsPath(int? userId) =>
    '$baseUrl/getTaskStatusCount/$userId';
const String updateTaskPath = '$baseUrl/updateTask';
String getUserInboxPath(int? userId) => '$baseUrl/getUserInbox/$userId';
String getUserInboxCommentPath(int? inboxId) => '$baseUrl/getUserInboxComment/$inboxId';
String submitUserInboxCommentPath(int? inboxId) => '$baseUrl/submitInboxComment/$inboxId';