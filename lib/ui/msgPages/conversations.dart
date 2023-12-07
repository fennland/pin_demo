import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/strings/lang.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const ConversationsPage({Key? key, this.userData}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final Color _bgcolor = Colors.transparent;
  final TextEditingController _textController = TextEditingController();
  late Map<String, dynamic> _defaultMsgData;
  List<Map<String, String>>? _messages;

  @override
  void initState() {
    super.initState();
    _defaultMsgData = {
      'title': 'New Group',
      'msgs': [
        {
          "type": "sent",
          "message": '你已加入需求群，来沟通交流吧！',
        },
        {
          "type": "received",
          "message": '这是一条测试消息',
        }
      ],
    };

    _messages = widget.userData != null
        ? widget.userData!['msgs']
        : _defaultMsgData['msgs'];
  }

  void _addMessage(String message, String type) {
    setState(() {
      _messages!.add({
        'type': type,
        'message': message,
      });
    });
    debugPrint(_messages!.toString());
    _textController.clear();
  }

  Widget _buildMessageBubble(String message, String type) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            type == 'sent' ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: type == 'sent' ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: GestureDetector(
              onLongPressStart: (detail) {
                // _bgcolor = Colors.grey.withOpacity(0.5);
                debugPrint("TODO: Long press msg"); // TODO: long press msg
                setState(() {});
                // _showMenu(context, detail);
              },
              child: Text(
                message,
                style: TextStyle(
                  backgroundColor: _bgcolor,
                  color: type == 'sent' ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final dynamic userData =
    //     ModalRoute.of(context)?.settings.arguments ?? _defaultMsgData;
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData != null
            ? widget.userData!['title']
            : _defaultMsgData['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMessageBubble(_messages![index]['message']!,
                      _messages![index]['type']!);
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
                        _addMessage(_textController.text, 'sent');
                      }
                    },
                    icon: const Icon(Icons.send),
                    iconSize: 36.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
          child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(languageProvider.get("delfriends")),
            onTap: () => debugPrint("TODO: delete friends"),
          )
        ],
      )),
    );
  }
}
