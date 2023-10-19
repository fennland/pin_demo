import 'package:flutter/material.dart';
import 'package:pin_demo/src/strings/strings.dart';
import '../../main.dart' show lang;
import '../components.dart';
import '../strings/zh-CN.dart';

class msgPage extends StatefulWidget {
  const msgPage({super.key});

  @override
  State<msgPage> createState() => _msgPageState();
}

class _msgPageState extends State<msgPage> {
  strings langString = new strings(lang);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("消息")),
      body: Column(
        children: [
          DisappearingCard(
            cardContext:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const ListTile(
                leading: Icon(Icons.handyman),
                title: Text("服务通知 #1"),
                subtitle: Text("这只是一个测试"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text(langString.get("ok")),
                    onPressed: () => print("ok"),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: Text(langString.get("cancel")),
                    onPressed: () => print("cancel"),
                  ),
                ],
              )
            ]),
          ),
          DisappearingCard(
            cardContext:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const ListTile(
                leading: Icon(Icons.handyman),
                title: Text("服务通知 #2"),
                subtitle: Text("好的叫贵咪 不好的叫敌咪 \n敌咪就是敌人的咪咪"),
              ),
            ]),
          ),
          SizedBox(
            height: 30.0,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                  "https://picsum.photos/250?image=10",
                )),
                title: Text(langString.get("user1")), // 多语言支持 *experimental
                subtitle: Text(langString.get("user1_sub")),
                onTap: () {
                  print("yuh~"); // TODO: 我的页面二级跳转
                  final snackBar = SnackBar(content: Text('yuh'));
                  // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                  "https://picsum.photos/250?image=11",
                )),
                title: Text(langString.get("user2")), // 多语言支持 *experimental
                subtitle: Text(langString.get("user2_sub")),
                onTap: () {
                  print("yuh yuh~"); // TODO: 我的页面二级跳转
                  final snackBar = SnackBar(content: Text('yuh yuh'));
                  // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                  "https://picsum.photos/250?image=11",
                )),
                title: Text(langString.get("group1")), // 多语言支持 *experimental
                subtitle: Text(langString.get("group1_sub")),
                onTap: () {
                  print("yuh yuh yuh~"); // TODO: 我的页面二级跳转
                  final snackBar = SnackBar(
                    content: Text('yuh yuh yuh'),
                    action: SnackBarAction(
                      label: "蒽～❤️",
                      onPressed: () => debugPrint("Yuh~~~"),
                    ),
                  );
                  // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          ))
        ],
      ),
      drawer: Drawer(),
      // endDrawer: Drawer(),
    );
  }
}
