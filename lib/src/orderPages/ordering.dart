// ignore_for_file: unused_import

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/utils/map.dart';
import '../utils/strings/lang.dart';
import '../utils/components.dart';
import 'package:provider/provider.dart';

class orderingPage extends StatefulWidget {
  const orderingPage({super.key});

  @override
  State<orderingPage> createState() => _orderingPageState();
}

class _orderingPageState extends State<orderingPage>
    with SingleTickerProviderStateMixin {
  bool _showSuccess = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Animation Speed
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _startTimer(); // TODO: 模拟，真实流程跑通
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showSuccess = true;
      });
      _animationController.forward();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushNamed("/msg/conversations",
            arguments:
                "New Group"); // TODO: new page after success matching, add listitem into msgList
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

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
    itemListWidget itemList = const itemListWidget(type: "order", itemCount: 5);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          !_showSuccess
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Container(
                      width: 24.0,
                      height: 24.0,
                      child: const CircularProgressIndicator()),
                )
              : Container(),
          Text(languageProvider.get("ordering")),
        ]),
        titleSpacing: 0.0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => debugPrint("TODO: ordering search"),
          ),
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => debugPrint("TODO: ordering edit")),
          IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => debugPrint("TODO: ordering cancel")),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: unSupportedPlatform
                  ? mapWidget.generateMap(
                      con: myMapController,
                      width: screenSize.width * 0.95,
                      borderRadius: screenSize.width / 20,
                      zoomLevel: 15,
                      isChinese: (languageProvider.currentLanguage == "zh-CN"))
                  : SizedBox(
                      // TODO: ordering card context
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
            ),
            itemList,
          ],
        ),
        AnimatedOpacity(
          opacity: _showSuccess ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
                      child:
                          Icon(Icons.check_circle, color: Colors.greenAccent),
                    ),
                    Text(
                      languageProvider.get("orderMatched"),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
