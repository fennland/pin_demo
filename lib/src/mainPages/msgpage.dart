import 'package:flutter/material.dart';
import '../components.dart';
import '../strings/zh-CN.dart';

class msgPage extends StatefulWidget {

  const msgPage({super.key});
  
  @override
  State<msgPage> createState() => _msgPageState();
}

class _msgPageState extends State<msgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("消息")),
        body: Column(
          children: [
            DisappearingCard(cardContext: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.handyman),
                    title: Text("这只是一个测试"),
                    subtitle: Text("好的叫贵咪 不好的叫敌咪 \n敌咪就是敌人的咪咪"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text("蒽"),
                        onPressed: () => print("蒽"),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text("么么哒"),
                        onPressed: () => print("么么哒"),
                      ),
                    ],
                  )
                ]),
              ),
            DisappearingCard(cardContext: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.handyman),
                    title: Text("这只是一个测试 #2"),
                    subtitle: Text("好的叫贵咪 不好的叫敌咪 \n敌咪就是敌人的咪咪"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text("蒽"),
                        onPressed: () => print("蒽"),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text("么么哒"),
                        onPressed: () => print("么么哒"),
                      ),
                    ],
                  )
                ]
              ),
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
                    title: Text(zhCNStrings().user1), // 多语言支持 *experimental
                    subtitle: Text(zhCNStrings().user1_sub),
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
                    title: Text(zhCNStrings().user2), // 多语言支持 *experimental
                    subtitle: Text(zhCNStrings().user2_sub),
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
                    title: Text(zhCNStrings().group1), // 多语言支持 *experimental
                    subtitle: Text(zhCNStrings().group1_sub),
                    onTap: () {
                      print("yuh yuh yuh~"); // TODO: 我的页面二级跳转
                      final snackBar = SnackBar(
                        content: Text('yuh yuh yuh'),
                        action: SnackBarAction(label: "蒽～❤️", onPressed: () => debugPrint("Yuh~~~"),),
                        );
                      // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ],
              ))],
        ),
        drawer: Drawer(),
        // endDrawer: Drawer(),
    );
  }
}
