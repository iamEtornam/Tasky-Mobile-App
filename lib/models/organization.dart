// To parse this JSON data, do
//
//     final organization = organizationFromMap(jsonString);

import 'dart:convert';

import 'package:tasky_mobile_app/models/user.dart';

Organization organizationFromMap(String str) =>
    Organization.fromMap(json.decode(str));

String organizationToMap(Organization data) => json.encode(data.toMap());

class Organization {
  Organization({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory Organization.fromMap(Map<String, dynamic> json) => Organization(
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
    this.logo,
    this.teams,
    this.createdAt,
    this.updatedAt,
    this.members,
  });

  int? id;
  String? name;
  String? logo;
  List<String>? teams;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<User>? members;

  factory Data.fromMap(dynamic json) => Data(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        teams: json["teams"] == null
            ? null
            : List<String>.from(json["teams"].map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        members: json["members"] == null
            ? null
            : List<User>.from(json["members"].map((x) => User.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "logo": logo,
        "teams": teams == null ? null : List<dynamic>.from(teams!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "members": members == null
            ? null
            : List<dynamic>.from(members!.map((x) => x.toMap())),
      };
}
