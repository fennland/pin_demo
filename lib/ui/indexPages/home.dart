// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/ui/homePages/search.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const searchPage(),
                      maintainState: true));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          !unSupportedPlatform
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
      floatingActionButton: unSupportedPlatform
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, "/order/new"),
              heroTag: "newOrder",
            )
          : Container(),
    );
  }
}
