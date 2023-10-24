import 'package:flutter/foundation.dart';

String lang = "zh-CN";

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'zh-CN';

  Map<String, dynamic> _languages = {
    'zh-CN': {
      "home": "首页",
      "msg": "消息",
      "my": "我的",
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
      "ok": "好",
      "cancel": "取消",
      "person_data":"修改个人资料",

      "history":"历史需求",
      "account":"注册、登录或使用账号管理功能添加其他账号：",
      "sub_account":"账户昵称、密码、密码保护选项、电子邮箱、手机号码、第三方账号信息",
      "requirement":"发布需求、与其他用户发送信息：",
      "sub_requirement":"发布的内容、位置信息",
      "location":"用于发布需求时，为您提供更精确和个性化的服务",
      "address_book":"发现通讯录好友：通讯录信息",
      "sub_address_book":"通讯录信息",
      "search":"搜索：",
      "sub_search":"关键字信息、搜索历史记录、设备信息",
    },
    'en-US': {
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
      "ok": "OK ",
      "cancel": "Cancel",
      "person_data":"Edit Profile",

      "history":"Historical needs",
      "account":"Register, log in, or use account management features to add other accounts: ",
      "sub_account":"account nickname, password, password protection options, email, phone number, third-party account information",
      "requirement":"Publish requirements and send information to other users: ",
      "sub_requirement":" published content and location information",
      "location":"To provide you with more precise and personalized services when publishing requirements",
      "address_book":"Discovered contact book friends: ",
      "sub_address_book":"contact book information",
      "search":"Search: ",
      "sub_search":"keyword information, search history, device information",
    },
  };

  String get currentLanguage => _currentLanguage;

  // 根据键值获取当前语言下的字符串
  String get(String key) {
    return _languages[_currentLanguage][key] ?? 'default';
  }

  // 切换语言
  void switchLanguage(String languageCode) {
    if (_currentLanguage == "zh-CN")
      _currentLanguage = "en-US";
    else
      _currentLanguage = "zh-CN";
    notifyListeners();
  }
}

// class langStrings {
//   String lang;
//   langStrings(this.lang);

//   String get(String request) {
//     if (lang == "zh-CN") {
//       return zhCN[request] ?? "default";
//     } else if (lang == "en-US") {
//       return enUS[request] ?? "default";
//     } else {
//       return zhCN[request] ?? "default";
//     }
//   }

//   Map<String, String> zhCN = {
//     "home": "首页",
//     "privacy": "隐私政策",
//     "help": "帮助中心",
//     "setting": "设置",
//     "lang": "语言",
//     "user0": "小帅",
//     "user0_sub": "我的很大你要忍一下",
//     "user1": "小美",
//     "user1_sub": "沸羊羊傻逼",
//     "user2": "三里屯火锅",
//     "user2_sub": "有没有人今晚出来草比？陈乐洋妈妈今晚出来草比男人我已经找好了",
//     "order0": "今晚出来草比",
//     "order0_sub": "10/22 22:00，炮房",
//     "order1": "剧本杀！有没有人一起",
//     "order1_sub": "10/21 14:30，集美 iOi",
//     "order2": "一起发传单",
//     "order2_sub": "10/22 9:00，云城万科里",
//     "order3": "找马拉松搭子",
//     "order3_sub": "10/22 14:00，华侨大学",
//     "order4": "健康步道有人一起吗",
//     "order4_sub": "10/22 19:00，健康步道",
//     "ok": "好",
//     "cancel": "取消",
//     "history":"历史需求",
//     "account":"注册、登录或使用账号管理功能添加其他账号：账户昵称、密码、密码保护选项、电子邮箱、手机号码、第三方账号信息",
//     "requirement":"发布需求、与其他用户发送信息：发布的内容、位置信息",
//     "location":"用于发布需求时，为您提供更精确和个性化的服务",
//     "address_book":"用于发布需求时，为您提供更精确和个性化的服务",
//     "search":"搜索：关键字信息、搜索历史记录、设备信息",
//   };

//   Map<String, String> enUS = {
//     "home": "Home",
//     "privacy": "Privacy",
//     "help": "Help Center",
//     "setting": "Settings",
//     "lang": "Languages",
//     "user0": "Mike",
//     "user0_sub": "Fuck me bitch",
//     "user1": "Selina",
//     "user1_sub": "Idiots.",
//     "user2": "Tuna",
//     "user2_sub": "I like playing football and shoot your nuts.",
//     "order0": "Fuck or Duck?",
//     "order0_sub": "10/22 22:00, Fifth Ave.",
//     "order1": "Thank you, next.",
//     "order1_sub": "10/21 14:30, Yuh-riana's Home",
//     "order2": "Black Lives Matter!",
//     "order2_sub": "10/22 9:00, White Palace",
//     "order3": "Runnin' runnin' runnin'",
//     "order3_sub": "10/22 14:00, West Coast",
//     "order4": "有中国人吗",
//     "order4_sub": "10/22 19:00, 南极洲",
//     "ok": "OK ",
//     "cancel": "Cancel",
//   };
  
// }
