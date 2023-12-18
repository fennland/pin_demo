// import 'dart:html';

// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';
import 'package:pin_demo/src/utils/constants/constant.dart';
import 'package:pin_demo/src/utils/shared/shared_preference_util.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final LocationService _locationService = LocationService();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  double _currentPosition_x = 0.0;
  double _currentPosition_y = 0.0;

  bool _isValidPhoneNumber = false;
  final bool _isCorrectPwd = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    FutureBuilder(
      future: _isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          Navigator.of(context).pushNamed("/home");
        } else {
          debugPrint("Not login yet!");
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  Future<UserModel?> _isLogin() async {
    UserModel? user = await getUserInfo();
    if (user != null) {
      if (user.userID != null && user.lastLoginTime != null) {
        var loginResult = await postLoginForm_logined(
            user.phone, _currentPosition_x, _currentPosition_y);
        if (loginResult["code"] == 200 || loginResult["code"] == 201) {
          debugPrint(loginResult["result"].toString());
          saveUserInfo(UserModel(
              userName: loginResult["result"]["data"]["userName"],
              userID: loginResult["result"]["data"]["userID"],
              phone: loginResult["result"]["data"]["phone"],
              avatar: loginResult["result"]["data"]["avatar"],
              sign: loginResult["result"]["data"]["sign"],
              gender: loginResult["result"]["data"]["gender"],
              fav: loginResult["result"]["data"]["fav"],
              position_x: loginResult["result"]["data"]["position_x"],
              position_y: loginResult["result"]["data"]["position_y"],
              lastLoginTime: loginResult["result"]["data"]["lastLoginTime"]));
          return user;
        }
      }
    }
    return null;
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

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _currentPosition_x = position.longitude;
          _currentPosition_y = position.latitude;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
                child: Image.asset(
                  'static/images/appicon.png',
                  width: screenSize.width / 10,
                  height: screenSize.width / 10,
                ),
              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          _checkPhoneNumberValidity();
                          if (_isValidPhoneNumber) {
                            if (isValidPwd()) {
                              final loginScaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              var loginResult = await postLoginForm(
                                  _phoneNumberController.text,
                                  _pwdController.text,
                                  _currentPosition_x,
                                  _currentPosition_y);
                              if (loginResult["code"] == 200 ||
                                  loginResult["code"] == 201) {
                                debugPrint(loginResult["result"].toString());
                                saveUserInfo(UserModel(
                                    userName: loginResult["result"]["data"]
                                        ["userName"],
                                    userID: loginResult["result"]["data"]
                                        ["userID"],
                                    phone: loginResult["result"]["data"]
                                        ["phone"],
                                    avatar: loginResult["result"]["data"]
                                        ["avatar"],
                                    sign: loginResult["result"]["data"]["sign"],
                                    gender: loginResult["result"]["data"]
                                        ["gender"],
                                    fav: loginResult["result"]["data"]["fav"],
                                    position_x: loginResult["result"]["data"]
                                        ["position_x"],
                                    position_y: loginResult["result"]["data"]
                                        ["position_y"],
                                    lastLoginTime: loginResult["result"]["data"]
                                        ["lastLoginTime"]));
                                navigator.popAndPushNamed("/home");
                              } else if (loginResult["code"] == 404) {
                                SnackBar snackbar = SnackBar(
                                  content: Text(
                                      languageProvider.get("loginNoSuchUser")),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 109, 109),
                                  duration: const Duration(seconds: 2),
                                );
                                loginScaffoldMessenger.showSnackBar(snackbar);
                              } else if (loginResult["code"] == 500 ||
                                  loginResult["code"] == 403) {
                                SnackBar snackbar = SnackBar(
                                    content: Text(languageProvider
                                        .get("loginBadNetwork")),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 109, 109),
                                    duration: const Duration(seconds: 5),
                                    action: SnackBarAction(
                                        label: languageProvider
                                            .get("loginBadNetworkTest"),
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed("/server/test")));
                                loginScaffoldMessenger.showSnackBar(snackbar);
                              } else {
                                SnackBar snackbar = SnackBar(
                                  content: Text(languageProvider
                                      .get("loginFailedIncorrect")),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 109, 109),
                                  duration: const Duration(seconds: 2),
                                );
                                loginScaffoldMessenger.showSnackBar(snackbar);
                              }
                            } else {
                              SnackBar snackbar = SnackBar(
                                content: Text(languageProvider
                                    .get("loginFailedIncorrect")),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 109, 109),
                                duration: const Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            }
                          } else {
                            SnackBar snackbar = SnackBar(
                              content: Text(languageProvider
                                  .get("loginFailedWithoutPhone")),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 109, 109),
                              duration: const Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                        },
                        child: Text(languageProvider.get("login")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                          child: Text(languageProvider.get("register")),
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/register")),
                    )
                  ],
                ),
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
