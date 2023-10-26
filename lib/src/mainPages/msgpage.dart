// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../utils/components.dart';
import '../utils/strings/lang.dart';
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

    // serviceCard
    var serviceCard1 = DisappearingCard(
      automaticallyDisappear: true,
      defaultBtns: true,
      cardContext: ListTile(
        leading: const Icon(Icons.handyman),
        title: Text(languageProvider.get("service0")),
        subtitle: Text(languageProvider.get("service0_sub")),
      ),
    );
    var serviceCard2 = DisappearingCard(
      automaticallyDisappear: true,
      defaultBtns: false,
      cardContext: ListTile(
        leading: const Icon(Icons.handyman),
        title: Text(languageProvider.get("service1")),
        subtitle: Text(languageProvider.get("service1_sub")),
      ),
      buttonLeft: TextButton(
        child: const Text("testOK"),
        onPressed: () => debugPrint("it's a test"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(languageProvider.get("msg"),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18.0))),
      body: Column(
        children: [
          serviceCard1,
          serviceCard2,
          const itemListWidget(type: "user", itemCount: 3),
        ],
      ),
      drawer: const Drawer(),
    );
  }
}
