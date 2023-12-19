// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:pin_demo/ui/msgPages/conversations.dart';
import 'package:provider/provider.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class CountdownTimer extends StatefulWidget {
  final String targetDateTime;
  final TextStyle? style;

  CountdownTimer({super.key, required this.targetDateTime, this.style});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late DateTime _targetDateTime;
  late Timer _timer;
  late Duration _duration;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _targetDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.targetDateTime);
    _duration = _targetDateTime.difference(DateTime.now());
    if (_duration.isNegative) {
      _isExpired = true;
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (!_isExpired) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _targetDateTime.difference(DateTime.now());
        if (_duration.isNegative) {
          _isExpired = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpired) {
      return Text(
        '已结束',
        overflow: TextOverflow.ellipsis,
        style: widget.style,
      );
    }

    int days = _duration.inDays;
    int hours = _duration.inHours % 24;
    int minutes = _duration.inMinutes % 60;
    int seconds = _duration.inSeconds % 60;

    return Text(
      '$days天 $hours时 $minutes分 $seconds秒',
      overflow: TextOverflow.ellipsis,
      style: widget.style,
    );
  }
}

class orderInfoPage extends StatefulWidget {
  final orderModel? order; // 传入的订单模型

  const orderInfoPage({super.key, this.order});

  @override
  State<orderInfoPage> createState() => _orderInfoPageState();
}

class _orderInfoPageState extends State<orderInfoPage> {
  final LocationService _locationService = LocationService();
  orderModel? orderM;
  // late double _currentPosition_x;
  // late double _currentPosition_y;
  BMFMapController? myMapController = BMFMapController.withId(3);

  Future<Position> _getCurrentLocation() async {
    final Position position = await _locationService.getCurrentLocation();
    // _currentPosition_x = position.longitude;
    // _currentPosition_y = position.latitude;
    return position;
  }

  Future<int> _joinOrder() async {
    try {
      var user = await getCurUserInfo();
      if (user != null) {
        var result =
            await orderApi.joinOrder(user.userID, widget.order?.orderID);
        if (result["code"] == 200 || result["code"] == 201) {
          orderM = result["data"];
        }
        return result["code"] ?? 500;
      } else {
        throw ErrorHint("Not Loged in");
      }
    } catch (e) {
      debugPrint(e.toString());
      return 400;
    }
  }

  Future<bool> _isJoined() async {
    try {
      var user = await getCurUserInfo();
      if (user != null) {
        // debugPrint("userID: ${user.userID}, 137");
        var orders = await orderApi.getUserOrders(user.userID);
        // debugPrint("orders: " + orders.toString());
        for (var o in orders) {
          // debugPrint("o.orderID: ${o.orderID}");
          // debugPrint("widget.orderID: ${widget.order?.orderID}");
          if (o.orderID == widget.order?.orderID) {
            // debugPrint("isJoined: true, 140");
            return true;
          }
        }
        // debugPrint("isJoined: false, 144");
        return false;
      } else {
        throw ErrorHint("Not Loged in");
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    if (widget.order == null) {
      debugPrint("empty order");
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    Map<String, dynamic>? initiatorUserInfo = {};

    Future<List<dynamic>> reqParticipants() async {
      var participants =
          await orderApi.requestOrderParticipants(widget.order!.orderID);
      return participants;
    }

    Future<Map<String, dynamic>> reqInitiator() async {
      var initiatorUserInfo = await requestUserInfo(widget.order!.initiator);
      return initiatorUserInfo;
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(children: [
            Text(widget.order!.orderName,
                style: widget.order!.distance != null
                    ? const TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.w600)
                    : null),
            widget.order!.distance != null
                ? Text("${(widget.order!.distance).toString()} km",
                    style: Theme.of(context).textTheme.labelSmall)
                : Container()
          ]),
          actions: [
            IconButton(
                onPressed: () => shareContent(""),
                icon: const Icon(Icons.share))
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !unSupportedPlatform
                  ? FutureBuilder<Position>(
                      future: _getCurrentLocation(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState !=
                                ConnectionState.waiting &&
                            snapshot.hasData) {
                          // 获取位置信息成功，将其传递给地图组件
                          final position = snapshot.data!;
                          return (generateMap(
                              onTap: () {},
                              flex: 3,
                              // locationSelection: () => Container(),
                              con: myMapController,
                              width: screenSize.width * 0.95,
                              zoomLevel: 17,
                              isChinese:
                                  (languageProvider.currentLanguage == "zh"),
                              zoomEnabled: false,
                              lat: (widget.order?.position_y != null)
                                  ? widget.order!.position_y
                                  : position.latitude,
                              lon: (widget.order?.position_x != null)
                                  ? widget.order!.position_x
                                  : position.longitude));
                        } else {
                          return const Expanded(
                            flex: 3,
                            child: Card(
                              child: Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text("Loading...")
                                    ]),
                              ),
                            ),
                          );
                        }
                      })
                  : Expanded(
                      flex: 3,
                      child: Center(
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
                      ),
                    ),
              Expanded(
                flex: 6,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 24.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8.0, 8.0, 16.0, 8.0),
                                    child: Icon(Icons.alarm),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CountdownTimer(
                                        targetDateTime: widget.order!.startTime,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: screenSize.width * 0.5),
                                        child: Text(widget.order!.startTime,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8.0, 8.0, 16.0, 8.0),
                                    child: Icon(Icons.person),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          languageProvider
                                              .get("orderInfoInitiator"),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold)),
                                      FutureBuilder(
                                          future: reqInitiator(),
                                          builder:
                                              (BuildContext context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != {}) {
                                              initiatorUserInfo = snapshot.data;
                                              return Text(
                                                  initiatorUserInfo![
                                                          "userName"] +
                                                      " (ID: ${initiatorUserInfo!["userID"]}) ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge);
                                            } else {
                                              return const Text("");
                                            }
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8.0, 8.0, 16.0, 8.0),
                                    child: Icon(Icons.people),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          languageProvider
                                              .get("orderInfoParticipants"),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 150.0),
                                        child: FutureBuilder(
                                            future: reqParticipants(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.isNotEmpty) {
                                                return Text(
                                                    (initiatorUserInfo![
                                                                    "userName"] ==
                                                                null ||
                                                            snapshot
                                                                .data!.isEmpty)
                                                        ? "未获取到信息"
                                                        : (snapshot.data!
                                                                .isNotEmpty)
                                                            ? "${initiatorUserInfo!["userName"]}"
                                                            : "${initiatorUserInfo!["userName"]}...等 ${snapshot.data!.length} 人",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge);
                                              } else {
                                                return Text("未获取到信息",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge);
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8.0, 8.0, 16.0, 8.0),
                                    child: Icon(Icons.edit),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                            languageProvider
                                                .get("newOrder_description"),
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: screenSize.width * 0.8),
                                        child: Text(
                                            widget.order!.description ??
                                                "还没有描述呢...",
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: _isJoined(),
                builder: (context, snapshot) {
                  var _targetDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                      .parse(widget.order!.startTime);
                  var _duration = _targetDateTime.difference(DateTime.now());
                  if (_duration.isNegative) {
                    return Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("该需求已经结束了...")));
                            },
                            style: ButtonStyle(
                                maximumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 60)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(
                                        double.infinity, 45)), // 设置按钮最小尺寸
                                // padding: MaterialStateProperty.all(
                                //     EdgeInsets.zero), // 去除默认内边距
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16.0))), // 设置按钮圆角
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.secondary)),
                            child: Text(
                              "需求已结束",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            )));
                  }

                  if (snapshot.hasData) {
                    if (!snapshot.data!) {
                      return Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () async {
                              var result = await _joinOrder();
                              if (result == 200 || result == 201) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("加入成功！"),
                                ));
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => ConversationsPage(
                                            groupName: orderM!.orderName,
                                            groupID: orderM!.groupID)));
                              } else if (result == 404) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("在去这个需求群的路中迷路了..."),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 109, 109),
                                ));
                              } else if (result == 409) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("你已经在此群聊了..."),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 109, 109),
                                ));
                                if (widget.order != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConversationsPage(
                                          groupName: widget.order!.orderName,
                                          groupID: widget.order!.groupID)));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("未能加入此需求，换一个试试吧..."),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 109, 109),
                                ));
                              }
                            },
                            style: ButtonStyle(
                                maximumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 60)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(
                                        double.infinity, 45)), // 设置按钮最小尺寸
                                // padding: MaterialStateProperty.all(
                                //     EdgeInsets.zero), // 去除默认内边距
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16.0))), // 设置按钮圆角
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary)),
                            child: Text("加入此需求",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ));
                    } else {
                      return Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              maximumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 60)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 45)), // 设置按钮最小尺寸
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          16.0))), // 设置按钮圆角
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary)),
                          onPressed: () => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("已在此需求啦！"),
                            duration: Duration(seconds: 2),
                          )),
                          child: Text(
                            "已在此需求中",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ));
  }
}
