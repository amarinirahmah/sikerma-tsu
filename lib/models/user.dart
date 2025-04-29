import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  bool success;
  List<Datum> data;
  String message;

  User({required this.success, required this.data, required this.message});

  factory User.fromJson(Map<String, dynamic> json) => User(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  String name;
  String email;
  String password;
  String role;

  Datum({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "role": role,
  };
}
