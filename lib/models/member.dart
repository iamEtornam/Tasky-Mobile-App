import 'package:tasky_app/models/user.dart';

class Member {
  Member({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Data> data;

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data":
            data == null ? null : List<Data>.from(data.map((x) => x.toMap())),
      };
}
