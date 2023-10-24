import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/mainPages/mypages/privacy.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';

class myPage extends StatefulWidget {
  static var body;

  const myPage({super.key});

  @override
  State<myPage> createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("my"))),
      body: Column(
        children: [
          Card(
              clipBehavior: Clip.hardEdge,
              // shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.all(Radius.circular(20))),
              child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushNamed(context, "/person_data");
                    debugPrint('Card tapped.');
                  },
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    const ListTile(
                      leading: SizedBox(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/250?image=9",
                          ),
                          radius: 50.0,
                        ),
                        width: 50,
                        height: 50,
                      ),
                      title: Text("陈鹏"),
                      subtitle: Text("Lv.1 大几把会员"),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     TextButton(
                    //       child: const Text("蒽"),
                    //       onPressed: () => print("蒽"),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     TextButton(
                    //       child: const Text("大妈你没事吧"),
                    //       onPressed: () => print("蒽"),
                    //     ),
                    //   ],
                    // )
                  ]))),
          SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text(
                      languageProvider.get("privacy")), // 多语言支持 *experimental
                  onTap: () {
                    Navigator.pushNamed(context, "/privacy");
                    print("yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: Icon(Icons.headphones),
                  title:
                      Text(languageProvider.get("help")), // 多语言支持 *experimental
                  onTap: () {
                    Navigator.pushNamed(context, "/follow_list");
                    print("yuh yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                      languageProvider.get("setting")), // 多语言支持 *experimental
                  onTap: () {
                    print("yuh yuh yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title:
                      Text(languageProvider.get("lang")), // 多语言支持 *experimental
                  onTap: () {
                    setState(() {
                      languageProvider.switchLanguage("en-US");
                      print(languageProvider.currentLanguage);
                    });
                  },
                ),
              ],
            ),
          ),
          DisappearingCard(
            cardContext:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const ListTile(
                leading: Icon(Icons.handyman),
                title: Text("这只是一个测试 #3"),
                subtitle: Text("开通大几把会员让几把马上变大"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text("yuh"),
                    onPressed: () => print("yuh"),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text("huh"),
                    onPressed: () => print("huh"),
                  ),
                ],
              )
            ]),
          ),
        ],
      ),
      // drawer: Drawer(),
      // endDrawer: Drawer(),
    );
  }
}
