// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.message,
    this.userId,
    this.like,
    this.type,
    this.action,
    this.inboxId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? message;
  int? userId;
  List<String>? like;
  String? type;
  String? action;
  int? inboxId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        message: json["message"],
        userId: json["userId"],
        like: json["like"] == null
            ? null
            : List<String>.from(json["like"].map((x) => x)),
        type: json["type"],
        action: json["action"],
        inboxId: json["inboxId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "userId": userId,
        "like": like == null ? null : List<dynamic>.from(like!.map((x) => x)),
        "type": type,
        "action": action,
        "inboxId": inboxId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class User {
  User({
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
  });

  int? id;
  String? name;
  String? picture;
  int? organizationId;
  String? team;
  String? fcmToken;
  String? authToken;
  String? email;
  String? phoneNumber;
  String? userId;
  String? signInProvider;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
