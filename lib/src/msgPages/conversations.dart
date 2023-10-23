import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  final String username;

  const ConversationsPage({super.key, required this.username});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'received',
      'message': 'Hello',
    },
    {
      'type': 'received',
      'message': 'How are you?',
    },
    {
      'type': 'sent',
      'message': 'I am fine, thank you.',
    },
    {
      'type': 'sent',
      'message': 'What are you doing?',
    },
    {
      'type': 'received',
      'message': 'I am working on a Flutter project.',
    },
    {
      'type': 'received',
      'message': 'That sounds interesting.',
    },
    {
      'type': 'sent',
      'message': 'Yes, it is.',
    },
  ];

  void _addMessage(String message, String type) {
    setState(() {
      _messages.add({
        'type': type,
        'message': message,
      });
    });
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
            child: Text(
              message,
              style: TextStyle(
                color: type == 'sent' ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessageBubble(
                    _messages[index]['message'], _messages[index]['type']);
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
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addMessage(_textController.text, 'sent');
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
