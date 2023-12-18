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

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final LocationService _locationService = LocationService();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  // bool? _maleSelected = false;
  // bool? _femaleSelected = true;
  // int? _gender = 0;
  double _currentPosition_x = 0.0;
  double _currentPosition_y = 0.0;

  bool _isValidPhoneNumber = false;
  final bool _isValidPwd = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

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
                child: Text(languageProvider.get("register"),
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _userNameController,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: languageProvider.get("username"),
                      prefixIcon: const Icon(Icons.person)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _phoneNumberController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: languageProvider.get("usernameLogin"),
                      prefixIcon: const Icon(Icons.phone)),
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
              // Column(
              //   children: [
              //     CheckboxListTile(
              //       title: Text(languageProvider.get("gender_male")),
              //       value: _maleSelected,
              //       onChanged: (bool? value) {
              //         setState(() {
              //           _maleSelected = value!;
              //           _femaleSelected = !value; // 另一个选项的状态与当前选项相反
              //           _gender = 1 - _gender!;
              //         });
              //       },
              //     ),
              //     CheckboxListTile(
              //       title: Text(languageProvider.get("gender_female")),
              //       value: _femaleSelected,
              //       onChanged: (bool? value) {
              //         setState(() {
              //           _femaleSelected = value!;
              //           _maleSelected = !value; // 另一个选项的状态与当前选项相反
              //           _gender = 1 - _gender!;
              //         });
              //       },
              //     ),
              //   ],
              // ),
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
                          final registerScaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          var regResult = await postRegisterForm(
                              _userNameController.text,
                              _phoneNumberController.text,
                              _pwdController.text);
                          if (regResult["code"] == 200 ||
                              regResult["code"] == 201) {
                            debugPrint(regResult["result"].toString());
                            saveUserInfo(UserModel(
                              userName: regResult["result"]["data"]["userName"],
                              userID: regResult["result"]["data"]["userID"],
                              phone: regResult["result"]["data"]["phone"],
                              avatar: regResult["result"]["data"]["avatar"],
                              sign: regResult["result"]["data"]["sign"],
                              gender: regResult["result"]["data"]["gender"],
                              fav: regResult["result"]["data"]["fav"],
                              position_x: regResult["result"]["data"]
                                  ["position_x"],
                              position_y: regResult["result"]["data"]
                                  ["position_y"],
                            ));
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
                                  phone: loginResult["result"]["data"]["phone"],
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
                              SnackBar snackbar = SnackBar(
                                content: Text(
                                    languageProvider.get("registerSuccess")),
                                duration: const Duration(seconds: 2),
                              );
                              registerScaffoldMessenger.showSnackBar(snackbar);
                              await navigator.pushNamed("/my/profile");
                              await navigator.popAndPushNamed("/home");
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
                            // navigator.pushNamed("/login");
                          } else if (regResult["code"] == 409) {
                            SnackBar snackbar = SnackBar(
                              content: Text(languageProvider
                                  .get("registerAlreadyHaveSuchUser")),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 109, 109),
                              duration: const Duration(seconds: 2),
                            );
                            registerScaffoldMessenger.showSnackBar(snackbar);
                          } else if (regResult["code"] == 500 ||
                              regResult["code"] == 403) {
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
                            registerScaffoldMessenger.showSnackBar(snackbar);
                          } else {
                            SnackBar snackbar = SnackBar(
                              content: Text(
                                  languageProvider.get("loginFailedIncorrect")),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 109, 109),
                              duration: const Duration(seconds: 2),
                            );
                            registerScaffoldMessenger.showSnackBar(snackbar);
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
                    child: Text(languageProvider.get("register"))),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => languageProvider.switchLanguage(),
          heroTag: "register",
          child: const Icon(Icons.language),
        ));
  }
}
