import 'package:flutter/foundation.dart';

Map<String, List<Map<String, dynamic>>> messages = {
  'en': [
    {
      'type': 'received',
      'message': 'Hello',
    },
    {
      'type': 'received',
      'message': 'Wanna play basketball?',
    },
    {
      'type': 'sent',
      'message': 'Sure! I\'d love to.',
    },
    {
      'type': 'sent',
      'message': 'Can I join in the group?',
    },
    {
      'type': 'received',
      'message': 'OK',
    },
    {
      'type': 'received',
      'message': 'It gonna be near the Fifth Ave.',
    },
    {
      'type': 'sent',
      'message': 'Awesome!',
    },
  ],
  'zh': [
    {
      'type': 'received',
      'message': '你好',
    },
    {
      'type': 'received',
      'message': '今天一起打球吗',
    },
    {
      'type': 'sent',
      'message': '当然，我很乐意！',
    },
    {
      'type': 'sent',
      'message': '把我拉进需求群吧！',
    },
    {
      'type': 'received',
      'message': '好的',
    },
    {
      'type': 'received',
      'message': '我们会在宝龙一城附近',
    },
    {
      'type': 'sent',
      'message': 'okk',
    },
  ]
};

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'zh';

  final Map<String, dynamic> _languages = {
    'zh': {
      // login
      "login": "登录",
      "onekeyLogin": "一键登录",
      "usernameLogin": "手机号",
      "pwdLogin": "密码",
      "loginFailedWithoutPhone": "手机号格式不正确",
      "loginFailedIncorrect": "手机号或密码不正确",
      "unsupportedPlatformConfirm":
          "您正运行在bMapSDK受限支持平台\n（网页、桌面或 Android/iOS 模拟器）",

      // curuserinfo
      "curUserPhone": "13333333333",
      "defaultUserPhone": "13333333333",
      "curUser": "游客",
      "defaultUser": "游客",
      "curUserInfo": "Lv.1 PIN 会员",
      "defaultUserInfo": "开通 PIN 会员",
      "curUserSigning": "闲暇时候打剧本杀的小男孩一枚",
      "defaultUserSigning": "这里是一句签名",

      // someUserProfile
      "someUserProfileFunc_Tag": "备注与标签",
      "someUserProfileFunc_Needs": "和 ta 的需求历史",
      // "someUserProfile_Needs":
      //     "三里屯火锅局 (2023/10/21)\n步道乐跑 (2023/10/20)\n剧本杀有人一起吗 (2023/10/15)\n剧本杀杀杀杀 (2023/9/27)\n剧本杀快上车 (2023/9/24)\n......",
      "someUserProfile_Needs": "...",
      "someUserProfileBtn_invite": "邀请...",
      "someUserProfileBtn_recommend": "推荐给...",
      "someUserProfileBtn_block": "移入黑名单",
      "someUserProfileBtn_follow": "关注",
      "someUserProfileBtn_unfollow": "解除关注",

      // main - navigationitems
      "home": "首页",
      "msg": "消息",
      "my": "我的",

      // home - newOrder
      "newOrder": "发起新需求",
      "newOrderInput": "帮我匹配附近 3km 想一起唱歌的 i 人朋友...",
      "ordering": "需求匹配中...",
      "orderMatched": "匹配成功",
      "orderFailed": "匹配失败",
      "orderCancel?": "确定要取消匹配吗？",
      "orderCancel?sub": "取消后如再次发起匹配，匹配时间可能会延长",

      // home - search
      "searchInput": "搜索...",

      // my - listitems
      "privacy": "隐私政策",
      "help": "帮助中心",
      "setting": "设置",
      "lang": "语言",
      "quit": "退出登录",

      // msg - conversation
      "msgboxhint": "发送新消息...",
      "delfriends": "解除关注",

      // msg
      "user0": "小帅",
      "user0_sub": "我的很大你要忍一下",
      "user1": "小美",
      "user1_sub": "沸羊羊傻逼",
      "user2": "三里屯火锅",
      "user2_sub": "有没有人今晚出来？陈乐洋妈妈今晚出来男人我已经找好了",
      "order0": "今晚出来",
      "order0_sub": "10/22 22:00，房",
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

      // function
      "ok": "好",
      "cancel": "取消",

      // mypage
      "person_data": "修改个人资料",
      "history": "历史需求",
      "account": "注册、登录或使用账号管理功能添加其他账号：",
      "sub_account": "账户昵称、密码、密码保护选项、电子邮箱、手机号码、第三方账号信息",
      "requirement": "发布需求、与其他用户发送信息：",
      "sub_requirement": "发布的内容、位置信息",
      "location": "用于发布需求时，为您提供更精确和个性化的服务",
      "address_book": "发现通讯录好友：通讯录信息",
      "sub_address_book": "通讯录信息",
      "search": "搜索：",
      "sub_search": "关键字信息、搜索历史记录、设备信息",
      "remCache": "清除缓存",
      "removingCache": "清除中",
      "remFailed": "清除失败：请检查存储权限后再试"
    },
    'en': {
      "login": "Sign in",
      "onekeyLogin": "QuickPass",
      "usernameLogin": "Username/Phone",
      "pwdLogin": "Password",
      "unsupportedPlatformConfirm":
          "You are currently on an unsupported platform, some functions will be restricted.",
      "curUser": "Fenn Xiao",
      "curUserInfo": "Lv.1 PinVIP",
      "curUserSigning": "",

      // someUserProfile
      "someUserProfileFunc_Tag": "Tag",
      "someUserProfileFunc_Needs": "Needs",
      "someUserProfileBtn_invite": "Invite...",
      "someUserProfileBtn_recommend": "Recommend to...",
      "someUserProfileBtn_block": "Block",
      "someUserProfileBtn_follow": "Follow",
      "someUserProfileBtn_unfollow": "Unfollow",

      "home": "Home",
      "msg": "Messages",
      "my": "My",
      "newOrder": "Create a new order",
      "newOrderInput": "Search who wanna karaoke now...",
      "ordering": "Matching",
      "orderSuccess": "Pin!",
      "orderFailed": "Failed...",
      "orderCancel?": "Sure to Cancel?",
      "orderCancel?sub": "If you wanna edit your match, press \"Edit\"",
      "searchInput": "Search...",
      "privacy": "Privacy",
      "help": "Help Center",
      "setting": "Settings",
      "quit": "Quit",
      "lang": "Languages",
      "msgboxhint": "Type a message...",
      "delfriends": "Unfollow",
      "user0": "Mike",
      "user0_sub": "Lucky me",
      "user1": "Selina",
      "user1_sub": "Idiots.",
      "user2": "Tuna",
      "user2_sub": "I like playing football and shoot your nuts.",
      "order0": "Luck or Duck?",
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
      "person_data": "Edit Profile",
      "history": "Historical needs",
      "account":
          "Register, log in, or use account management features to add other accounts: ",
      "sub_account":
          "account nickname, password, password protection options, email, phone number, third-party account information",
      "requirement":
          "Publish requirements and send information to other users: ",
      "sub_requirement": " published content and location information",
      "location":
          "To provide you with more precise and personalized services when publishing requirements",
      "address_book": "Discovered contact book friends: ",
      "sub_address_book": "contact book information",
      "search": "Search: ",
      "sub_search": "keyword information, search history, device information",
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

  void set(String key, String value) {
    _languages.update(key, (value) => null, ifAbsent: () => 'default');
  }

  List<dynamic> getMsgList() {
    return _languages[_currentLanguage] ?? _languages["en"];
  }

  // 切换语言
  void switchLanguage() {
    if (_currentLanguage == "zh") {
      _currentLanguage = "en";
    } else {
      _currentLanguage = "zh";
    }
    notifyListeners();
  }

  String getCurLang() {
    return _currentLanguage;
  }
}
