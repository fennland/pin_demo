// import 'dart:html';

// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:pin_demo/src/utils/shared/shared_preference_util.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:http/http.dart' as http;

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

  Future<Map<String, dynamic>> _postLoginForm(phone, pwd) async {
    try {
      var response = await http.post(
        Uri.parse(Constant.urlWebMap["login"]!),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'pwd': pwd}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // debugPrint(response.body);
        return ({
          "code": response.statusCode,
          "result": json.decode(response.body)
        });
      } else {
        return ({"code": response.statusCode, "result": {}});
      }
    } catch (e) {
      return ({"code": 500, "error": e.toString()});
    }
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
                    onPressed: () async {
                      _checkPhoneNumberValidity();
                      if (_isValidPhoneNumber) {
                        if (isValidPwd()) {
                          var loginResult = await _postLoginForm(
                              _phoneNumberController.text, _pwdController.text);
                          if (loginResult["code"] == 200 ||
                              loginResult["code"] == 201) {
                            print(loginResult["result"]);
                            saveUserInfo(UserModel(
                                userName: loginResult["result"]["data"]
                                    ["username"],
                                userID: loginResult["result"]["data"]["id"],
                                phone: loginResult["result"]["data"]["phone"],
                                avatar: loginResult["result"]["data"]["avatar"],
                                sign: loginResult["result"]["data"]["sign"]));
                            Navigator.of(context).pushNamed("/home");
                          } else if (loginResult["code"] == 404) {
                            SnackBar snackbar = SnackBar(
                              content:
                                  Text(languageProvider.get("loginNoSuchUser")),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 109, 109),
                              duration: const Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else if (loginResult["code"] == 500 ||
                              loginResult["code"] == 403) {
                            SnackBar snackbar = SnackBar(
                                content: Text(
                                    languageProvider.get("loginBadNetwork")),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 109, 109),
                                duration: const Duration(seconds: 5),
                                action: SnackBarAction(
                                    label: languageProvider
                                        .get("loginBadNetworkTest"),
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed("/server/test")));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
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
