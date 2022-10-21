import 'package:tasky_mobile_app/models/user.dart' as user;

import 'organization.dart' as org;

class Task {
  Task({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum(
      {this.id,
      this.description,
      this.dueDate,
      this.isReminder,
      this.assignees,
      this.participants,
      this.organizationId,
      this.createdBy,
      this.team,
      this.priorityLevel,
      this.createdAt,
      this.updatedAt,
      this.organization,
      this.creator,
      this.status});

  int? id;
  String? description;
  String? dueDate;
  bool? isReminder;
  List<user.Data>? assignees;
  List<String>? participants;
  int? organizationId;
  int? createdBy;
  String? team;
  String? priorityLevel;
  DateTime? createdAt;
  DateTime? updatedAt;
  org.Data? organization;
  user.Data? creator;
  String? status;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        description: json["description"],
        dueDate: json["due_date"],
        isReminder: json["is_reminder"],
        status: json["status"],
        assignees: json["assignees"] == null
            ? null
            : List<user.Data>.from(json["assignees"].map((x) => user.Data.fromMap(x))),
        participants: json["assignees"] == null
            ? null
            : List<String>.from(json["assignees"].map((x) => x['picture'])),
        organizationId: json["organizationId"],
        createdBy: json["created_by"],
        team: json["team"],
        priorityLevel: json["priority_level"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        organization: json["organization"] == null ? null : org.Data.fromMap(json["organization"]),
        creator: json["creator"] == null ? null : user.Data.fromMap(json["creator"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "due_date": dueDate,
        "is_reminder": isReminder,
        "assignees":
            assignees == null ? null : List<dynamic>.from(assignees!.map((x) => x.toMap())),
        "organizationId": organizationId,
        "created_by": createdBy,
        "team": team,
        "priority_level": priorityLevel,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "organization": organization!.toMap(),
        "creator": creator!.toMap(),
      };
}
