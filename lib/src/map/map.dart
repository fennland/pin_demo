// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
// import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:pin_demo/src/strings/lang.dart';
// import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';

BMFMapController? myMapController;

// class BaiduMapLocation {
//   final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();

//   void onBMFLocationCallback() {
//     if (Platform.isIOS) {
//       //接受定位回调
//       _myLocPlugin.singleLocationCallback(callback: (BaiduLocation result) {
//         //result为定位结果
//       });
//     } else if (Platform.isAndroid) {
//       //接受定位回调
//       _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
//         //result为定位结果
//       });
//     }
//   }

//   BaiduLocationAndroidOption initAndroidOptions() {
//     BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
// // 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
//         locationMode: BMFLocationMode.hightAccuracy,
// // 是否需要返回地址信息
//         isNeedAddress: true,
// // 是否需要返回海拔高度信息
//         isNeedAltitude: true,
// // 是否需要返回周边poi信息
//         isNeedLocationPoiList: true,
// // 是否需要返回新版本rgc信息
//         isNeedNewVersionRgc: true,
// // 是否需要返回位置描述信息
//         isNeedLocationDescribe: true,
// // 是否使用gps
//         openGps: true,
// // 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
//         locationPurpose: BMFLocationPurpose.sport,
// // 坐标系
//         coordType: BMFLocationCoordType.bd09ll,
// // 设置发起定位请求的间隔，int类型，单位ms
// // 如果设置为0，则代表单次定位，即仅定位一次，默认为0
//         scanspan: 0);
//     return options;
//   }

//   BaiduLocationIOSOption initIOSOptions() {
//     BaiduLocationIOSOption options = BaiduLocationIOSOption(
//       // 坐标系
//       coordType: BMFLocationCoordType.bd09ll,
//       // 位置获取超时时间
//       locationTimeout: 10,
//       // 获取地址信息超时时间
//       reGeocodeTimeout: 10,
//       // 应用位置类型 默认为automotiveNavigation
//       activityType: BMFActivityType.automotiveNavigation,
//       // 设置预期精度参数 默认为best
//       desiredAccuracy: BMFDesiredAccuracy.best,
//       // 是否需要最新版本rgc数据
//       isNeedNewVersionRgc: true,
//       // 指定定位是否会被系统自动暂停
//       pausesLocationUpdatesAutomatically: false,
//       // 指定是否允许后台定位,
//       // 允许的话是可以进行后台定位的，但需要项目配置允许后台定位，否则会报错，具体参考开发文档
//       allowsBackgroundLocationUpdates: true,
//       // 设定定位的最小更新距离
//       distanceFilter: 10,
//     );
//     return options;
//   }

// Future<void> getLocation() async {
//   if (Platform.isIOS) {
//     _suc = await _myLocPlugin
//         .singleLocation({'isReGeocode': true, 'isNetworkState': true});
//   } else if (Platform.isAndroid) {
//     _suc = await _myLocPlugin.startLocation();
//   }
//   Map iosMap = initIOSOptions().getMap();
//   Map androidMap = initAndroidOptions().getMap();

//   _suc = await _myLocPlugin.prepareLoc(androidMap, iosMap);
// }
// }

class MapWidget {
  final void Function() onTap;

  static const double _defaultWidth = 350.0;
  static const double _defaultHeight = 200.0;
  static const double _defaultLat = 24.612261;
  static const double _defaultLon = 118.088745;

  final double? width;
  final double? height;
  final double? lat;
  final double? lon;
  final bool? isWeb;
  MapWidget(
      {required this.onTap,
      this.width = _defaultWidth,
      @deprecated this.height = _defaultHeight,
      this.lat = _defaultLat,
      this.lon = _defaultLon,
      this.isWeb = false});
  Expanded generateMap(
      // TODO: onTap
      {BMFMapController? con,
      double? width = _defaultWidth,
      @deprecated double? height = _defaultHeight,
      double borderRadius = 15.0,
      double lat = _defaultLat,
      double lon = _defaultLon,
      int zoomLevel = 12,
      bool isChinese = true,
      bool zoomEnabled = true}) {
    myMapController = con;
    return Expanded(
      flex: 2,
      child: Center(
        child: SizedBox(
          // height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            child: InkWell(
              onTap: onTap,
              child: BMFMapWidget(
                onBMFMapCreated: onBMFMapCreated,
                hitTestBehavior: (zoomEnabled)
                    ? PlatformViewHitTestBehavior.opaque
                    : PlatformViewHitTestBehavior.transparent,
                mapOptions:
                    initMapOptions(lat, lon, zoomLevel, isChinese, zoomEnabled),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BMFMapOptions initMapOptions(
      double lat, double lon, int zoomLevel, bool isChinese, bool zoomEnabled) {
    BMFMapOptions mapOptions = BMFMapOptions(
      center: BMFCoordinate(lat, lon),
      zoomLevel: zoomLevel,
      // TODO: backgroundColor 地图暗黑模式适配
      languageType:
          (isChinese) ? BMFMapLanguageType.Chinese : BMFMapLanguageType.English,
      zoomEnabled: zoomEnabled,
      gesturesEnabled: zoomEnabled,
    );
    debugPrint(zoomEnabled.toString());
    return mapOptions;
  }

  void onBMFMapCreated(BMFMapController controller) async {
    //myMapController = controller;

    // Map? map1 = await myMapController.getNativeMapCopyright();
    // print('获取原生地图版权信息：$map1');
    // Map? map2 = await myMapController.getNativeMapApprovalNumber();
    // print('获取原生地图审图号：$map2');
    // Map? map3 = await myMapController.getNativeMapQualification();
    // print('获取原生地图测绘资质：$map3');

    /// 地图加载回调
    controller.setMapDidLoadCallback(callback: () {
      debugPrint('mapDidLoad-地图加载完成');
    });
  }
}
