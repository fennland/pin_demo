// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/map/map.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  BMFMapController? myMapController;
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    itemListWidget itemList = itemListWidget(type: "order", itemCount: 5);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.get("home"),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              debugPrint("TODO: Search");
              final snackbar = SnackBar(
                content: Text("TODO: Search"),
                action: SnackBarAction(
                  label: "OK",
                  onPressed: () => debugPrint("OK"),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          generateMap(myMapController, 200, 350, 24.612261, 118.088745,
              zoomLevel: 15,
              isChinese: (languageProvider.currentLanguage == "zh-CN"),
              zoomEnabled: false),
          SizedBox(
            height: 30.0,
          ),
          itemList,
        ],
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  BMFMapController? myMapController;
  @override
  void initState() {
    super.initState();
  }

//   BMFMapOptions mapOptions = BMFMapOptions(
//     center: BMFCoordinate(39.917215, 116.380341),
//     mapType: BMFMapType.Standard,
//     zoomLevel: 12,
//     changeCenterWithDoubleTouchPointEnabled: true,
//     gesturesEnabled: true,
//     scrollEnabled: true,
//     zoomEnabled: true,
//     rotateEnabled: true,
//     compassPosition: BMFPoint(0, 0),
//     showMapScaleBar: false,
//     maxZoomLevel: 15,
//     minZoomLevel: 8,
// //      mapType: BMFMapType.Satellite
//   );

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: initMapOptions(),
      ),
    ));
  }

  @override
  BMFMapOptions initMapOptions() {
    BMFCoordinate center = BMFCoordinate(39.965, 116.404);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 12,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        logoPosition: BMFLogoPosition.LeftBottom,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        overlookEnabled: true,
        overlooking: -15,
        center: center);
    return mapOptions;
  }

  @override
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
    myMapController?.setMapOnDrawMapFrameCallback(
        callback: (BMFMapStatus mapStatus) {
//       print('地图渲染每一帧\n mapStatus = ${mapStatus.toMap()}');
    });

    /// 地图区域即将改变时会调用此接口
    /// mapStatus 地图状态信息
    myMapController?.setMapRegionWillChangeCallback(
        callback: (BMFMapStatus mapStatus) {
      print('地图区域即将改变时会调用此接口1\n mapStatus = ${mapStatus.toMap()}');
    });

    /// 地图区域改变完成后会调用此接口
    /// mapStatus 地图状态信息
    myMapController?.setMapRegionDidChangeCallback(
        callback: (BMFMapStatus mapStatus) {
      print('地图区域改变完成后会调用此接口2\n mapStatus = ${mapStatus.toMap()}');
    });

    /// 地图区域即将改变时会调用此接口
    /// mapStatus 地图状态信息
    /// reason 地图改变原因
    myMapController?.setMapRegionWillChangeWithReasonCallback(callback:
        (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
      print(
          '地图区域即将改变时会调用此接口3\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
    });

    /// 地图区域改变完成后会调用此接口
    /// mapStatus 地图状态信息
    /// reason 地图改变原因
    myMapController?.setMapRegionDidChangeWithReasonCallback(callback:
        (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
      print(
          '地图区域改变完成后会调用此接口4\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
    });
  }

  // void onBMFMapCreated(BMFMapController controller) {
  //   dituController = controller;

  //   /// 地图加载回调
  //   dituController?.setMapDidLoadCallback(callback: () {
  //     final snackBar = SnackBar(content: Text('map created'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }
}
