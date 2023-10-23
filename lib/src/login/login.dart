// import 'dart:html';

// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../strings/lang.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  void onSubmitPressed() {
    debugPrint("TODO: login submit pressed");
    Navigator.pushNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.get("home")),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("一键登录"),
          const TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelText: "用户名",
                hintText: "用户名或邮箱",
                prefixIcon: Icon(Icons.person)),
          ),
          const TextField(
            decoration: InputDecoration(
                labelText: "密码",
                hintText: "您的登录密码",
                prefixIcon: Icon(Icons.lock)),
            obscureText: true,
          ),
          const SizedBox(
            height: 20.0,
          ),
          OutlinedButton(
              onPressed: onSubmitPressed,
              child: Text(languageProvider.get("login")))
        ],
      ),
    );
  }
}
