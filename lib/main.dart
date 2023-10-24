import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pin_demo/src/login/platformAlert.dart';
import 'package:pin_demo/src/msgPages/conversations.dart';
import 'package:pin_demo/src/orderPages/newOrder.dart';
import 'package:pin_demo/src/strings/lang.dart';
import 'package:pin_demo/src/utils.dart';
import 'package:window_manager/window_manager.dart';
import 'src/mainPages/msgpage.dart';
import 'src/mainPages/mypage.dart';
import 'src/mainPages/home.dart';
import 'src/login/login.dart';
import 'dart:io' show Platform;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;
import 'package:provider/provider.dart';

Future<void> main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      await windowManager.ensureInitialized();
      WindowUtil.setWindowFunctions(isMacOS: Platform.isMacOS);
    }
    runApp(const MyApp());
  }

  // 百度地图sdk初始化鉴权
  if (!kIsWeb && !Platform.isMacOS) {
    LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
    BMFMapSDK.setAgreePrivacy(true);
    myLocPlugin.setAgreePrivacy(true);
    if (Platform.isIOS) {
      if (!Platform.isMacOS) {
        myLocPlugin.authAK('bet57swQG0pxa7esLl9a12Vkmc7GtcAi');
        BMFMapSDK.setApiKeyAndCoordType(
            'bet57swQG0pxa7esLl9a12Vkmc7GtcAi', BMF_COORD_TYPE.BD09LL);
      }
    } else if (Platform.isAndroid) {
      /// 初始化获取Android 系统版本号，如果低于10使用TextureMapView 等于大于10使用Mapview
      await BMFAndroidVersion.initAndroidVersion();
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider(),
      child: MaterialApp(
          title: '一起拼',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          // home: const MyHomePage(),
          debugShowCheckedModeBanner: false,
          // supportedLocales: const [
          //   // TODO: Localization 类替换多语言方案
          //   Locale('zh'),
          //   Locale('en'),
          // ],
          routes: {
            /**
         * 命名导航路由，启动程序默认打开的是以'/'对应的界面LoginScreen()
         * 凡是后面使用Navigator.of(context).pushNamed('/Home')，都会跳转到Home()，
         */
            '/login': (BuildContext context) => const loginPage(),
            '/home': (BuildContext context) => const MyHomePage(),
            '/msg': (BuildContext context) => const msgPage(),
            '/my': (BuildContext context) =>
                const myPage(), // TODO: navigationbar重构
            '/': (BuildContext context) => const platformAlert(),
            '/msg/conversations': (BuildContext context) =>
                ConversationsPage(username: "TestUser"), // TODO: userName传导
            '/order/new': (BuildContext context) => const newOrderPage(),
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  int _currentIndex = 0;
  final bodyList = [const homePage(), const msgPage(), const myPage()];
  @override
  void initState() {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      windowManager.addListener(this);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false; // 禁止侧滑返回
      },
      child: Scaffold(
        // appBar: AppBar(title: Text(languageProvider.get(currentPage[_currentIndex]))),
        body: IndexedStack(index: _currentIndex, children: bodyList),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: languageProvider.get("home"),
            ),
            NavigationDestination(
              icon: const Icon(Icons.messenger_outline_outlined),
              selectedIcon: const Icon(Icons.messenger),
              label: languageProvider.get("msg"),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outlined),
              selectedIcon: const Icon(Icons.person),
              label: languageProvider.get("my"),
            ),
          ],
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
