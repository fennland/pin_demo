// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/src/map/map.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';

class newOrderPage extends StatefulWidget {
  const newOrderPage({super.key});

  @override
  State<newOrderPage> createState() => _newOrderPageState();
}

class _newOrderPageState extends State<newOrderPage> {
  BMFMapController? myMapController;
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var mapWidget = MapWidget(
      onTap: () {
        debugPrint("TODO: newOrder map onTap");
      },
    );
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          // title: Text(languageProvider.get("newOrder"),
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
      body: Column(
        children: [
          mapWidget.generateMap(
              con: myMapController,
              width: screenSize.width * 0.95,
              borderRadius: screenSize.width / 20,
              zoomLevel: 15,
              isChinese: (languageProvider.currentLanguage == "zh-CN")),
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            flex: 1,
            child: Card(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.03),
                  child: Row(
                    children: [
                      Text(
                        languageProvider.get("newOrder"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0),
                      )
                    ],
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
