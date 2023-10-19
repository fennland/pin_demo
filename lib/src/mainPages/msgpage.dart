import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../components.dart';
import '../strings/lang.dart';

class msgPage extends StatefulWidget {
  const msgPage({super.key});

  @override
  State<msgPage> createState() => _msgPageState();
}

class _msgPageState extends State<msgPage> {
  @override
  Widget build(BuildContext context) {
    langStrings langString =
        langStrings(LanguageProvider.of(context)!.languageCode);
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
            child: ListView.separated(
              itemCount: 3, // 总用户数量
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                    "https://picsum.photos/250?image=${index}",
                  )),
                  title: Text(
                      langString.get("user${index}")), // 多语言支持 *experimental
                  subtitle: Text(langString.get("user${index}_sub")),
                  onTap: () {
                    print("yuh~"); // TODO: 我的页面二级跳转
                    final snackBar = SnackBar(content: Text('yuh'));
                    // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0.0,
                  color: Colors.grey,
                  thickness: 0.5,
                  indent: 20.0,
                  endIndent: 20.0,
                );
              },
            ),
          )
        ],
      ),
      drawer: Drawer(),
      // endDrawer: Drawer(),
    );
  }
}
