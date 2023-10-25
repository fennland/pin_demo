// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/src/map/map.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';
import 'package:pin_demo/main.dart' show isAndroidSimulator;

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  void initState() {
    super.initState();
  }

  BMFMapController? myMapController;
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var mapWidget = MapWidget(
      onTap: () => Navigator.pushNamed(context, "/order/new"),
    );
    itemListWidget itemList = const itemListWidget(type: "order", itemCount: 5);
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.get("home"),
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        automaticallyImplyLeading: false, // 登录后，不自动生成返回
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              debugPrint("TODO: Search");
              final snackbar = SnackBar(
                content: const Text("TODO: Search"),
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
          !(kIsWeb ||
                  Platform.isMacOS ||
                  Platform.isWindows ||
                  Platform.isLinux ||
                  isAndroidSimulator ||
                  Platform.isIOS)
              ? mapWidget.generateMap(
                  con: myMapController,
                  width: screenSize.width * 0.95,
                  zoomLevel: 15,
                  isChinese: (languageProvider.currentLanguage == "zh-CN"),
                  zoomEnabled: false)
              : Column(
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
          const SizedBox(
            height: 30.0,
          ),
          itemList,
        ],
      ),
    );
  }
}
