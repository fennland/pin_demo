// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../utils.dart';

class myPage extends StatefulWidget {
  static var body;

  const myPage({super.key});

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  dynamic cache = 0.0;
  void initState() {
    if (!kIsWeb) getSize();
    super.initState();
  }

  getSize() async {
    final _tempDir = await getTemporaryDirectory();
    dynamic _cache = await getTotalSizeOfFilesInDir(_tempDir);
    setState(() {
      cache = _cache;
    });
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    // serviceDisappearingCard
    var service_dcard = DisappearingCard(
      cardContext: ListTile(
        leading: const Icon(Icons.handyman),
        title: Text(languageProvider.get("service2")),
        subtitle: Text(languageProvider.get("service2_sub")),
      ),
    );

    // Scaffold
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          languageProvider.get("my"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      body: Column(
        children: [
          Card(
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('TODO: Edit myProfile');
                  },
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          radius: 50.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "https://picsum.photos/250?image=9",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorListener: (value) {
                                debugPrint(
                                    "ERROR in myPage's CachedNetworkImage!");
                                ErrorHint(
                                    "ERROR in myPage's CachedNetworkImage!");
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      title: Text(languageProvider.get("curUser")),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 8.0),
                          LinearPercentIndicator(
                            alignment: MainAxisAlignment.start,
                            padding: const EdgeInsets.all(0.0),
                            width: 100.0,
                            lineHeight: 14.0,
                            percent: 0.15,
                            center: Text(
                              languageProvider.get("curUserInfo"),
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                            ),
                            barRadius: const Radius.circular(20.0),
                            backgroundColor: Theme.of(context).disabledColor,
                            progressColor: Colors.blueAccent,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          const snackBar = SnackBar(content: Text('yuh'));
                          // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ),
                  ]))),
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(
                      languageProvider.get("privacy")), // 多语言支持 *experimental
                  onTap: () {
                    debugPrint("yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.headphones),
                  title:
                      Text(languageProvider.get("help")), // 多语言支持 *experimental
                  onTap: () {
                    debugPrint("yuh yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                      languageProvider.get("setting")), // 多语言支持 *experimental
                  trailing: !(kIsWeb || Platform.isMacOS)
                      ? TextButton(
                          child: Text(renderSize(cache)),
                          onPressed: () async {
                            Fluttertoast.showToast(
                                msg: languageProvider.get("removingCache"));
                            try {
                              DefaultCacheManager mgr = DefaultCacheManager();
                              // mgr.emptyCache(); //clears all data in cache.
                              final _tempDir = await getTemporaryDirectory();
                              await requestPermission(_tempDir);
                              getSize();
                            } catch (err) {
                              Fluttertoast.showToast(
                                  msg: languageProvider.get("remFailed"));
                            }
                          },
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () {
                    debugPrint("TODO: Setting"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title:
                      Text(languageProvider.get("lang")), // 多语言支持 *experimental
                  onTap: () {
                    setState(() {
                      languageProvider.switchLanguage();
                      debugPrint(languageProvider.currentLanguage);
                    });
                  },
                ),
              ],
            ),
          ),
          service_dcard
        ],
      ),
    );
  }
}
