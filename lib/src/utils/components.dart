// ignore_for_file: unused_import, camel_case_types

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/utils/strings/lang.dart';
import 'package:provider/provider.dart';
import 'dart:async';

bool unSupportedPlatform = !(kIsWeb ||
    Platform.isMacOS ||
    Platform.isIOS ||
    isAndroidSimulator ||
    Platform.isLinux ||
    Platform.isWindows);

class isCardVisibleNotifier extends ChangeNotifier {
  //这里也可以使用with来进行实现
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  setVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }
}

class DisappearingCard extends StatefulWidget {
  final Widget cardContext;
  final Widget? buttonRight;
  final Function()? btnRightBehaviour;
  final Widget? buttonLeft;
  final Function()? btnLeftBehaviour;
  final bool? automaticallyDisappear;
  final bool? defaultBtns;
  const DisappearingCard(
      {super.key,
      required this.cardContext,
      this.buttonRight,
      this.btnRightBehaviour,
      this.buttonLeft,
      this.btnLeftBehaviour,
      this.automaticallyDisappear = true,
      this.defaultBtns = true});

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
    var languageProvider = Provider.of<LanguageProvider>(context);
    return _isVisible
        ? GestureDetector(
            onTap: _hideCard,
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  _hideCard();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.cardContext,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (widget.buttonLeft == null)
                            ? ((widget.defaultBtns == true)
                                ? TextButton(
                                    child: Text(languageProvider.get("cancel")),
                                    onPressed: () {
                                      (widget.btnLeftBehaviour != null)
                                          ? widget.btnLeftBehaviour!()
                                          : () {};
                                      (widget.automaticallyDisappear == true)
                                          ? _hideCard()
                                          : () {};
                                    },
                                  )
                                : Container())
                            : widget.buttonLeft!,
                        (widget.buttonRight == null)
                            ? ((widget.defaultBtns == true)
                                ? TextButton(
                                    child: Text(languageProvider.get("ok")),
                                    onPressed: () {
                                      (widget.btnRightBehaviour != null)
                                          ? widget.btnRightBehaviour!()
                                          : () {};
                                      (widget.automaticallyDisappear == true)
                                          ? _hideCard()
                                          : () {};
                                    },
                                  )
                                : Container())
                            : widget.buttonRight!,
                      ],
                    ),
                  ],
                ),
              ),
            ))
        : const SizedBox(); // 当 isVisible 为 false 时返回一个空的 SizedBox
  }
}

class itemListWidget extends StatefulWidget {
  final String type;
  final int itemCount;
  const itemListWidget(
      {super.key, required this.type, required this.itemCount});
  @override
  _itemListWidget createState() => _itemListWidget();
}

class _itemListWidget extends State<itemListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
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
                  imageUrl: "https://picsum.photos/250?image=$index",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorListener: (value) {
                    debugPrint("ERROR in CachedNetworkImage!");
                    ErrorHint("ERROR in myPage's CachedNetworkImage!");
                  },
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline_rounded),
                ),
              ),
            ),
            title: Text(langProvider
                .get("${widget.type}$index")), // 多语言支持 *experimental
            subtitle: Text(langProvider.get("${widget.type}${index}_sub")),
            onTap: () {
              Navigator.pushNamed(context, "/msg/conversations",
                  arguments: langProvider.get("${widget.type}$index"));
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
