// ignore_for_file: unused_import, curly_braces_in_flow_control_structures

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/utils/components.dart';
import 'package:pin_demo/src/utils/constants/lang.dart';
import 'package:pin_demo/src/model/order_model.dart';
import 'package:pin_demo/src/utils/utils.dart';
import 'package:pin_demo/ui/msgPages/conversations.dart';
import 'package:provider/provider.dart';

class msgPage extends StatefulWidget {
  const msgPage({super.key});

  @override
  State<msgPage> createState() => _msgPageState();
}

class _msgPageState extends State<msgPage> {
  List<chatMessagesModel> msgs = [];
  bool badNetwork = false;
  bool noMsgs = false;
  int? userID = -1;

  Future<void> _getUserID() async {
    try {
      UserModel? user = await getUserInfo();
      userID = user!.userID;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<chatMessagesModel>> _getMsgs() async {
    try {
      List<chatMessagesModel> responseMsgs =
          await orderApi.getUserLatestMessages();
      // print(responseOrders);
      if (mounted) {
        setState(() {
          if (responseMsgs != []) {
            msgs = responseMsgs;
          } else {
            noMsgs = true;
          }
        });
        return responseMsgs;
      } else {
        return [];
      }
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        badNetwork = true;
      });
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _getUserID();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    // serviceCard
    var serviceCard1 = DisappearingCard(
      automaticallyDisappear: true,
      defaultBtns: true,
      cardContext: ListTile(
        leading: const Icon(Icons.handyman),
        title: Text(languageProvider.get("service0")),
        subtitle: Text(languageProvider.get("service0_sub")),
      ),
    );
    // var serviceCard2 = DisappearingCard(
    //   automaticallyDisappear: true,
    //   defaultBtns: false,
    //   cardContext: ListTile(
    //     leading: const Icon(Icons.handyman),
    //     title: Text(languageProvider.get("service1")),
    //     subtitle: Text(languageProvider.get("service1_sub")),
    //   ),
    //   buttonLeft: TextButton(
    //     child: const Text("testOK"),
    //     onPressed: () => debugPrint("it's a test"),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(languageProvider.get("msg"),
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outlined),
            onPressed: () => Navigator.pushNamed(context, "/msg/following"),
          )
        ],
      ),
      // body: Column(
      //   children: [
      //     serviceCard1,
      //     // serviceCard2,
      //     const itemListWidget(type: "user", itemCount: 3),
      //   ],
      // ),
      body: Stack(
        children: [
          badNetwork
              ? Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, size: 36.0),
                      const SizedBox(height: 30),
                      Text(languageProvider.get("loginBadNetwork"),
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      OutlinedButton(
                          onPressed: () async {
                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text("网络未连接"),
                                action: SnackBarAction(
                                  label: "网络检测",
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/server/test"),
                                ),
                              ));
                            } else if (await checkConnectivity() == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    languageProvider.get("loginBadNetwork")),
                                action: SnackBarAction(
                                  label: "网络检测",
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/server/test"),
                                ),
                              ));
                            } else {
                              setState(() {
                                badNetwork = false;
                              });
                              await _getMsgs();
                            }
                          },
                          child: const Text("重试"))
                    ],
                  ),
                )
              : Container(),
          RefreshIndicator(
            onRefresh: () async {
              if (badNetwork) {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  throw Exception("no network");
                } else {
                  setState(() {
                    badNetwork = false;
                  });
                }
              } else {
                await _getMsgs();
              }
            },
            child: !badNetwork
                ? !noMsgs
                    ? FutureBuilder(
                        future: Future.delayed(
                            const Duration(milliseconds: 200), _getMsgs),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            return Center(
                              child: Column(
                                children: [
                                  serviceCard1,
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: msgs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () {
                                            debugPrint(msgs[index].toString());
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConversationsPage(
                                                            userID: userID,
                                                            groupName:
                                                                msgs[index]
                                                                    .groupName,
                                                            groupID: msgs[index]
                                                                .groupID)));
                                          },
                                          leading: generateAvatar(
                                              msgs[index].groupName ?? "N/A",
                                              context),
                                          title: Text(msgs[index].groupName ??
                                              "未命名的聊天"),
                                          subtitle: Text(
                                            msgs[index].messageText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          trailing: Text(formatTimestamp(
                                              msgs[index].timestamp)),
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
                                  ),
                                ],
                              ),
                            );
                        })
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.more_horiz, size: 36.0),
                            const SizedBox(height: 30),
                            Text(languageProvider.get("noMsgs"),
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      )
                : SizedBox.shrink(),
          ),
        ],
      ),
      drawer: const Drawer(),
    );
  }
}
