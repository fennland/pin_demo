// To parse this JSON data, do
//
//     final wechatUsersModel = wechatUsersModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

UsersModel UsersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

class UsersModel {
  int? code;
  String? message;
  List<UserModel>? data;

  UsersModel({
    this.code,
    this.message,
    this.data,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<UserModel>.from(
                json["data"]!.map((x) => UserModel.fromJson(x))),
      );
}

///用户类
class UserModel {
  int? userID; //用户Id
  String? userName; //名称
  String? phone;
  String? avatar; //头像
  int? gender;
  int? age;
  double? position_x;
  double? position_y;
  String? sign;
  List<String>? fav;
  String? lastLoginTime;
  String? ipAddr;

  UserModel({
    required this.userID,
    required this.userName,
    required this.phone,
    required this.avatar,
    this.gender,
    this.age,
    this.position_x,
    this.position_y,
    this.sign,
    this.fav,
    this.lastLoginTime,
    this.ipAddr,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json["userId"],
      userName: json["userName"],
      phone: json["phone"],
      avatar: json["avatar"],
    );
  }
}

// 在登录/注册成功后保存用户信息
void saveUserInfo(UserModel user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    prefs.setInt('userID', user.userID!);
    prefs.setString('userName', user.userName!);
    prefs.setString('phone', user.phone!);
    prefs.setString('avatar', user.avatar!);
    prefs.setString('sign', user.sign!);
    // 其他属性同理
  } catch (e) {
    debugPrint(e.toString());
  }
}

// 在需要获取用户信息时从本地读取
Future<UserModel?> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userID');
  String? userName = prefs.getString('userName');
  String? phone = prefs.getString('phone');
  String? avatar = prefs.getString('avatar');
  String? sign = prefs.getString('sign');
  // 其他属性同理

  if (userId != null && userName != null && phone != null) {
    return UserModel(
      userID: userId,
      userName: userName,
      phone: phone,
      avatar: avatar,
      sign: sign,
      // 其他属性同理
    );
  } else {
    return null;
  }
}
