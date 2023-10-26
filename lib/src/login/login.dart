// import 'dart:html';

// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:pin_demo/src/users/defaultUser.dart';
import '../utils/strings/lang.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  bool _isValidPhoneNumber = false;
  bool _isCorrectPwd = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  bool isValidPwd() {
    String pwd = _pwdController.text;
    // 密码要求：6位-16位字符
    return (pwd.length >= 6 && pwd.length <= 16);
  }

  void _checkPhoneNumberValidity() {
    String phoneNumber = _phoneNumberController.text;
    RegExp regExp = RegExp(r'^[1-9]\d{10}$');
    bool isValid = regExp.hasMatch(phoneNumber);
    setState(() {
      _isValidPhoneNumber = isValid;
    });
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
          automaticallyImplyLeading: false,
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
                  controller: _phoneNumberController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: languageProvider.get("usernameLogin"),
                      prefixIcon: const Icon(Icons.person)),
                  textAlign: TextAlign.center,
                  // onSubmitted: (value) {
                  //   if (value.length == 11 && value[0] == '1') {
                  //     int? userid = int.tryParse(value);
                  //     if (userid != null) {
                  //       languageProvider.set("curUserPhone", userid.toString());
                  //     } else {
                  //       SnackBar snackbar = SnackBar(
                  //         content: Text(
                  //             languageProvider.get("loginFailedWithoutPhone")),
                  //         backgroundColor:
                  //             const Color.fromARGB(255, 255, 109, 109),
                  //         duration: const Duration(seconds: 2),
                  //       );
                  //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  //     }
                  //   } else {
                  //     SnackBar snackbar = SnackBar(
                  //       content: Text(
                  //           languageProvider.get("loginFailedWithoutPhone")),
                  //       backgroundColor:
                  //           const Color.fromARGB(255, 255, 109, 109),
                  //       duration: const Duration(seconds: 2),
                  //     );
                  //     ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  //   }
                  // },
                ),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      hintText: languageProvider.get("pwdLogin"),
                      prefixIcon: const Icon(Icons.lock)),
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
                    onPressed: () {
                      _checkPhoneNumberValidity();
                      if (_isValidPhoneNumber) {
                        if (isValidPwd()) {
                          if (_pwdController.text == curUser["pwd"] &&
                              _phoneNumberController.text == curUser["phone"]) {
                            // TODO: security check
                            Navigator.of(context).pushNamed("/home");
                          } else {
                            SnackBar snackbar = SnackBar(
                              content: Text(
                                  languageProvider.get("loginFailedIncorrect")),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 109, 109),
                              duration: const Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                        } else {
                          SnackBar snackbar = SnackBar(
                            content: Text(
                                languageProvider.get("loginFailedIncorrect")),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 109, 109),
                            duration: const Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      } else {
                        SnackBar snackbar = SnackBar(
                          content: Text(
                              languageProvider.get("loginFailedWithoutPhone")),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 109, 109),
                          duration: const Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    },
                    child: Text(languageProvider.get("login"))),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => languageProvider.switchLanguage(),
          heroTag: "login",
          child: const Icon(Icons.language),
        ));
  }
}
