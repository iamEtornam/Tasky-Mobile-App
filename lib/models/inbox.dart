// To parse this JSON data, do
//
//     final inbox = inboxFromJson(jsonString);

import 'dart:convert';

import 'package:tasky_mobile_app/models/user.dart' as user_profile;

import 'comment.dart' as comment;

Inbox inboxFromJson(String str) => Inbox.fromJson(json.decode(str));

String inboxToJson(Inbox data) => json.encode(data.toJson());

class Inbox {
    Inbox({
        this.status,
        this.message,
        this.data,
    });

    bool status;
    String message;
    List<Datum> data;

    factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.title,
        this.message,
        this.userId,
        this.dueDate,
        this.status,
        this.team,
        this.like,
        this.type,
        this.action,
        this.createdAt,
        this.updatedAt,
        this.comments,
        this.user,
    });

    int id;
    String title;
    String message;
    int userId;
    DateTime dueDate;
    String status;
    String team;
    List<String> like;
    String type;
    String action;
    DateTime createdAt;
    DateTime updatedAt;
    List<comment.Datum> comments;
    user_profile.Data user;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        userId: json["userId"],
        dueDate: DateTime.parse(json["due_date"]),
        status: json["status"],
        team: json["team"],
        like: List<String>.from(json["like"].map((x) => x)),
        type: json["type"],
        action: json["action"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        comments: List<comment.Datum>.from(json["comments"].map((x) => comment.Datum.fromJson(x))),
        user: user_profile.Data.fromMap(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "userId": userId,
        "due_date": dueDate.toIso8601String(),
        "status": status,
        "team": team,
        "like": List<dynamic>.from(like.map((x) => x)),
        "type": type,
        "action": action,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "user": user.toMap(),
    };
}

