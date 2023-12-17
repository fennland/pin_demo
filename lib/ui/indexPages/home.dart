// import 'dart:html';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/ui/homePages/search.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/ui/orderPages/orderinfo.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import '../../src/utils/constants/constant.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<orderModel> orders = [];
  final LocationService _locationService = LocationService();
  double _currentPosition_x = 0.0;
  double _currentPosition_y = 0.0;
  final double distance = 1.0;
  bool badNetwork = false;

  BMFMapController? myMapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      // setState(() {
      _currentPosition_x = position.longitude;
      _currentPosition_y = position.latitude;
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<orderModel>> _getOrders() async {
    try {
      // print(responseOrders);
      _getCurrentLocation();
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

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var mapWidget = MapWidget(
      onTap: () => Navigator.pushNamed(context, "/order/new"),
    );

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const searchPage(),
                            maintainState: true));
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
                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text("网络未连接"),
                                action: SnackBarAction(
                                  label: "网络检测",
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/server/test"),
                                ),
                              ));
                            } else if (await checkConnectivity() == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
            onRefresh: () async {
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
              }
            },
            child: !badNetwork
                ? FutureBuilder<List<orderModel>>(
                    future: Future.delayed(const Duration(milliseconds: 500),
                        _getOrders), // 调用 _getOrders() 获取订单数据
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              !unSupportedPlatform
                                  ? mapWidget.generateMap(
                                      con: myMapController,
                                      width: screenSize.width * 0.95,
                                      zoomLevel: 15,
                                      isChinese:
                                          (languageProvider.currentLanguage ==
                                              "zh-CN"),
                                      zoomEnabled: false)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          languageProvider.get(
                                              "unsupportedPlatformConfirm"),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: orders.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                          orders[index].orderName ?? "N/A"),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          orders[index].description != null
                                              ? Text(orders[index].description!)
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
                : SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: !badNetwork
          ? unSupportedPlatform
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => Navigator.pushNamed(context, "/order/new"),
                  heroTag: "newOrder",
                )
              : Container()
          : Container(),
    );
  }
}
