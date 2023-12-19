// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
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
  final TextEditingController _locationController = TextEditingController();
  final LocationService _locationService = LocationService();
  List<String> poiKeywords = [];
  late double _position_x = 0.0;
  late double _position_y = 0.0;
  bool _useCurLocation = false;
  orderModel? orderM;
  int? userID;
  String? startTime = "1970-01-01 00:00:00";
  String? startTime_shortDisplay = "01/01 00:00";
  bool isLocationSelectionVisible = false;
  bool isSearched = false;
  bool _hasCurLocation = false;
  BMFMapController? myMapController = BMFMapController.withId(2);

  @override
  void initState() {
    super.initState();
    _getUserID();
    _getCurrentLocation();
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<bool> _getCurrentLocation() async {
    if (poiKeywords.isEmpty || unSupportedPlatform) {
      final Position position = await _locationService.getCurrentLocation();
      _position_y = position.latitude;
      _position_x = position.longitude;
      debugPrint(_position_x.toString());
      _hasCurLocation = true;
      return true;
    }
    _hasCurLocation = false;
    return false;
    // BMFMarker marker = BMFMarker.icon(
    //   position: BMFCoordinate(_position_x, _position_y),
    //   icon: 'static/images/icon_marker.png',
    //   title: 'flutterMaker',
    //   identifier: 'flutter_marker',
    // );
    // myMapController?.addMarker(marker);
    // myMapController?.showUserLocation(true);
    // BMFCoordinate coordinate = BMFCoordinate(_position_x, _position_y); // 经纬度信息
  }

  Future<void> _getUserID() async {
    var user = await getCurUserInfo();
    if (user != null) {
      userID = user.userID;
    }
  }

  Future<bool> _createOrder() async {
    try {
      var user = await getCurUserInfo();
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
        title: Text(languageProvider.get("newOrder"),
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            !unSupportedPlatform
                ? FutureBuilder<bool>(
                    future: _getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting &&
                          snapshot.hasData) {
                        // 获取位置信息成功，将其传递给地图组件
                        final isCurLocation = snapshot.data!;
                        return generateMap(
                            onTap: () {
                              if (!isLocationSelectionVisible) {
                                isSearched = false;
                                debugPrint("124:${poiKeywords.toString()}");
                                setState(() {
                                  // debugPrint("Visible!");
                                  isLocationSelectionVisible = true;
                                });
                              }
                            },
                            flex: isLocationSelectionVisible ? 3 : 4,
                            con: myMapController,
                            width: screenSize.width * 0.95,
                            borderRadius: screenSize.width / 20,
                            zoomLevel: 17,
                            zoomEnabled: false,
                            isChinese:
                                (languageProvider.currentLanguage == "zh"),
                            lat: _position_y,
                            lon: _position_x);
                      } else {
                        return Expanded(
                            flex: isLocationSelectionVisible ? 3 : 4,
                            child: const Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Loading")
                                ])));
                      }
                    })
                : Expanded(
                    flex: isLocationSelectionVisible ? 3 : 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          languageProvider.get("unsupportedPlatformConfirm"),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
            Container(
              constraints: const BoxConstraints(minHeight: 180.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isLocationSelectionVisible
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 8.0),
                              child: TextField(
                                controller: _locationController,
                                onSubmitted: (value) async {
                                  poiKeywords = [value];
                                  debugPrint("202:${poiKeywords.toString()}");
                                  var searchResult = await searchMapPoi(
                                    poiKeywords,
                                    BMFCoordinate(_position_y, _position_x),
                                    5000,
                                  );
                                  setState(() {
                                    // 更新位置信息
                                    if (searchResult != null) {
                                      Map<String, double?>? poiInfo =
                                          searchResult;
                                      _position_x = poiInfo?["lon"] ??
                                          _position_x; // x lon
                                      _position_y = poiInfo?["lat"] ??
                                          _position_y; // y lat
                                      // debugPrint(
                                      //     "212: ${searchResult.toString()}");
                                      // debugPrint("213: lon: ${_position_x}");
                                      isSearched = true;
                                      isLocationSelectionVisible = false;
                                    }
                                  });
                                },
                                maxLines: 1,
                                style: const TextStyle(fontSize: 15.0),
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                      minHeight: 32.0, maxHeight: 45.0),
                                  labelText:
                                      languageProvider.get("newOrder_location"),
                                  hintText: languageProvider
                                      .get("newOrder_location_hint"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("点击地图以选择位置...",
                                    style: TextStyle(
                                        fontWeight: poiKeywords.isEmpty
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: poiKeywords.isEmpty
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.color
                                            : Colors.green)),
                                !unSupportedPlatform
                                    ? Container()
                                    : TextButton(
                                        child: const Text("使用当前位置？"),
                                        onPressed: () {
                                          _useCurLocation = true;
                                          _getCurrentLocation();
                                          if (_hasCurLocation) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              content: Text(
                                                  "当前经度:${_position_x ?? "未获取到"}, 纬度: ${_position_y ?? "未获取到"}"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text("无法获取位置信息"),
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 109, 109),
                                              duration:
                                                  Duration(milliseconds: 1500),
                                            ));
                                          }
                                        },
                                      )
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                        minHeight: 36.0, maxHeight: 45.0),
                                    labelText: languageProvider
                                        .get("newOrder_orderName"),
                                    hintText: languageProvider
                                        .get("newOrder_orderName_hint"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                  ),
                                ),
                                child: IconButton(
                                  iconSize: 28.0,
                                  icon: startTime != "1970-01-01 00:00:00"
                                      ? const Icon(Icons.alarm_on,
                                          color: Colors.green)
                                      : const Icon(Icons.alarm_add),
                                  onPressed: () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year, 12, 31),
                                    );

                                    if (selectedDate != null) {
                                      // ignore: use_build_context_synchronously
                                      final selectedTime = await showTimePicker(
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
                                          startTime =
                                              DateFormat('yyyy-MM-dd HH:mm:ss')
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: TextField(
                          controller: _descriptionController,
                          maxLength: 100,
                          maxLines: null,
                          style: const TextStyle(fontSize: 15.0),
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(
                                minHeight: 48.0, maxHeight: 128.0),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextButton(
                          onPressed: () async {
                            if (startTime == "1970-01-01 00:00:00" ||
                                _orderNameController.text.isEmpty ||
                                _descriptionController.text.isEmpty ||
                                (!_useCurLocation &&
                                    _locationController.text.isEmpty) ||
                                _position_x == null ||
                                _position_y == null ||
                                _position_x == 0.0 ||
                                _position_y == 0.0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("信息未填写完整"),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 109, 109),
                                duration: Duration(milliseconds: 1500),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 109, 109),
                                  duration: const Duration(milliseconds: 1500),
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
                                    borderRadius:
                                        BorderRadius.circular(16.0))), // 设置按钮圆角
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .primary), // 设置按钮背景色
                          ),
                          child: Text(
                            languageProvider.get("newOrder_button"),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
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
