// To parse this JSON data, do
//
//     final wechatLoginModel = wechatLoginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) =>
    json.encode(data.toJson());

class LoginModel {
  int? code;
  String? message;
  LoginData? data;

  LoginModel({
    this.code,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      LoginModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class LoginData {
  String? userId;
  String? userName;
  String? avatar;

  LoginData({
    this.userId,
    this.userName,
    this.avatar,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      LoginData(
        userId: json["userId"],
        userName: json["userName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "avatar": avatar,
      };
}
