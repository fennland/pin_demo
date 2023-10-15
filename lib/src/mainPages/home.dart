import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    // int lastIndex = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {
          final snackbar = SnackBar(content: Text("fuck you!"), action: SnackBarAction(label: "OK", onPressed: () => debugPrint("OK"),),);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },),],
        ),
      body: Center(child: Text("首页")),
    );
  }
}