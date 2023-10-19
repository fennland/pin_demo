import 'package:flutter/material.dart';
import 'package:pin_demo/src/strings/lang.dart';
import 'package:provider/provider.dart';

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

class itemListWidget extends StatefulWidget {
  final String type;
  final int itemCount;
  const itemListWidget({Key? key, required this.type, required this.itemCount});
  @override
  _itemListWidget createState() => _itemListWidget();
}

class _itemListWidget extends State<itemListWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var langProvider = Provider.of<LanguageProvider>(context);
    return Expanded(
      child: ListView.separated(
        itemCount: widget.itemCount, // 总用户数量
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(
              "https://picsum.photos/250?image=${index}",
            )),
            title: Text(langProvider
                .get("${widget.type}${index}")), // 多语言支持 *experimental
            subtitle: Text(langProvider.get("${widget.type}${index}_sub")),
            onTap: () {
              print("yuh~"); // TODO: 我的页面二级跳转
              final snackBar = SnackBar(content: Text('yuh'));
              // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0.0,
            color: Colors.grey,
            thickness: 0.5,
            indent: 20.0,
            endIndent: 20.0,
          );
        },
      ),
    );
  }

  // Expanded getItemList(LanguageProvider languageProvider, {String type = "user", int itemCount = 1}) {
  //   return Expanded(
  //     child: ListView.separated(
  //       itemCount: widget.itemCount, // 总用户数量
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           leading: CircleAvatar(
  //               backgroundImage: NetworkImage(
  //             "https://picsum.photos/250?image=${index}",
  //           )),
  //           title: Text(languageProvider
  //               .get("${widget.type}${index}")), // 多语言支持 *experimental
  //           subtitle: Text(languageProvider.get("${widget.type}${index}_sub")),
  //           onTap: () {
  //             print("yuh~"); // TODO: 我的页面二级跳转
  //             final snackBar = SnackBar(content: Text('yuh'));
  //             // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
  //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //           },
  //         );
  //       },
  //       separatorBuilder: (context, index) {
  //         return Divider(
  //           height: 0.0,
  //           color: Colors.grey,
  //           thickness: 0.5,
  //           indent: 20.0,
  //           endIndent: 20.0,
  //         );
  //       },
  //     ),
  //   );
}
