import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownTimer extends StatefulWidget {
  final String targetDateTime;
  final TextStyle? style;

  CountdownTimer({required this.targetDateTime, this.style});

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
    _timer.cancel();
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
        style: widget.style,
      );
    }

    int days = _duration.inDays;
    int hours = _duration.inHours % 24;
    int minutes = _duration.inMinutes % 60;
    int seconds = _duration.inSeconds % 60;

    return Text(
      '$days天 $hours时 $minutes分 $seconds秒',
      style: const TextStyle(fontSize: 24),
    );
  }
}

class orderInfoPage extends StatefulWidget {
  final orderModel? order; // 传入的订单模型

  const orderInfoPage({Key? key, this.order}) : super(key: key);

  @override
  State<orderInfoPage> createState() => _orderInfoPageState();
}

class _orderInfoPageState extends State<orderInfoPage> {
  @override
  void initState() {
    super.initState();
    if (widget.order == null) {
      debugPrint("empty order");
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var mapWidget = MapWidget(
      onTap: () {},
    );
    var screenSize = MediaQuery.of(context).size;

    Future<Map<String, dynamic>> reqInitiator() async {
      var initiatorUserInfo = await requestUserInfo(widget.order!.initiator);
      return initiatorUserInfo;
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(children: [
            Text(widget.order!.orderName ?? "",
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w600)),
            Text("${widget.order!.distance.toString()} km",
                style: Theme.of(context).textTheme.labelSmall)
          ]),
          actions: [
            IconButton(
                onPressed: () => shareContent(""),
                icon: const Icon(Icons.share))
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                      child: !unSupportedPlatform
                          ? mapWidget.generateMap(
                              con: myMapController,
                              width: screenSize.width * 0.95,
                              zoomLevel: 15,
                              isChinese:
                                  (languageProvider.currentLanguage == "zh-CN"),
                              zoomEnabled: false)
                          : Column(
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
                            )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.alarm),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CountdownTimer(
                                    targetDateTime: widget.order!.startTime,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(widget.order!.startTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Column(children: []),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.person),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      languageProvider
                                          .get("orderInfoInitiator"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  FutureBuilder(
                                      future: reqInitiator(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map<String, dynamic>?
                                              initiatorUserInfo = snapshot.data;
                                          return Text(
                                              initiatorUserInfo!["userName"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge);
                                        } else {
                                          return const Text("");
                                        }
                                      })
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Column(children: []),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
