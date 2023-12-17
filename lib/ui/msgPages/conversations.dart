// import 'package:flutter/material.dart';
// import 'package:pin_demo/src/model/order_model.dart';
// import 'package:pin_demo/src/utils/constants/lang.dart';
// import 'package:provider/provider.dart';

// class ConversationsPage extends StatefulWidget {
//   final int? userID;
//   final String? groupName;
//   final List<chatMessagesModel>? msgs;

//   const ConversationsPage(
//       {Key? key, required this.userID, required this.groupName, this.msgs})
//       : super(key: key);

//   @override
//   _ConversationsPageState createState() => _ConversationsPageState();
// }

// class _ConversationsPageState extends State<ConversationsPage> {
//   final Color _bgcolor = Colors.transparent;
//   final TextEditingController _textController = TextEditingController();
//   late Map<String, dynamic> _defaultMsgData;
//   List<Map<String, String>>? _messages;

//   @override
//   void initState() {
//     super.initState();
//   }

//   // void _addMessage(String message, String type) {
//   //   setState(() {
//   //     _messages!.add({
//   //       'type': type,
//   //       'message': message,
//   //     });
//   //   });
//   //   debugPrint(_messages!.toString());
//   //   _textController.clear();
//   // }

//   Widget _buildMessageBubble(String message, String type) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: type == 'sent'
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start, // TODO: 检查senderID == 当前 userID
//         children: [
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//             decoration: BoxDecoration(
//               color: type == 'sent'
//                   ? Colors.blue
//                   : Colors.grey[300], // TODO: 检查senderID == 当前 userID
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: GestureDetector(
//               onLongPressStart: (detail) {
//                 // _bgcolor = Colors.grey.withOpacity(0.5);
//                 debugPrint("TODO: Long press msg"); // TODO: long press msg
//                 setState(() {});
//                 // _showMenu(context, detail);
//               },
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   backgroundColor: _bgcolor,
//                   color: type == 'sent'
//                       ? Colors.white
//                       : Colors.black, // TODO: 检查senderID == 当前 userID
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final dynamic userData =
//     //     ModalRoute.of(context)?.settings.arguments ?? _defaultMsgData;
//     var languageProvider = Provider.of<LanguageProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.groupName ?? "未命名的聊天"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return _buildMessageBubble(_messages![index]['messageText']!,
//                       _messages![index]['senderID']!);
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       decoration: InputDecoration(
//                         hintText: languageProvider.get("msgboxhint"),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   IconButton(
//                     onPressed: () {
//                       if (_textController.text.isNotEmpty) {
//                         // _addMessage(_textController.text, 'sent');
//                       }
//                     },
//                     icon: const Icon(Icons.send),
//                     iconSize: 36.0,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       endDrawer: Drawer(
//           child: Column(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.delete),
//             title: Text(languageProvider.get("delfriends")),
//             onTap: () => debugPrint("TODO: delete friends"),
//           )
//         ],
//       )),
//     );
//   }
// }

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
      {Key? key, required this.groupName, required this.groupID})
      : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final Color _bgcolor = Colors.transparent;
  final TextEditingController _textController = TextEditingController();
  late Map<String, dynamic> _defaultMsgData;
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

  Widget _buildMessageBubble(String message, bool isSent, String timestamp) {
    String formattedTime = formatTimestamp(timestamp);
    if (_messages.isEmpty) {
      return Container();
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment:
              isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: isSent ? Colors.white70 : Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      itemCount: _messages!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var msg = _messages![index];
                        bool isSent = msg.senderID == userID;
                        Widget bubble = _buildMessageBubble(
                          msg.messageText!,
                          isSent,
                          msg.timestamp!,
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
