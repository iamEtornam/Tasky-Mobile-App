class TaskStatistic {
  TaskStatistic({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory TaskStatistic.fromMap(Map<String, dynamic> json) => TaskStatistic(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    this.todo,
    this.inProgress,
    this.completed,
  });

  int? todo;
  int? inProgress;
  int? completed;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        todo: json["todo"] ?? 0,
        inProgress: json["in_progress"] ?? 0,
        completed: json["completed"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "todo": todo ?? 0,
        "in_progress": inProgress ?? 0,
        "completed": completed ?? 0,
      };
}
