final String baseUrl =
    'https://3so6qpofn6.execute-api.us-east-1.amazonaws.com/prod';
final String loginPath = '$baseUrl/login';
final String organizationPath = '$baseUrl/getOrganizationById';
final String updateDepartmentPath = '$baseUrl/updateUserDepartment';
final String createOrganizationPath = '$baseUrl/createOrganization';
final String getUserInformationPath = '$baseUrl/getUserInformation';
final String inviteMembersPath = '$baseUrl/inviteMembers';
final String createTaskPath = '$baseUrl/createTask';
String listMembersPath(int organizationId) =>
    '$baseUrl/listMembers/$organizationId';
final String fileUploaderPath =
    'http://tasty-file-uploader.us-east-2.elasticbeanstalk.com/api/v0/upload';
final String updateTokenPath = '$baseUrl/updateUserToken';
String getTaskPath(int organizationId) => '$baseUrl/getTasks/$organizationId';
