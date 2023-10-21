import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/src/strings/lang.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
      flex: 5,
      child: ListView.separated(
        itemCount: widget.itemCount, // 总用户数量
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: "https://picsum.photos/250?image=${index}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorListener: (value) {
                    debugPrint("ERROR in CachedNetworkImage!");
                    ErrorHint("ERROR in myPage's CachedNetworkImage!");
                  },
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline_rounded),
                ),
              ),
            ),
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
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            indent: 20.0,
            endIndent: 20.0,
          );
        },
      ),
    );
  }
}

class serviceCard extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  // final Widget? trailing;
  final List<Widget>? textbutton;
  const serviceCard(
      {Key? key,
      required this.leading,
      required this.title,
      required this.subtitle,
      this.textbutton});
  @override
  _serviceCard createState() => _serviceCard();
}

class _serviceCard extends State<serviceCard> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    if (widget.textbutton != null) {
      return DisappearingCard(
        cardContext: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subtitle,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.textbutton!)
        ]),
      );
    }
    return DisappearingCard(
      cardContext: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          leading: widget.leading,
          title: widget.title,
          subtitle: widget.subtitle,
        ),
      ]),
    );
  }
}

// class MyImage extends StatelessWidget {
//   final String imageUrl;
//   final Widget placeholder;

//   const MyImage(
//       {Key? key, required this.imageUrl, this.placeholder = const SizedBox()})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ImageProvider<Object>>(
//       future: _loadImageAsync(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.hasData) {
//           return Image(image: snapshot.data!);
//         } else {
//           return placeholder;
//         }
//       },
//     );
//   }

//   Future<ImageProvider<Object>> _loadImageAsync(BuildContext context) async {
//     final completer = Completer<ImageProvider<Object>>();

//     try {
//       final image = NetworkImage(imageUrl);
//       await precacheImage(image, context); // 使用当前的BuildContext参数
//       completer.complete(image);
//     } catch (e) {
//       completer.completeError(e);
//     }

//     return completer.future;
//   }
// }
