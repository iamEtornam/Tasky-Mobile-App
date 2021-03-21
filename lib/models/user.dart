// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'organization.dart' as Org;

class User {
    User({
        this.status,
        this.message,
        this.data,
    });

    bool status;
    String message;
    Data data;

    factory User.fromMap(Map<String, dynamic> json) => User(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
    };
}

class Data {
    Data({
        this.id,
        this.name,
        this.picture,
        this.organizationId,
        this.department,
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

    int id;
    String name;
    String picture;
    int organizationId;
    String department;
    String fcmToken;
    String authToken;
    String email;
    dynamic phoneNumber;
    String userId;
    String signInProvider;
    DateTime createdAt;
    DateTime updatedAt;
    Org.Data organization;

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        picture: json["picture"] == null ? null : json["picture"],
        organizationId: json["organizationId"] == null ? null : json["organizationId"],
        department: json["department"] == null ? null : json["department"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        authToken: json["auth_token"] == null ? null : json["auth_token"],
        email: json["email"] == null ? null : json["email"],
        phoneNumber: json["phone_number"],
        userId: json["user_id"] == null ? null : json["user_id"],
        signInProvider: json["sign_in_provider"] == null ? null : json["sign_in_provider"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        organization: json["organization"] == null ? null : Org.Data.fromMap(json["organization"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "picture": picture == null ? null : picture,
        "organizationId": organizationId == null ? null : organizationId,
        "department": department == null ? null : department,
        "fcm_token": fcmToken == null ? null : fcmToken,
        "auth_token": authToken == null ? null : authToken,
        "email": email == null ? null : email,
        "phone_number": phoneNumber,
        "user_id": userId == null ? null : userId,
        "sign_in_provider": signInProvider == null ? null : signInProvider,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "organization": organization == null ? null : organization.toMap(),
    };
}