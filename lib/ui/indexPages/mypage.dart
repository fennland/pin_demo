// ignore_for_file: unused_import, camel_case_types, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:pin_demo/src/utils/shared/shared_preference_util.dart';
import 'package:pin_demo/ui/mypages/privacy.dart';
import 'package:pin_demo/ui/users/userProfile.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'dart:io';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class myPage extends StatefulWidget {
  // static var body;

  const myPage({super.key});

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  dynamic cache = 0.0;
  var userName = "";
  @override
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
      btnRightBehaviour: () async {
        final Uri url = Uri.parse(Constant.urlMap["app"]!);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      },
      cardContext: ListTile(
        leading: const Icon(Icons.handyman),
        title: Text(languageProvider.get("service2")),
        subtitle: Text(languageProvider.get("service2_sub")),
      ),
    );

    ListTile item_privacy = ListTile(
      leading: const Icon(Icons.privacy_tip),
      title: Text(languageProvider.get("privacy")), // 多语言支持 *experimental
      onTap: () {
        Navigator.pushNamed(context, "/privacy");
      },
    );

    ListTile item_help = ListTile(
      leading: const Icon(Icons.headphones),
      title: Text(languageProvider.get("help")), // 多语言支持 *experimental
      onTap: () {
        Navigator.of(context).pushNamed("/server/test");
      },
    );

    ListTile item_settings = ListTile(
      leading: const Icon(Icons.settings),
      title: Text(languageProvider.get("setting")), // 多语言支持 *experimental
      trailing: !(kIsWeb ||
              Platform.isMacOS ||
              Platform.isWindows ||
              Platform.isLinux)
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
        Navigator.pushNamed(context, "/settings");
      },
    );

    ListTile item_lang = ListTile(
      leading: const Icon(Icons.language),
      title: Text(languageProvider.get("lang")),
      onTap: () {
        setState(() {
          languageProvider.switchLanguage();
          debugPrint(languageProvider.currentLanguage);
        });
      },
    );

    ListTile item_quit = ListTile(
      leading: const Icon(Icons.exit_to_app),
      title: Text(languageProvider.get("quit")),
      onTap: () {
        SharedPreferenceUtil.clear();
        Navigator.of(context).pushReplacementNamed("/login");
        // Navigator.of(context).pushNamed("/login");
        // debugPrint("TODO: quit");
      },
    );

    ListTile item_business = ListTile(
      // TODO: business
      leading: const Icon(Icons.business_center),
      title: Text(languageProvider.get("business")),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("功能尚未开放"),
          duration: Duration(milliseconds: 1500),
        ));
        // Navigator.of(context).pushNamed("/login");
        // debugPrint("TODO: quit");
      },
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
      body: FutureBuilder(
        future: getCurUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return Column(
              children: [
                Card(
                    clipBehavior: Clip.hardEdge,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pushNamed(context, "/my/profile");
                        },
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: user?.avatar ??
                                            Constant
                                                .urlWebMap["defaultAvatar"]!,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorListener: (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("获取头像时出错"),
                                            duration:
                                                Duration(microseconds: 2000),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 109, 109),
                                          ));
                                          debugPrint(
                                              "ERROR in AvatarRequesting: $value");
                                          ErrorHint(
                                              "ERROR in AvatarRequesting: $value");
                                        },
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user?.userName ??
                                      languageProvider.get("curUser"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8.0),
                                    // LinearPercentIndicator(
                                    //   alignment: MainAxisAlignment.start,
                                    //   padding: const EdgeInsets.all(0.0),
                                    //   width: 100.0,
                                    //   lineHeight: 14.0,
                                    //   percent: 0.15,
                                    //   center: Text(
                                    //     languageProvider.get("curUserInfo"),
                                    //     style: const TextStyle(
                                    //         fontSize: 10.0,
                                    //         color: Colors.white),
                                    //   ),
                                    //   barRadius: const Radius.circular(20.0),
                                    //   backgroundColor:
                                    //       Theme.of(context).disabledColor,
                                    //   progressColor: Colors.blueAccent,
                                    // ),
                                    Text(
                                      user?.sign ?? "还没有签名...",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(fontSize: 12.0),
                                    )
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ]))),
                const SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      item_privacy,
                      item_help,
                      item_settings,
                      item_business,
                      item_lang,
                      item_quit,
                      // item_temporaryTest,
                    ],
                  ),
                ),
                service_dcard
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
