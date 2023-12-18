// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/utils/utils.dart';
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
  final Color _bgcolor = Colors.transparent;
  final TextEditingController _textController = TextEditingController();
  int? userID;
  List<chatMessagesModel> _messages = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _getUserID();
      _getGPMsgs();
    });
  }

  Future<void> _getUserID() async {
    var user = await getUserInfo();
    if (user != null) {
      userID = user.userID;
    }
  }

  Future<void> _getGPMsgs() async {
    try {
      _messages = await orderApi.getGroupMessages(widget.groupID);
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

  Widget _buildMessageBubble(String message, String senderName, String? avatar,
      bool isSent, String timestamp) {
    String formattedTime = formatTimestamp(timestamp);
    if (_messages.isEmpty) {
      return Container();
    } else {
      Widget _bubble = Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSent ? Colors.blue : Colors.grey[300],
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
              Text(
                message,
                style: TextStyle(
                  backgroundColor: _bgcolor,
                  color: isSent ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      );

      // TODO: 1218 04:35 一个页面的头像都按照同一种方式呈现了

      Widget _avatar = CircleAvatar(
          child: ClipOval(child: Image.asset("static/images/avatar.jpeg")));

      if ((avatar == "" || avatar == null) &&
          (senderName != "" && senderName != null))
        _avatar = generateAvatar(senderName, context);
      else if (avatar != "" && avatar != null) {
        _avatar = CircleAvatar(
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatar,
              progressIndicatorBuilder: (context, url, progress) {
                return CircularProgressIndicator(
                    value: double.parse(progress.toString())); // 添加了 return 语句
              },
              errorListener: (value) {
                debugPrint("ERROR in CachedNetworkImage!");
                ErrorHint("ERROR in myPage's CachedNetworkImage!");
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
          style: Theme.of(context).textTheme.labelSmall,
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
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    _bubble,
                    Padding(
                        padding: isSent
                            ? EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0)
                            : EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                        child: _avatar)
                  ])
                ]
              : [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Padding(
                        padding: isSent
                            ? EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0)
                            : EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                        child: _avatar),
                    _bubble
                  ]),
                  _timelabel
                ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName ?? "未命名的聊天"),
      ),
      body: FutureBuilder(
          future: _getGPMsgs(),
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
                        );
                        return bubble;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
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
                              // chatMessagesModel newMsg = chatMessagesModel(
                              //   groupID: -1,
                              //   messageText: _textController.text,
                              //   messageID: -1,
                              //   senderID: widget.userID,
                              //   senderName: '',
                              //   timestamp: DateTime.now().toString(),
                              newGPMsgs(_textController.text);
                              // setState(() {
                              //   _messages!.add(newMsg);
                              // });
                              _textController.clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                          iconSize: 36.0,
                        ),
                      ],
                    ),
                  ),
                ], // Removed unnecessary closing bracket
              ),
            );
          }),
      endDrawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(languageProvider.get("delfriends")),
              onTap: () => debugPrint("TODO: delete friends"),
            ),
          ],
        ),
      ),
    );
  }
}
