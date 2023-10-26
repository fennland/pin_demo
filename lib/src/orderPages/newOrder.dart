// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/main.dart';
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
  final TextEditingController _textController = TextEditingController();
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
          unSupportedPlatform
              ? mapWidget.generateMap(
                  con: myMapController,
                  width: screenSize.width * 0.95,
                  borderRadius: screenSize.width / 20,
                  zoomLevel: 15,
                  isChinese: (languageProvider.currentLanguage == "zh-CN"))
              : Expanded(
                  flex: 3,
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
          Expanded(
            flex: 2,
            child: Container(
              constraints: const BoxConstraints(minHeight: 180.0),
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
                        child: TextField(
                          controller: _textController,
                          maxLength: 100,
                          maxLines: null,
                          style: const TextStyle(fontSize: 15.0),
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(
                                minHeight: 16.0, maxHeight: 120.0),
                            label: Text(
                              languageProvider.get("newOrder"),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            hintText: languageProvider.get("newOrderInput"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/order/ing");
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
                                Colors.blue), // 设置按钮背景色
                          ),
                          child: Text(
                            languageProvider.get("newOrder"),
                            style: const TextStyle(color: Colors.white),
                          ),
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
    );
  }
}
