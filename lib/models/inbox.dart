class Inbox {
    Inbox({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<Datum>? data;

    factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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

    int? id;
    String? title;
    String? message;
    int? userId;
    DateTime? dueDate;
    String? status;
    String? team;
    dynamic like;
    String? type;
    String? action;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Comment>? comments;
    User? user;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        userId: json["userId"],
        dueDate: DateTime.parse(json["due_date"]),
        status: json["status"],
        team: json["team"],
        like: json["like"] != null ? List<String>.from(json["like"].map((x) => x)) : null,
        type: json["type"],
        action: json["action"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "userId": userId,
        "due_date": dueDate!.toIso8601String(),
        "status": status,
        "team": team,
        "like": List<dynamic>.from(like!.map((x) => x)),
        "type": type,
        "action": action,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "user": user!.toJson(),
    };
}

class Comment {
    Comment({
        this.id,
        this.message,
        this.userId,
        this.like,
        this.type,
        this.action,
        this.inboxId,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? message;
    int? userId;
    dynamic like;
    String? type;
    String? action;
    int? inboxId;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        message: json["message"],
        userId: json["userId"],
        like: json["like"] != null ? List<String>.from(json["like"].map((x) => x)) : null,
        type: json["type"],
        action: json["action"],
        inboxId: json["inboxId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "userId": userId,
        "like": List<dynamic>.from(like!.map((x) => x)),
        "type": type,
        "action": action,
        "inboxId": inboxId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
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
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
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
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
