// To parse this JSON data, do
//
//     final wechatUsersModel = wechatUsersModelFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      userID: json["userID"],
      userName: json["userName"],
      phone: json["phone"],
      avatar: json["avatar"],
    );
  }
}

// 在登录/注册成功后保存用户信息
void saveCurUserInfo(UserModel user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    prefs.setInt('userID', user.userID!);
    prefs.setString('userName', user.userName!);
    prefs.setString('phone', user.phone!);
    prefs.setString(
        'avatar',
        user.avatar ??
            "https://img2.baidu.com/it/u=3726660842,3936973858&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300");
    prefs.setString('sign', user.sign ?? "");
    // 其他属性同理
  } catch (e) {
    debugPrint(e.toString());
  }
}

// 在需要获取用户信息时从本地读取
Future<UserModel?> getCurUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userID');
  String? userName = prefs.getString('userName');
  String? phone = prefs.getString('phone');
  String? avatar = prefs.getString('avatar');
  String? sign = prefs.getString('sign');
  // String? gender = prefs.getString('gender');
  // String? keyword = prefs.getString('keyword');
  // 其他属性同理

  if (userId != null && userName != null && phone != null) {
    return UserModel(
      userID: userId,
      userName: userName,
      phone: phone,
      avatar: avatar,
      sign: sign,
      // gender: gender,
      // keyword: keyword,
      // 其他属性同理
    );
  } else {
    return null;
  }
}

Future<Map<String, dynamic>> requestUserInfo(int userid) async {
  try {
    var response = await http.get(
      Uri.parse(Constant.urlWebMap["get_user"]! + userid.toString()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      return (json.decode(response.body));
    } else {
      return {};
    }
  } catch (e) {
    debugPrint(e.toString());
    return {};
  }
}

Future<Map<String, dynamic>> postLoginForm(
    phone, pwd, currentPosition_x, currentPosition_y) async {
  try {
    var response = await http.post(
      Uri.parse(Constant.urlWebMap["login"]!),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'pwd': pwd,
        'position_x': currentPosition_x ?? 0.0,
        'position_y': currentPosition_y ?? 0.0
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint(response.body);
      return ({
        "code": response.statusCode,
        "result": json.decode(response.body)
      });
    } else {
      return ({"code": response.statusCode, "result": {}});
    }
  } catch (e) {
    return ({"code": 500, "error": e.toString()});
  }
}

Future<Map<String, dynamic>> postLoginForm_logined(
    phone, currentPosition_x, currentPosition_y) async {
  try {
    var response = await http.post(
      Uri.parse(Constant.urlWebMap["logined"]!),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'position_x': currentPosition_x ?? 0.0,
        'position_y': currentPosition_y ?? 0.0
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint(response.body);
      return ({
        "code": response.statusCode,
        "result": json.decode(response.body)
      });
    } else {
      return ({"code": response.statusCode, "result": {}});
    }
  } catch (e) {
    return ({"code": 500, "error": e.toString()});
  }
}

Future<Map<String, dynamic>> postRegisterForm(username, phone, pwd) async {
  try {
    var response = await http.post(
      Uri.parse(Constant.urlWebMap["register"]!),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userName': username, 'phone': phone, 'pwd': pwd}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint(response.body);
      return ({
        "code": response.statusCode,
        "result": json.decode(response.body)
      });
    } else {
      return ({"code": response.statusCode, "result": {}});
    }
  } catch (e) {
    return ({"code": 500, "error": e.toString()});
  }
}

Future<Map<String, dynamic>> getCurrentLocation(
    locationService, mounted) async {
  try {
    final Position position = await locationService.getCurrentLocation();
    if (mounted) {
      return {"x": position.longitude, "y": position.latitude};
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return {"x": 0.0, "y": 0.0};
}
  
Future<Map<String, dynamic>> changePersonData(user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userID = prefs.getInt('userID');
  // String? token = prefs.getString('token');

  // Map<String, String> headers = {'authorization': token!};

  // Map<String, String> body = {'username': username};

  try {
    http.Response response = await http.post(
      Uri.parse(Constant.urlWebMap["changePersonData"]!),
      // headers: headers,
      // body: body,
    );

    prefs.setString('userName', user.userName!);
    
    Map<String, dynamic> result = jsonDecode(response.body);
    if (result['code'] == 200) {
      // 修改成功，更新本地存储的用户信息
      UserModel user = UserModel.fromJson(result['data']);
      saveUserInfo(user);
    }

    return result;
  } catch (e) {
    debugPrint(e.toString());
    return {"code": 500, "msg": "服务器错误"};
  }
}

Future<Map<String, dynamic>> saveModifiedNameToCloud(userID, userName, gender, sign) async {
  try {
    var response = await http.put(
      Uri.parse(Constant.urlWebMap["saveModifiedNameToCloud"]!),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userID': userID, 'userName': userName, 'gender': gender, 'sign': sign}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint(response.body);
      return ({
        "code": response.statusCode,
        "result": json.decode(response.body)
      });
    } else {
      return ({"code": response.statusCode, "result": {}});
    }
  } catch (e) {
    return ({"code": 500, "error": e.toString()});
  }
}