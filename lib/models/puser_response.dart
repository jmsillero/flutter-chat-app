// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/users.dart';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  final bool ok;
  final Data data;

  UserResponse({
    required this.ok,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        ok: json["ok"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "data": data.toJson(),
      };
}

class Data {
  final User user;
  final String token;

  Data({
    required this.user,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}
