import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:pin_demo/src/utils/map.dart';
import '../utils/strings/lang.dart';
import '../utils/components.dart';
import 'package:provider/provider.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  bool _showMore = false;

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
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          child: SizedBox(
            height: 36.0,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                hintText: languageProvider.get("searchInput"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              debugPrint("TODO: Search Result");
              setState(() {
                _showMore = true;
              });
              // TODO: Search Result
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _showMore
              ? !unSupportedPlatform
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
                    )
              : Container(),
          const SizedBox(
            height: 30.0,
          ),
          _showMore ? itemList : Container(),
        ],
      ),
    );
  }
}
