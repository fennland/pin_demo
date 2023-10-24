// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/login/login.dart';
import 'package:pin_demo/src/strings/lang.dart';
import 'package:provider/provider.dart';

class platformAlert extends StatefulWidget {
  const platformAlert({super.key});

  @override
  _platformAlertState createState() => _platformAlertState();
}

class _platformAlertState extends State<platformAlert> {
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
            future: Future.value(
                (kIsWeb || Platform.isMacOS || isAndroidSimulator)),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data == true) {
                  return AlertDialog(
                    title: const Icon(Icons.warning),
                    content: Text(
                      languageProvider.get("unsupportedPlatformConfirm"),
                      textAlign: TextAlign.center,
                    ),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.language),
          onPressed: () => languageProvider.switchLanguage(),
          heroTag: "alert",
        ));
  }
}
