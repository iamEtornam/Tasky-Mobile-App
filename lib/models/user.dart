// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'organization.dart' as org;

class User {
  User({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory User.fromMap(Map<String, dynamic> json) => User(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data!.toMap(),
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.picture,
    this.organizationId,
    this.team,
    this.fcmToken,
    this.authToken,
    this.email,
    this.phoneNumber,
    this.userId,
    this.signInProvider,
    this.createdAt,
    this.updatedAt,
    this.organization,
  });

  int? id;
  String? name;
  String? picture;
  int? organizationId;
  String? team;
  String? fcmToken;
  String? authToken;
  String? email;
  dynamic phoneNumber;
  String? userId;
  String? signInProvider;
  DateTime? createdAt;
  DateTime? updatedAt;
  org.Data? organization;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        organizationId: json["organizationId"],
        team: json["team"],
        fcmToken: json["fcm_token"],
        authToken: json["auth_token"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        userId: json["user_id"],
        signInProvider: json["sign_in_provider"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        organization: json["organization"] == null ? null : org.Data.fromMap(json["organization"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "picture": picture,
        "organizationId": organizationId,
        "team": team,
        "fcm_token": fcmToken,
        "auth_token": authToken,
        "email": email,
        "phone_number": phoneNumber,
        "user_id": userId,
        "sign_in_provider": signInProvider,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "organization": organization!.toMap(),
      };
}
