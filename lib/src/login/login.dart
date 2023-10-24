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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(languageProvider.get("onekeyLogin"),
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: languageProvider.get("usernameLogin"),
                      prefixIcon: Icon(Icons.person)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: languageProvider.get("pwdLogin"),
                      prefixIcon: Icon(Icons.lock)),
                  textAlign: TextAlign.center,
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                    onPressed: onSubmitPressed,
                    child: Text(languageProvider.get("login"))),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.language),
          onPressed: () => languageProvider.switchLanguage(),
          heroTag: "login",
        ));
  }
}
