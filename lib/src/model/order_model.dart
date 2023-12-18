// 订单模型
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:http/http.dart' as http;

class orderModel {
  final int orderID;
  final String orderName;
  final String? description;
  final int initiator; // 发起人（ID）
  final int statusCode;
  final String startTime; // dateTime?
  final double position_x;
  final double position_y;
  int? groupID;
  final double? distance;

  orderModel({
    required this.orderID,
    required this.orderName,
    this.description,
    required this.initiator,
    required this.statusCode,
    required this.startTime,
    required this.position_x,
    required this.position_y,
    this.groupID,
    this.distance,
  });

  factory orderModel.fromJson(Map<String, dynamic> json) {
    return orderModel(
        orderID: json["orderID"],
        orderName: json["orderName"],
        description: json["description"],
        initiator: json["initiator"],
        statusCode: json["statusCode"],
        startTime: json["startTime"],
        position_x: json["position_x"],
        position_y: json["position_y"],
        groupID: json["groupID"],
        distance: json["DISTANCE"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'orderName': orderName,
      'description': description,
      'initiator': initiator,
      'statusCode': statusCode,
      'startTime': startTime,
      'position_x': position_x,
      'position_y': position_y,
      'groupID': groupID,
      'distance': distance,
    };
  }
}

class orderApi {
  static Future<orderModel> createOrder(orderName, initiator, startTime,
      description, currentPosition_x, currentPosition_y) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.urlWebMap["new_order"]!),
        body: json.encode({
          'orderName': orderName,
          'initiator': initiator,
          'description': description,
          'startTime': startTime,
          'position_x': currentPosition_x ?? 0.0,
          'position_y': currentPosition_y ?? 0.0
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        return orderModel.fromJson(responseData);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (error) {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<Map<String, dynamic>> joinOrder(userID, orderID) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.urlWebMap["join_order"]!),
        body: json.encode({
          'participantID': userID,
          'orderID': orderID,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        return {
          "code": response.statusCode,
          "data": orderModel.fromJson(responseData)
        };
      } else {
        return {"code": response.statusCode, "data": {}};
      }
    } catch (error) {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<List<orderModel>> getSurroundingOrder(
      distance, currentPosition_x, currentPosition_y) async {
    try {
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["surrounding_order"]! +
            "?type=distance&distance=" +
            distance.toString() +
            "&lat=" +
            currentPosition_x.toString() +
            "&lon=" +
            currentPosition_y.toString()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<orderModel> orders = [];
        for (var orderData in responseData) {
          orders.add(orderModel.fromJson(orderData));
        }
        return orders;
      } else {
        throw Exception(
            'Failed to create order with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<List<dynamic>> requestOrderParticipants(int orderID) async {
    try {
      var response = await http.get(
        Uri.parse(Constant.urlWebMap["get_order"]! +
            "?type=participants&orderID=" +
            orderID.toString()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return (json.decode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<orderModel> getOrderInfo(orderID) async {
    try {
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["get_order"]! +
            "?type=id&orderID=" +
            orderID.toString()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<orderModel> orders = [];
        for (var orderData in responseData) {
          orders.add(orderModel.fromJson(orderData));
        }
        return orders[0];
      } else {
        throw Exception(
            'Failed to get order with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<List<chatMessagesModel>> getUserMessages() async {
    try {
      UserModel? user = await getUserInfo();
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["surrounding_order"]! +
            "?type=participant&participantID=" +
            (user?.userID?.toString() ?? "-1")),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<chatMessagesModel> msgs = [];
        for (var msgData in responseData) {
          msgs.add(chatMessagesModel.fromJson(msgData));
        }
        return msgs;
      } else {
        throw Exception(
            'Failed to get user msgs with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<List<chatMessagesModel>> getUserLatestMessages() async {
    try {
      UserModel? user = await getUserInfo();
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["msg_get"]! +
            "?type=participant&participantID=" +
            (user?.userID?.toString() ?? "-1")),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);

        Map<int, chatMessagesModel> groupMsgs = {};

        for (var msgData in responseData) {
          chatMessagesModel msg = chatMessagesModel.fromJson(msgData);
          int groupID = msg.groupID;

          if (!groupMsgs.containsKey(groupID) ||
              DateTime.parse(groupMsgs[groupID]!.timestamp)
                  .isBefore(DateTime.parse(msg.timestamp))) {
            groupMsgs[groupID] = msg;
          }
        }

        List<chatMessagesModel> msgs = groupMsgs.values.toList();
        msgs.sort((a, b) =>
            DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

        return msgs;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Failed to get user msgs with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<List<chatMessagesModel>> getGroupMessages(groupID) async {
    try {
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["msg_get"]! +
            "?type=group&groupID=" +
            groupID.toString()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<chatMessagesModel> msgs = [];
        for (var msgData in responseData) {
          // debugPrint(msgData.toString());
          msgs.add(chatMessagesModel.fromJson(msgData));
        }
        return msgs;
      } else {
        throw Exception(
            'Failed to get user msgs with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<List<orderModel>> getUserOrders(userID) async {
    try {
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["get_order"]! +
            "?type=participant&participantID=" +
            userID.toString()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<orderModel> orders = [];
        for (var orderData in responseData) {
          orders.add(orderModel.fromJson(orderData));
        }
        return orders;
      } else {
        throw Exception(
            'Failed to get order with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<chatMessagesModel> newMessage(
      senderID, groupID, messageText) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.urlWebMap["new_msg"]!),
        body: json.encode({
          'senderID': senderID,
          'groupID': groupID,
          'messageText': messageText,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        return chatMessagesModel.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to create msg with statusCode = ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<List<chatMessagesModel>> getOrderMessages(orderID) async {
    try {
      final response = await http.get(
        Uri.parse(Constant.urlWebMap["msg_get"]! +
            "?type=order&orderID=" +
            orderID.toString()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        List<chatMessagesModel> msgs = [];
        for (var msgData in responseData) {
          msgs.add(chatMessagesModel.fromJson(msgData));
        }
        return msgs;
      } else {
        throw Exception(
            'Failed to get user msgs with status: ${response.statusCode}.');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<orderModel> newOrder(senderID, groupID, messageText) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.urlWebMap["new_msg"]!),
        body: json.encode({
          'senderID': senderID,
          'groupID': groupID,
          'messageText': messageText,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        return orderModel.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to create msg with statusCode = ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to connect to server');
    }
  }
}

// 订单群聊模型（示例）
class orderGroupModel {
  // 你的订单群聊模型的属性
  final int orderID;
  final String groupName;
  final int groupID;

  orderGroupModel({
    required this.orderID,
    required this.groupName,
    required this.groupID,
  });

  factory orderGroupModel.fromJson(Map<String, dynamic> json) {
    return orderGroupModel(
        orderID: json["orderID"],
        groupName: json["groupName"],
        groupID: json["groupID"]);
  }
}

class orderParticipantsModel {
  final int orderID;
  final String participantName;
  final int participantID;

  orderParticipantsModel({
    required this.orderID,
    required this.participantName,
    required this.participantID,
  });

  factory orderParticipantsModel.fromJson(Map<String, dynamic> json) {
    return orderParticipantsModel(
        orderID: json["orderID"],
        participantName: json["participantName"],
        participantID: json["participantID"]);
  }
}

class chatMessagesModel {
  final int messageID;
  final int groupID;
  final int senderID;
  final String? avatar;
  final int? orderID;
  final String? senderName;
  final String messageText;
  final String timestamp;
  final String? groupName;

  chatMessagesModel(
      {required this.messageID,
      required this.groupID,
      required this.senderID,
      required this.messageText,
      required this.timestamp,
      this.orderID,
      this.avatar,
      this.senderName,
      this.groupName});

  factory chatMessagesModel.fromJson(Map<String, dynamic> json) {
    return chatMessagesModel(
        messageID: json["messageID"],
        groupID: json["groupID"],
        orderID: json["orderID"],
        senderID: json["senderID"],
        senderName: json["senderName"] ?? "未知用户",
        avatar: json["avatar"],
        messageText: json["messageText"],
        timestamp: json["timestamp"],
        groupName: json["groupName"] ?? "未命名的聊天");
  }
}
