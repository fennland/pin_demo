import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../components.dart';
import '../strings/lang.dart';
import 'package:provider/provider.dart';

class msgPage extends StatefulWidget {
  const msgPage({super.key});

  @override
  State<msgPage> createState() => _msgPageState();
}

class _msgPageState extends State<msgPage> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(languageProvider.get("msg"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))),
      body: Column(
        children: [
          serviceCard(
              leading: Icon(Icons.handyman),
              title: Text(languageProvider.get("service0")),
              subtitle: Text(languageProvider.get("service0_sub")),
              textbutton: [
                TextButton(
                    child: Text(languageProvider.get("cancel")),
                    onPressed: () => debugPrint("todo: service cancel")),
                TextButton(
                    child: Text(languageProvider.get("ok")),
                    onPressed: () => debugPrint("todo: service ok")),
              ]),
          serviceCard(
            leading: Icon(Icons.handyman),
            title: Text(languageProvider.get("service1")),
            subtitle: Text(languageProvider.get("service1_sub")),
          ),
          SizedBox(
            height: 30.0,
          ),
          itemListWidget(type: "user", itemCount: 3),
        ],
      ),
      drawer: Drawer(),
      // endDrawer: Drawer(),
    );
  }
}
