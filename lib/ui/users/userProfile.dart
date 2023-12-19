import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:provider/provider.dart';

class someUserProfile extends StatefulWidget {
  // TODO: developing userprofile 1219
  UserModel user;
  someUserProfile({super.key, required this.user});

  @override
  State<someUserProfile> createState() => _someUserProfileState();
}

class _someUserProfileState extends State<someUserProfile> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var languageProvider = Provider.of<LanguageProvider>(context);
    var headBGImage = widget.user.avatar != null
        ? CachedNetworkImage(
            width: double.infinity,
            height: screenSize.height / 3,
            placeholder: (context, url) => Container(color: Colors.blueGrey),
            imageUrl: widget.user.avatar!,
            fit: BoxFit.fitWidth)
        : Image.asset("static/images/avatar.jpeg",
            width: double.infinity,
            height: screenSize.height / 3,
            fit: BoxFit.fitWidth);
    var headAvatar = ClipOval(
      child: Container(
          width: screenSize.height / 9,
          height: screenSize.height / 9,
          child: widget.user.avatar != null
              ? CachedNetworkImage(
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageUrl: widget.user.avatar!,
                  errorListener: (value) {
                    debugPrint(
                        "ERROR in someUserProfile's Avatar(CachedNetworkImage)!");
                    ErrorHint(
                        "ERROR in someUserProfile's Avatar(CachedNetworkImage)!");
                  },
                  errorWidget: (context, url, error) => Image.asset(
                      "static/images/avatar.jpeg",
                      width: double.infinity,
                      height: screenSize.height / 3,
                      fit: BoxFit.fitWidth),
                )
              : Image.asset("static/images/avatar.jpeg",
                  width: double.infinity,
                  height: screenSize.height / 3,
                  fit: BoxFit.fitWidth)),
    );

    /**
     * ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                        child: Image.network(
                          'https://example.com/avatar.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
     */

    return Scaffold(
        body: Column(
      children: [
        Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                headBGImage,
                Container(
                    width: double.infinity,
                    height: screenSize.height / 3,
                    color: Colors.black.withOpacity(0.5)),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        headAvatar,
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                          child: Text(widget.user.userName ?? "未知用户",
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 24.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: screenSize.width * 0.6),
                            child: Text(widget.user.sign ?? "还没有签名呢...",
                                style: const TextStyle(
                                    fontSize: 11.0,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ]),
                ),
              ]),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent, // 设置为透明
              child: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                // 其他属性
              ),
            ),
          ),
        ]),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: Text(languageProvider.get("someUserProfileFunc_Tag")),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("功能尚未开放"),
                    duration: Duration(milliseconds: 1500),
                  ));
                  debugPrint("TODO: someUserProFunc_Tag");
                },
              ),
              ListTile(
                title: Text(languageProvider.get("someUserProfileFunc_Needs")),
                trailing: Text(languageProvider.get("someUserProfile_Needs")),
              ),
              ListTile(
                title: Text(languageProvider.get("someUserProfileFunc_Needs")),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("功能尚未开放"),
                    duration: Duration(milliseconds: 1500),
                  ));
                  debugPrint("TODO: someUserProFunc_Needs");
                },
              )
            ],
          ),
        )
      ],
    ));
  }
}
