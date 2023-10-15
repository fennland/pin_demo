import 'package:flutter/material.dart';
import 'src/mainPages/msgpage.dart';
import 'src/mainPages/mypage.dart';
import 'src/mainPages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一起拼',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   '/home':(context) => MyHomePage(),
      //   '/msg':(context) => msgPage(),
      //   '/my':(context) => myPage(),
      // }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final bodyList = [homePage(), msgPage(), myPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("首页")),
      body: IndexedStack(index: _currentIndex, children: bodyList),
      drawer: Drawer(),
      bottomNavigationBar: _NavigationBar(),
    );
  }

NavigationBar _NavigationBar() {
    return NavigationBar(
      destinations: const[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '首页',
        ),
        NavigationDestination(
          icon: Icon(Icons.messenger_outline_outlined),
          selectedIcon: Icon(Icons.messenger),
          label: '消息',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: '我的',
        ),
      ],
      selectedIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
        // switch(_currentIndex){
        //   case 0:
        //     // Navigator.of(context).pushNamed('/home',arguments: _currentIndex);
        //     break;
        //   case 1:
        //     Navigator.of(context).pushNamed('/msg',arguments: _currentIndex);
        //     break;
        //   case 2:
        //     Navigator.of(context).pushNamed('/my',arguments: _currentIndex);
        //     break;
        // }
      },
    );
  }
}

