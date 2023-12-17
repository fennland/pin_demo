// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class orderingPage extends StatefulWidget {
  final orderModel? order;
  const orderingPage({Key? key, this.order}) : super(key: key);

  @override
  State<orderingPage> createState() => _orderingPageState();
}

class _orderingPageState extends State<orderingPage>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _showSuccess = false;
  bool _showConfirmationCard = false;
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
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showSuccess = true;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel(); // 取消计时器任务
    super.dispose();
  }

  BMFMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var serviceCard = BackdropFilter(
      filter: _showConfirmationCard
          ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: DisappearingCard(
        automaticallyDisappear: true,
        defaultBtns: true,
        cardContext: ListTile(
          leading: const Icon(Icons.question_mark),
          title: Text(languageProvider.get("orderCancel?")),
          subtitle: Text(languageProvider.get("orderCancel?sub")),
        ),
        btnLeftBehaviour: () {
          setState(() {
            _showConfirmationCard = false;
            _startTimer();
          });
        },
        btnRightBehaviour: () {
          setState(() {
            _showConfirmationCard = false;
          });
          Navigator.pop(context, "/order/new"); // TODO: 解决卡出new group
        },
      ),
    );

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
          (!_showSuccess && !_showConfirmationCard)
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
              icon: const Icon(Icons.edit),
              onPressed: () => debugPrint("TODO: ordering edit")),
          IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                setState(() {
                  _timer.cancel();
                  _showConfirmationCard = true;
                });
              }),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => shareContent(""),
          ),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: !unSupportedPlatform
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
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      child: Icon(Icons.check_circle,
                          color: Colors.greenAccent, size: 64.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      child: Text(
                        languageProvider.get("orderMatched"),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(languageProvider.get("ok")),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                          "/msg/conversations",
                        ); // TODO: new page after success matching, add listitem into msgList
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        (_showConfirmationCard) ? serviceCard : Container()
      ]),
    );
  }
}
