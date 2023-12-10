import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(settings());
}

class settings extends StatefulWidget {
  static var body;

  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("settings"))),
      body: Column(
        children: [
          ListTile(
            leading: Text(languageProvider.get("account_management")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            leading: Text(languageProvider.get("account_and_security")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            leading: Text(languageProvider.get("push_notification_settings")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            leading: Text(languageProvider.get("general_settings")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            leading: Text(languageProvider.get("customer_service_center")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            leading: Text(languageProvider.get("remCache")),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
