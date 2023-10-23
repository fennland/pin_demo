import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'zh';

  final Map<String, dynamic> _languages = {
    'zh': {
      "login": "登录",
      "webconfirm": "您正在使用网页版，部分功能将会受限！",
      "curUser": "陈鹏",
      "curUserInfo": "Lv.1 PIN 会员",
      "home": "首页",
      "msg": "消息",
      "my": "我的",
      "newOrder": "发起新需求",
      "privacy": "隐私政策",
      "help": "帮助中心",
      "setting": "设置",
      "lang": "语言",
      "user0": "小帅",
      "user0_sub": "我的很大你要忍一下",
      "user1": "小美",
      "user1_sub": "沸羊羊傻逼",
      "user2": "三里屯火锅",
      "user2_sub": "有没有人今晚出来草比？陈乐洋妈妈今晚出来草比男人我已经找好了",
      "order0": "今晚出来草比",
      "order0_sub": "10/22 22:00，炮房",
      "order1": "剧本杀！有没有人一起",
      "order1_sub": "10/21 14:30，集美 iOi",
      "order2": "一起发传单",
      "order2_sub": "10/22 9:00，云城万科里",
      "order3": "找马拉松搭子",
      "order3_sub": "10/22 14:00，华侨大学",
      "order4": "健康步道有人一起吗",
      "order4_sub": "10/22 19:00，健康步道",
      "service0": "服务通知 #1",
      "service0_sub": "[3.7km] 陈乐洋妈妈发起了“小学生文艺汇演排练”需求群",
      "service1": "服务通知 #2",
      "service1_sub": "[19:30] 您有一项需求即将开始",
      "service2": "服务条款变更通知",
      "service2_sub": "我们正在更新服务条款与隐私政策。\n请点击访问更多信息",
      "ok": "好",
      "cancel": "取消",
      "remCache": "清除缓存",
      "removingCache": "清除中",
      "remFailed": "清除失败：请检查存储权限后再试"
    },
    'en': {
      "login": "Sign in",
      "webconfirm":
          "You are currently using WebApp, some functions will be restricted.",
      "curUser": "Fenn Xiao",
      "curUserInfo": "Lv.1 PinVIP",
      "home": "Home",
      "msg": "Messages",
      "my": "My",
      "privacy": "Privacy",
      "help": "Help Center",
      "setting": "Settings",
      "lang": "Languages",
      "user0": "Mike",
      "user0_sub": "Fuck me bitch",
      "user1": "Selina",
      "user1_sub": "Idiots.",
      "user2": "Tuna",
      "user2_sub": "I like playing football and shoot your nuts.",
      "order0": "Fuck or Duck?",
      "order0_sub": "10/22 22:00, Fifth Ave.",
      "order1": "Thank you, next.",
      "order1_sub": "10/21 14:30, Yuh-riana's Home",
      "order2": "Black Lives Matter!",
      "order2_sub": "10/22 9:00, White Palace",
      "order3": "Runnin' runnin' runnin'",
      "order3_sub": "10/22 14:00, West Coast",
      "order4": "有中国人吗",
      "order4_sub": "10/22 19:00, 南极洲",
      "service0": "Services #1",
      "service0_sub": "[3.7km] Placeholder",
      "service1": "Services #2",
      "service1_sub": "[19:30] You have an upcoming event",
      "service2": "Notice",
      "service2_sub":
          "We are updating our service conditions.\nPlease click for more infomation",
      "ok": "OK ",
      "cancel": "Cancel",
      "remCache": "Clean",
      "removingCache": "Cleaning...",
      "remFailed": "Failed: Please check permission."
    },
  };

  String get currentLanguage => _currentLanguage;

  // 根据键值获取当前语言下的字符串
  String get(String key) {
    return _languages[_currentLanguage][key] ?? 'default';
  }

  // 切换语言
  void switchLanguage(String languageCode) {
    if (_currentLanguage == "zh") {
      _currentLanguage = "en";
    } else {
      _currentLanguage = "zh";
    }
    notifyListeners();
  }
}
