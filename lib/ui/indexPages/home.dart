// import 'dart:html';

// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/ui/homePages/search.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/ui/msgPages/conversations.dart';
import 'package:pin_demo/ui/orderPages/orderinfo.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import '../../src/utils/constants/constant.dart';

class homePage extends StatefulWidget {
  // final orderModel? ordering;
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<orderModel> orders = [];
  final LocationService _locationService = LocationService();
  double _currentPosition_x = 118.085152;
  double _currentPosition_y = 24.603804;
  int delaySecs = 0;
  late Future<List<orderModel>> _orders;
  List<BMFMarker>? _markers;
  double distance = 2.0;
  bool isMatched = false;
  bool badNetwork = false;

  BMFMapController? myMapController = BMFMapController.withId(1);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _orders = _getOrders();
    // _addMarkers(); // TODO： 百度地图SDK无法添加markers
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      _currentPosition_x = position.longitude;
      _currentPosition_y = position.latitude;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @Deprecated("bMapSDK error")
  Future<bool> _addMarkers() async {
    try {
      if (orders != null) {
        List<BMFMarker> markers = [];
        for (var order in orders) {
          /// 创建BMFMarker
          ///
          // print(order.position_x);
          // print(order.position_y);
          BMFMarker marker = BMFMarker.icon(
              position: BMFCoordinate(order.position_y, order.position_x),
              title: order.orderName,
              identifier: order.orderID.toString(),
              icon: "static/images/icon_marker_unselected.png");
          markers.add(marker);

          /// 添加Marker
        }
        bool? result = await myMapController?.addMarkers(markers);
        return result ?? true;
      } else {
        debugPrint("add markers false");
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<List<orderModel>> _getOrders() async {
    try {
      // print(responseOrders);
      _getCurrentLocation();
      delaySecs = 500;
      List<orderModel> responseOrders = await orderApi.getSurroundingOrder(
          distance, _currentPosition_x, _currentPosition_y);
      if (mounted) {
        setState(() {
          orders = responseOrders;
        });
        return responseOrders;
      }
      debugPrint("notMounted");
      return [];
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        badNetwork = true;
      });
      return [];
    }
  }

  // Future<bool> _isOrderMatched() async {
  //   try {
  //     orderModel responseOrder =
  //         await orderApi.getOrderInfo(widget.ordering?.orderID);
  //     if (mounted) {
  //       isMatched = (responseOrder.statusCode == 200);
  //       return (responseOrder.statusCode == 200);
  //     }
  //     debugPrint("notMounted");
  //     isMatched = false;
  //     return false;
  //   } catch (error) {
  //     debugPrint(error.toString());
  //     setState(() {
  //       badNetwork = true;
  //     });
  //     isMatched = false;
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.get("home"),
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        automaticallyImplyLeading: false, // 登录后，不自动生成返回
        actions: [
          !badNetwork
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const searchPage(),
                    //         maintainState: true));
                  },
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          badNetwork
              ? Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, size: 36.0),
                      const SizedBox(height: 30),
                      Text(languageProvider.get("loginBadNetwork"),
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      OutlinedButton(
                          onPressed: () async {
                            final ScaffoldMessengerState scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              scaffoldMessenger.showSnackBar(SnackBar(
                                content: const Text("网络未连接"),
                                action: SnackBarAction(
                                  label: "网络检测",
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/server/test"),
                                ),
                              ));
                            } else if (await checkConnectivity() == false) {
                              scaffoldMessenger.showSnackBar(SnackBar(
                                content: Text(
                                    languageProvider.get("loginBadNetwork")),
                                action: SnackBarAction(
                                  label: "网络检测",
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/server/test"),
                                ),
                              ));
                            } else {
                              setState(() {
                                badNetwork = false;
                              });
                              await _getOrders();
                            }
                          },
                          child: const Text("重试"))
                    ],
                  ),
                )
              : Container(),
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              if (distance < 30.0) {
                distance += 1;
                debugPrint("Now distance: ${distance.toString()}");
              }
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Loading..."),
                duration: Duration(seconds: 2),
              ));
              if (badNetwork) {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  throw Exception("no network");
                } else {
                  setState(() {
                    badNetwork = false;
                  });
                }
              } else {
                await _getOrders();
                await _getCurrentLocation();
              }
            },
            child: !badNetwork
                ? FutureBuilder<List<orderModel>>(
                    future: _orders, // 调用 _getOrders() 获取订单数据
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text("Loading...")
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.more_horiz, size: 36.0),
                                const SizedBox(height: 30),
                                Text(languageProvider.get("noOrders"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: Column(
                            children: [
                              !unSupportedPlatform
                                  ? generateMap(
                                      onTap: () => Navigator.pushNamed(
                                          context, "/order/new"),
                                      flex: 2,
                                      // locationSelection: () => Container(),
                                      con: myMapController,
                                      lat: _currentPosition_y,
                                      lon: _currentPosition_x,
                                      width: screenSize.width * 0.95,
                                      zoomLevel: 15,
                                      isChinese:
                                          (languageProvider.currentLanguage ==
                                              "zh"),
                                      zoomEnabled: false)
                                  : Container(),
                              // : Column(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.center,
                              //     children: [
                              //       const Icon(Icons.error),
                              //       const SizedBox(
                              //         height: 10.0,
                              //       ),
                              //       Text(
                              //         languageProvider.get(
                              //             "unsupportedPlatformConfirm"),
                              //         textAlign: TextAlign.center,
                              //       )
                              //     ],
                              //   ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(languageProvider.get("nearby_orders"),
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w900)),
                                    unSupportedPlatform
                                        ? IconButton(
                                            icon: const Icon(Icons.refresh),
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text("Loading..."),
                                                duration: Duration(seconds: 2),
                                              ));
                                              await _getOrders();
                                              await _getCurrentLocation();
                                              setState(() {
                                                if (distance < 30.0) {
                                                  distance += 1;
                                                  debugPrint(
                                                      "Now distance: ${distance.toString()}");
                                                }
                                              });
                                            },
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: ListView.separated(
                                  itemCount: orders.length,
                                  itemBuilder: (context, int index) {
                                    return ListTile(
                                      onTap: () {
                                        // debugPrint(orders[index].toString());
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    orderInfoPage(
                                                        order: orders[index])));
                                      },
                                      leading: generateAvatar(
                                          orders[index].orderName ?? "N/A",
                                          context),
                                      title: Text(
                                        orders[index].orderName ?? "N/A",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          orders[index].description != null
                                              ? Text(
                                                  orders[index].description!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Container(),
                                          Text(
                                            orders[index].startTime,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      trailing: Text(orders[index].distance ==
                                              null
                                          ? ""
                                          : '${orders[index].distance!} km'),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 0.0,
                                      color: Theme.of(context).dividerColor,
                                      thickness: 0.5,
                                      indent: 20.0,
                                      endIndent: 20.0,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    })
                : const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: !badNetwork
          // ? widget.ordering == null
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, "/order/new"),
              heroTag: "newOrder",
              child: const Icon(Icons.add),
            )
          // : FloatingActionButton(
          //     onPressed: () {
          //       if (isMatched) {
          //         Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => ConversationsPage(
          //                 groupID: widget.ordering?.groupID,
          //                 groupName: widget.ordering?.orderName)));
          //       }
          //     },
          //     heroTag: "ordering",
          //     child: FutureBuilder(
          //       future: _isOrderMatched(),
          //       builder: (BuildContext context, snapshot) {
          //         if (snapshot.hasData && snapshot.data == true) {
          //           return Center(
          //               child: Column(
          //             children: [
          //               const Icon(Icons.check_circle,
          //                   color: Colors.greenAccent),
          //               Text(languageProvider.get("orderMatched"),
          //                   style: Theme.of(context).textTheme.labelSmall)
          //             ],
          //           ));
          //         } else {
          //           return Center(
          //               child: Column(
          //             children: [
          //               const SizedBox(
          //                   width: 24.0,
          //                   height: 24.0,
          //                   child: CircularProgressIndicator()),
          //               Text(languageProvider.get("ordering"),
          //                   style: Theme.of(context).textTheme.labelSmall)
          //             ],
          //           ));
          //         }
          //       },
          //     ),
          //   )
          : Container(),
    );
  }
}
