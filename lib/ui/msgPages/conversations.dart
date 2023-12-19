// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:pin_demo/src/utils/map.dart';
import 'package:pin_demo/ui/orderPages/orderinfo.dart';
import 'package:pin_demo/ui/users/userProfile.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatefulWidget {
  final String? groupName;
  final int? groupID;
  // final List<chatMessagesModel>? msgs;

  const ConversationsPage(
      {super.key, required this.groupName, required this.groupID});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final LocationService _locationService = LocationService();
  final Color _bgcolor = Colors.transparent;
  final TextEditingController _textController = TextEditingController();
  int? userID;
  double _currentPosition_x = 118.085152;
  double _currentPosition_y = 24.603804;
  orderModel? orderM;
  double? distance;
  List<chatMessagesModel> _messages = [];

  @override
  void initState() {
    super.initState();
    // setState(() {
    _getCurrentLocation();
    _getUserID();
    _getGPMsgs();
    _getOrderInfo();
    _getUserGroupDistance();
    // });
  }

  String? getFormatterDatetime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    if (dateTime.isBefore(DateTime.now())) {
      return '已结束';
    } else if (dateTime.difference(DateTime.now()).inDays >= 1) {
      return '${dateTime.difference(DateTime.now()).inDays}天后';
    } else {
      return '今天 ${dateTime.hour}:${dateTime.minute}';
    }
  }

  // 调用LocationService的getCurrentLocation方法获取当前位置信息
  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _locationService.getCurrentLocation();
      _currentPosition_x = position.longitude;
      _currentPosition_y = position.latitude;
      debugPrint("_currentPosition_x: $_currentPosition_x");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getUserID() async {
    var user = await getCurUserInfo();
    if (user != null) {
      userID = user.userID;
    }
  }

  Future<UserModel?> _getUserInfo(userID) async {
    var userJson = await requestUserInfo(userID);
    if (userJson != null) {
      var user = UserModel.fromJson(userJson);
      return user;
    }
    return null;
  }

  Future<bool> _getOrderInfo() async {
    orderM = await orderApi.getOrderInfoByGroupID(widget.groupID);
    if (orderM != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _getUserGroupDistance() async {
    var result = await orderApi.getUserGroupDistance(
        _currentPosition_y, _currentPosition_x, widget.groupID);
    if (result != null) {
      setState(() {
        distance = result;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getGPMsgs() async {
    try {
      if (widget.groupID != null) {
        _messages = await orderApi.getGroupMessages(widget.groupID);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("没有找到对应群聊..."),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 109, 109),
        ));
        Navigator.of(context).pop();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> newGPMsgs(messageText) async {
    try {
      var _newMessages =
          await orderApi.newMessage(userID, widget.groupID, messageText);
      setState(() {
        _getGPMsgs();
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var languageProvider = Provider.of<LanguageProvider>(context);

    Widget _buildMessageBubble(String message, String senderName,
        String? avatar, bool isSent, String timestamp, int userID) {
      // debugPrint("$senderName : $avatar");
      String formattedTime = formatTimestamp(timestamp);
      if (_messages.isEmpty) {
        return Container();
      } else {
        Widget _bubble = Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.6, // 最大宽度为200
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: GestureDetector(
            onLongPressStart: (detail) {
              debugPrint("TODO: Long press msg"); // TODO: long press msg
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(children: [
                  SelectableText(
                    message,
                    // softWrap: true,
                    style: TextStyle(
                      backgroundColor: _bgcolor,
                      color: isSent
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 16.0,
                    ),
                    // maxLines: null,
                  ),
                ]),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        );

        Widget _avatar = CircleAvatar(
            child: ClipOval(child: Image.asset("static/images/avatar.jpeg")));

        // if ((avatar == "" || avatar == null) &&
        //     (senderName != "" && senderName != null))
        //   _avatar = generateAvatar(senderName, context);
        // else
        if (avatar != "" && avatar != null) {
          _avatar = CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatar,
                progressIndicatorBuilder: (context, url, progress) {
                  // debugPrint(progress.toString());
                  return CircularProgressIndicator(
                      value: double.tryParse(
                          progress.toString())); // 添加了 return 语句
                },
                errorListener: (value) {
                  debugPrint(
                      "ERROR in CachedNetworkImage: ${value.toString()}");
                  ErrorHint("ERROR in CachedNetworkImage: ${value.toString()}");
                },
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline_rounded),
              ),
            ),
          );
        }

        Widget _timelabel = Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Text(
            formattedTime,
            style: const TextStyle(color: Colors.grey, fontSize: 10.0),
          ),
        );

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: isSent
                ? [
                    _timelabel,
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bubble,
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: GestureDetector(
                                child: _avatar,
                                onTap: () {
                                  // var user = await _getUserInfo(userID);
                                  // if (user != null) {
                                  //   Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               someUserProfile(user: user)));
                                  // } else {
                                  //   debugPrint("未获取到用户数据");
                                  // }
                                  Navigator.of(context)
                                      .pushNamed("/my/profile");
                                  // debugPrint(
                                  //     "TODO: avatar->someUserProfile");
                                }),
                          )
                        ])
                  ]
                : [
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                        child: GestureDetector(
                            child: _avatar,
                            onTap: () async {
                              var user = await _getUserInfo(userID);
                              if (user != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        someUserProfile(user: user)));
                              } else {
                                debugPrint("未获取到用户数据");
                              }
                            }),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 75.0,
                              ),
                              child: Text(senderName,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          _bubble,
                        ],
                      )
                    ]),
                    _timelabel
                  ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.groupName ?? "未命名的聊天",
                style: (orderM == null ||
                        orderM?.startTime == null ||
                        distance == null)
                    ? null
                    : const TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.w600)),
            (orderM == null || orderM?.startTime == null || distance == null)
                ? Container()
                : Container(
                    constraints:
                        BoxConstraints(maxWidth: screenSize.width * 0.5),
                    child: Text(
                        "${getFormatterDatetime(orderM!.startTime)}, $distance km",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 500), _getGPMsgs),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                setState(() {
                  // getGPMsgs();
                });
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Expanded(
                    //     child: Stack(children: [
                    //   const Center(child: CircularProgressIndicator()),
                    //   Container()
                    // ]) // Must return a widget
                    //     ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          var msg = _messages[index];
                          bool isSent = msg.senderID == userID;
                          Widget bubble = _buildMessageBubble(
                              msg.messageText,
                              msg.senderName ?? "PinUser",
                              msg.avatar,
                              isSent,
                              msg.timestamp,
                              msg.senderID);
                          return bubble;
                        },
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              maxLines: null,
                              style: const TextStyle(fontSize: 14.0),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                    minHeight: 36.0, maxHeight: 128.0),
                                hintText: languageProvider.get("msgboxhint"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              if (_textController.text.isNotEmpty) {
                                newGPMsgs(_textController.text);
                                _textController.clear();
                              }
                            },
                            icon: const Icon(Icons.send),
                            iconSize: 32.0,
                          ),
                        ],
                      ),
                    ),
                  ], // Removed unnecessary closing bracket
                ),
              );
            }),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(languageProvider.get("conversations_info")),
                  onTap: () async {
                    try {
                      orderM =
                          await orderApi.getOrderInfoByGroupID(widget.groupID);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => orderInfoPage(order: orderM),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("遇到错误啦，再试一下吧..."),
                        backgroundColor: Color.fromARGB(255, 255, 109, 109),
                      ));
                      debugPrint(e.toString());
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(languageProvider.get("leaveMsg")),
                onTap: () =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("功能暂未开放"),
                  backgroundColor: Color.fromARGB(255, 255, 109, 109),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
