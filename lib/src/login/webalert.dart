// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_demo/src/login/login.dart';
import 'package:pin_demo/src/strings/lang.dart';
import 'package:provider/provider.dart';

class WebAlert extends StatefulWidget {
  const WebAlert({super.key});

  @override
  _WebAlertState createState() => _WebAlertState();
}

class _WebAlertState extends State<WebAlert> {
  @override
  void initState() {
    super.initState();
    // if (kIsWeb) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text('Web Alert'),
    //           content: Text('This is a web alert!'),
    //           actions: <Widget>[
    //             TextButton(
    //               child: Text('OK'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      body: FutureBuilder<bool>(
          future: Future.value(kIsWeb),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data == true) {
                return AlertDialog(
                  title: const Icon(Icons.warning),
                  content: Text(languageProvider.get("webconfirm")),
                  actions: [
                    TextButton(
                      child: Text(languageProvider.get("cancel")),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    TextButton(
                      child: Text(languageProvider.get("ok")),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                    ),
                  ],
                );
              } else {
                return const loginPage();
              }
            } else {
              return const loginPage();
            }
          }),
    );
  }
}
