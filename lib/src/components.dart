import 'package:flutter/material.dart';
class DisappearingCard extends StatefulWidget {
  final Widget cardContext;

  const DisappearingCard({required this.cardContext});

  @override
  _DisappearingCardState createState() => _DisappearingCardState();
}

class _DisappearingCardState extends State<DisappearingCard> {
  bool _isVisible = true;

  void _hideCard() {
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? GestureDetector(
            onTap: _hideCard,
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('Card #2 tapped.');
                  _hideCard();
                },
                child: widget.cardContext,
              ),
            ))
        : SizedBox(); // 当 isVisible 为 false 时返回一个空的 SizedBox
  }
}