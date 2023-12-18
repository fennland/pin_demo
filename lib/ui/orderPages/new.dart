// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/ui/indexPages/home.dart';
import 'package:pin_demo/ui/msgPages/conversations.dart';
import 'package:pin_demo/ui/orderPages/ordering.dart';
import 'package:provider/provider.dart';

class newOrderPage extends StatefulWidget {
  const newOrderPage({super.key});

  @override
  State<newOrderPage> createState() => _newOrderPageState();
}

class _newOrderPageState extends State<newOrderPage> {
  final TextEditingController _orderNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final LocationService _locationService = LocationService();
  late double _position_x;
  late double _position_y;
  orderModel? orderM;
  int? userID;
  String? startTime = "1970-01-01 00:00:00";
  String? startTime_shortDisplay = "01/01 00:00";
  BMFMapController? myMapController = BMFMapController.withId(2);

  @override
  void initState() {
    super.initState();
    _getUserID();
    _getCurrentLocation();
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<Position> _getCurrentLocation() async {
    final Position position = await _locationService.getCurrentLocation();
    _position_x = position.latitude;
    _position_y = position.longitude;
    // BMFMarker marker = BMFMarker.icon(
    //   position: BMFCoordinate(_position_x, _position_y),
    //   icon: 'static/images/icon_marker.png',
    //   title: 'flutterMaker',
    //   identifier: 'flutter_marker',
    // );
    // myMapController?.addMarker(marker);
    // myMapController?.showUserLocation(true);
    // BMFCoordinate coordinate = BMFCoordinate(_position_x, _position_y); // 经纬度信息

    // BMFLocation location = BMFLocation(
    //     // 定位信息
    //     coordinate: coordinate, // 经纬度
    //     altitude: 0, // 海拔
    //     horizontalAccuracy: 5, // 水平精确度
    //     verticalAccuracy: -1.0, // 垂直精确度
    //     speed: -1.0, // 速度
    //     course: -1.0); // 航向

    // BMFUserLocation userLocation = BMFUserLocation(
    //   // 当前位置对象
    //   location: location,
    // );

    // myMapController?.updateLocationData(userLocation);
    // BMFUserLocationDisplayParam displayParam = BMFUserLocationDisplayParam(
    //     locationViewOffsetX: 0,
    //     locationViewOffsetY: 0,
    //     accuracyCircleFillColor: Colors.red,
    //     accuracyCircleStrokeColor: Colors.blue,
    //     isAccuracyCircleShow: true,
    //     locationViewImage: 'static/images/icon_marker_unselected.png',
    //     locationViewHierarchy:
    //         BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_TOP);
    // myMapController?.updateLocationViewWithParam(displayParam);
    return position;
  }

  Future<void> _getUserID() async {
    var user = await getUserInfo();
    if (user != null) {
      userID = user.userID;
    }
  }

  Future<bool> _createOrder() async {
    try {
      var user = await getUserInfo();
      if (user != null) {
        orderM = await orderApi.createOrder(
            _orderNameController.text,
            user.userID,
            startTime,
            _descriptionController.text,
            _position_x,
            _position_y);
        return (orderM != null);
      } else {
        throw ErrorHint("Not Loged in");
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          // title: Text(languageProvider.get("newOrder"),
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<Position>(
                future: _getCurrentLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.hasData) {
                    // 获取位置信息成功，将其传递给地图组件
                    final position = snapshot.data!;
                    return !unSupportedPlatform
                        ? generateMap(
                            onTap: () {},
                            flex: 4,
                            con: myMapController,
                            width: screenSize.width * 0.95,
                            borderRadius: screenSize.width / 20,
                            zoomLevel: 15,
                            isChinese:
                                (languageProvider.currentLanguage == "zh"),
                            lat: position.latitude,
                            lon: position.longitude)
                        : Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  languageProvider
                                      .get("unsupportedPlatformConfirm"),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                  } else {
                    return Expanded(
                        flex: 4,
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
            Expanded(
              flex: 3,
              child: Container(
                constraints: const BoxConstraints(minHeight: 180.0),
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextField(
                                    controller: _orderNameController,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 15.0),
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(
                                          minHeight: 32.0, maxHeight: 48.0),
                                      labelText: languageProvider
                                          .get("newOrder_orderName"),
                                      hintText: languageProvider
                                          .get("newOrder_orderName_hint"),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: startTime != "1970-01-01 00:00:00"
                                        ? const Icon(Icons.alarm_on,
                                            color: Colors.green)
                                        : const Icon(Icons.alarm_add),
                                    onPressed: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(
                                            DateTime.now().year, 12, 31),
                                      );

                                      if (selectedDate != null) {
                                        // ignore: use_build_context_synchronously
                                        final selectedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (selectedTime != null) {
                                          final combinedDateTime = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute,
                                          );

                                          setState(() {
                                            startTime = DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss')
                                                .format(combinedDateTime);
                                            print(startTime);
                                            startTime_shortDisplay =
                                                DateFormat('MM/dd HH:mm')
                                                    .format(combinedDateTime);
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                          child: TextField(
                            controller: _descriptionController,
                            maxLength: 100,
                            maxLines: null,
                            style: const TextStyle(fontSize: 15.0),
                            decoration: InputDecoration(
                              constraints: const BoxConstraints(
                                  minHeight: 24.0, maxHeight: 32.0),
                              label: Text(
                                languageProvider.get("newOrder_description"),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              hintText: languageProvider
                                  .get("newOrder_description_hint"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
                          child: TextButton(
                            onPressed: () async {
                              if (startTime == "1970-01-01 00:00:00" ||
                                  _orderNameController.text.isEmpty ||
                                  _descriptionController.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("信息未填写完整"),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 109, 109),
                                ));
                              } else {
                                var result = await _createOrder();
                                if (result) {
                                  orderApi.newMessage(userID, orderM?.groupID,
                                      "需求群已经建立啦！快来一起交流吧～");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConversationsPage(
                                          groupID: orderM?.groupID,
                                          groupName: orderM?.orderName)));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text("创建需求时存在问题，请重试。"),
                                    action: SnackBarAction(
                                      label: "重试",
                                      onPressed: () {
                                        setState(() {});
                                      },
                                    ),
                                  ));
                                }
                              }
                            },
                            style: ButtonStyle(
                              maximumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 60)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 45)), // 设置按钮最小尺寸
                              // padding: MaterialStateProperty.all(
                              //     EdgeInsets.zero), // 去除默认内边距
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          16.0))), // 设置按钮圆角
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blue), // 设置按钮背景色
                            ),
                            child: Text(
                              languageProvider.get("newOrder"),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
