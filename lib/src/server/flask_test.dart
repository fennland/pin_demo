import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:http/http.dart' as http;

class TestServerPage extends StatefulWidget {
  @override
  _TestServerPageState createState() => _TestServerPageState();
}

class _TestServerPageState extends State<TestServerPage> {
  final LocationService _locationService = LocationService();
  double _currentPosition_x = 0.0;
  double _currentPosition_y = 0.0;
  String connectionInfo = '';
  String dbInfo = '';
  String positionInfo = '';

  @override
  void initState() {
    super.initState();
    _getConnectionInfo();
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

  Future<void> _getConnectionInfo() async {
    try {
      final response = await http.get(Uri.parse(Constant.urlWebMap["hello"]!));
      if (response.statusCode == 200) {
        setState(() {
          connectionInfo = '连接成功！\n状态码：${response.statusCode}';
          _getDatabaseInfo();
        });
      } else {
        setState(() {
          connectionInfo = '连接失败！\n状态码：${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        connectionInfo = '连接失败！\n${e.toString()}';
      });
    }
  }

  Future<void> _getDatabaseInfo() async {
    try {
      final response =
          await http.get(Uri.parse(Constant.urlWebMap["database"]!));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dbInfo = '数据库信息：\n${data.toString()}';
        });
      } else {
        setState(() {
          dbInfo = '获取数据库信息失败！\n状态码：${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        dbInfo = '获取数据库信息失败！\n${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PinTestTool')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('连接信息：', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(connectionInfo),
            SizedBox(height: 16),
            Text('数据库信息：', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(dbInfo),
            SizedBox(height: 16),
            Text('经度：${_currentPosition_x}'),
            SizedBox(height: 12),
            Text('纬度：${_currentPosition_y}'),
            SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/server/test/orders"),
                    child: Text("newOrderTest")),
                SizedBox(width: 16),
                // OutlinedButton(
                //     onPressed: () => Navigator.of(context)
                //         .pushNamed("/server/test/ordergroups"),
                //     child: Text("OrderGroudTest"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
