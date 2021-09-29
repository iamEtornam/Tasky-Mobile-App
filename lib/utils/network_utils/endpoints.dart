const String baseUrl = 'https://84e3-102-177-101-3.ngrok.io/dev';
const String loginPath = '$baseUrl/login';
const String organizationPath = '$baseUrl/getOrganizationById';
const String updateTeamPath = '$baseUrl/updateUserTeam';
const String createOrganizationPath = '$baseUrl/createOrganization';
const String getUserInformationPath = '$baseUrl/getUserInformation';
const String inviteMembersPath = '$baseUrl/inviteMembers';
const String createTaskPath = '$baseUrl/createTask';
String listMembersPath(int organizationId) =>
    '$baseUrl/listMembers/$organizationId';
const String fileUploaderPath =
    'http://tasty-file-uploader.us-east-2.elasticbeanstalk.com/api/v0/upload';
const String updateTokenPath = '$baseUrl/updateUserToken';
String getTaskPath(int organizationId) => '$baseUrl/getTasks/$organizationId';
String getTaskStatisticsPath(int userId) =>
    '$baseUrl/getTaskStatusCount/$userId';
const String updateTaskPath = '$baseUrl/updateTask';
