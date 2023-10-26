import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/strings/lang.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatefulWidget {
  //final dynamic userData; // TODO: 改为map传入userDataMap

  const ConversationsPage({super.key});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  Color _bgcolor = Colors.transparent;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>>? _messages =
      messages["zh"]; // TODO: multilanguages

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
    final dynamic userData =
        ModalRoute.of(context)?.settings.arguments ?? "default";
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(userData),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMessageBubble(
                      _messages![index]['message'], _messages![index]['type']);
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
