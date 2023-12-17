import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:http/http.dart' as http;

class orderTestServerPage extends StatefulWidget {
  @override
  _orderTestServerState createState() => _orderTestServerState();
}

class _orderTestServerState extends State<orderTestServerPage> {
  final LocationService _locationService = LocationService();
  TextEditingController _orderNameController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _initiatorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  double _currentPosition_x = 0.0;
  double _currentPosition_y = 0.0;
  String orderInfo = "no info";
  String surroundingOrderInfo = "";
  List<orderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition_x = position.longitude;
        _currentPosition_y = position.latitude;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getOrders() async {
    try {
      List<orderModel> responseOrders = await orderApi.getSurroundingOrder(
          double.tryParse(_distanceController.text),
          _currentPosition_x,
          _currentPosition_y); // TODO： 根据实际情况修改传入的参数
      setState(() {
        orders = responseOrders;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Widget generateAvatar(String title) {
    final List<String> words = title.split(' ');
    String initials = '';
    if (words.isNotEmpty) {
      initials = words[0][0].toUpperCase();
    }

    return CircleAvatar(
      backgroundColor: Colors.blue, // 设置背景颜色
      child: Text(
        initials,
        style: TextStyle(color: Colors.white), // 设置前景文本颜色
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PinTestTool')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _orderNameController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "orderName", prefixIcon: Icon(Icons.edit)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _startTimeController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "startTime", prefixIcon: Icon(Icons.alarm)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _initiatorController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "initiator", prefixIcon: Icon(Icons.person)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "description", prefixIcon: Icon(Icons.person)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    Text('经度：${_currentPosition_x}'),
                    const SizedBox(height: 12),
                    Text('纬度：${_currentPosition_y}'),
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child: Text(orderInfo),
                ),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                      onPressed: () => setState(() {
                            orderInfo = orderApi
                                .createOrder(
                                    _orderNameController.text,
                                    int.tryParse(_initiatorController.text),
                                    _startTimeController.text,
                                    _descriptionController.text,
                                    _currentPosition_x,
                                    _currentPosition_y)
                                .toString();
                          }),
                      child: const Text("submit")),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _distanceController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: "distance", prefixIcon: Icon(Icons.map)),
                      textAlign: TextAlign.center,
                    )),
                OutlinedButton(
                    onPressed: () => setState(() {
                          _getOrders();
                        }),
                    child: const Text("Get Surrounding Orders")),
              ],
            ),
            orders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: generateAvatar(orders[index].orderName),
                          title: Text(orders[index].orderName),
                          subtitle: Text(
                              '${orders[index].description ?? ""}\n${orders[index].startTime}'),
                          trailing: Text(orders[index].distance == null
                              ? ""
                              : '${orders[index].distance ?? ""} km'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
