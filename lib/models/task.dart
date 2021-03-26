import 'package:tasky_app/models/user.dart' as User;

import 'organization.dart' as Org;

class Task {
  Task({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
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

  int id;
  String description;
  String dueDate;
  bool isReminder;
  List<User.Data> assignees;
  List<String> participants;
  int organizationId;
  int createdBy;
  String team;
  String priorityLevel;
  DateTime createdAt;
  DateTime updatedAt;
  Org.Data organization;
  User.Data creator;
  String status;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        description: json["description"] == null ? null : json["description"],
        dueDate: json["due_date"] == null ? null : json["due_date"],
        isReminder: json["is_reminder"] == null ? null : json["is_reminder"],
        status: json["status"] == null ? null : json["status"],
        assignees: json["assignees"] == null
            ? null
            : List<User.Data>.from(
                json["assignees"].map((x) => User.Data.fromMap(x))),
        participants: json["assignees"] == null
            ? null
            : List<String>.from(json["assignees"].map((x) => x['picture'])),
        organizationId:
            json["organizationId"] == null ? null : json["organizationId"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        team: json["team"] == null ? null : json["team"],
        priorityLevel:
            json["priority_level"] == null ? null : json["priority_level"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        organization: json["organization"] == null
            ? null
            : Org.Data.fromMap(json["organization"]),
        creator:
            json["creator"] == null ? null : User.Data.fromMap(json["creator"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "description": description == null ? null : description,
        "due_date": dueDate == null ? null : dueDate,
        "is_reminder": isReminder == null ? null : isReminder,
        "assignees": assignees == null
            ? null
            : List<dynamic>.from(assignees.map((x) => x.toMap())),
        "organizationId": organizationId == null ? null : organizationId,
        "created_by": createdBy == null ? null : createdBy,
        "team": team == null ? null : team,
        "priority_level": priorityLevel == null ? null : priorityLevel,
        "status": status == null ? null : status,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "organization": organization == null ? null : organization.toMap(),
        "creator": creator == null ? null : creator.toMap(),
      };
}
