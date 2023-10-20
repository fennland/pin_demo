import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../strings/lang.dart';
import '../components.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
      appBar: AppBar(
        title: Text(
          languageProvider.get("my"),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      body: Column(
        children: [
          Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
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
                      title: Text(languageProvider.get("curUser")),
                      subtitle: Container(
                        child: Column(
                          children: [
                            SizedBox(height: 8.0),
                            LinearPercentIndicator(
                              alignment: MainAxisAlignment.start,
                              padding: EdgeInsets.all(0.0),
                              width: 100.0,
                              lineHeight: 14.0,
                              percent: 0.15,
                              center: Text(
                                languageProvider.get("curUserInfo"),
                                style: new TextStyle(
                                    fontSize: 10.0, color: Colors.white),
                              ),
                              barRadius: Radius.circular(20.0),
                              backgroundColor: Theme.of(context).disabledColor,
                              progressColor: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {
                          final snackBar = SnackBar(content: Text('yuh'));
                          // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ),
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
                    print("yuh~"); // TODO: 我的页面二级跳转
                  },
                ),
                ListTile(
                  leading: Icon(Icons.headphones),
                  title:
                      Text(languageProvider.get("help")), // 多语言支持 *experimental
                  onTap: () {
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
              ListTile(
                leading: Icon(Icons.handyman),
                title: Text(languageProvider.get("service2")),
                subtitle: Text(languageProvider.get("service2_sub")),
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
