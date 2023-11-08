import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/src/utils/strings/lang.dart';
import 'package:provider/provider.dart';

class someUserProfile extends StatefulWidget {
  const someUserProfile({super.key});

  @override
  State<someUserProfile> createState() => _someUserProfileState();
}

class _someUserProfileState extends State<someUserProfile> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var languageProvider = Provider.of<LanguageProvider>(context);
    var headBGImage = CachedNetworkImage(
        width: double.infinity,
        height: screenSize.height / 3,
        placeholder: (context, url) => Container(color: Colors.blueGrey),
        imageUrl: "https://picsum.photos/250?image=20",
        fit: BoxFit.fitWidth);
    var headAvatar = ClipOval(
      child: Container(
        width: screenSize.height / 9,
        height: screenSize.height / 9,
        child: CachedNetworkImage(
          imageUrl: "https://picsum.photos/250?image=9",
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorListener: (value) {
            debugPrint(
                "ERROR in someUserProfile's Avatar(CachedNetworkImage)!");
            ErrorHint("ERROR in someUserProfile's Avatar(CachedNetworkImage)!");
          },
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
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
                          child: Text(languageProvider.get("curUser"),
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 24.0),
                          child: Text(languageProvider.get("curUserSigning"),
                              style: const TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
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
                  debugPrint(
                      "TODO: someUserProFunc_Tag"); // TODO: someUserProfileTag
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
                  debugPrint(
                      "TODO: someUserProFunc_Needs"); // TODO: someUserProfileTag
                },
              )
            ],
          ),
        )
      ],
    ));
  }
}
