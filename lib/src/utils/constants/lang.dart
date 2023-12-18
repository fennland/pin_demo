import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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
      "register": "注册",
      "onekeyLogin": "注册或登录",
      "username": "用户名",
      "gender": "性别",
      "gender_female": "女",
      "gender_male": "男",
      "usernameLogin": "手机号",
      "pwdLogin": "密码",
      "loginFailedWithoutPhone": "手机号格式不正确",
      "loginFailedIncorrect": "手机号或密码不正确",
      "loginNoSuchUser": "用户不存在",
      "loginBadNetwork": "网络状态差，请稍后重试",
      "loginBadNetworkTest": "网络测试",
      "registerAlreadyHaveSuchUser": "已存在此用户，请尝试登录",
      "registerSuccess": "注册成功！",
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
      "nearby_orders": "附近需求",
      "newOrder": "发起新需求",
      "newOrder_button": "一起拼！",
      "newOrder_description": "需求描述",
      "newOrder_description_hint": "附近有人想一起唱歌吗？...",
      "newOrder_orderName": "需求名称",
      "newOrder_orderName_hint": "快来一起唱歌吧",
      "newOrder_location": "需求位置",
      "newOrder_location_hint": "华侨大学厦门校区...",
      "ordering": "匹配...",
      "orderMatched": "匹配成功",
      "orderFailed": "匹配失败",
      "orderCancel?": "确定要取消匹配吗？",
      "orderCancel?sub": "取消后如再次发起匹配，匹配时间可能会延长",
      "orderInfoInitiator": "发起人",
      "orderInfoParticipants": "参与者",

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
      "leaveMsg": "离开此聊天",
      "conversations_info": "需求群详情",

      // msg
      "noMsgs": "还没有信息呢，快加入需求群吧！",
      "service0": "服务通知 #1",
      "service0_sub": "[3.7km] 陈乐洋妈妈发起了“小学生文艺汇演排练”需求群",
      "service1": "服务通知 #2",
      "service1_sub": "[19:30] 您有一项需求即将开始",
      "service2": "服务条款变更通知",
      "service2_sub": "我们正在更新服务条款与隐私政策。\n请点击访问更多信息",

      // function
      "ok": "好",
      "cancel": "取消",

      // mypages - person_data
      "person_data": "修改个人资料",

      // mypages - privacy
      "privacy_policy": "隐私政策",
      "account": "注册、登录或使用账号管理功能添加其他账号：",
      "sub_account": "账户昵称、密码、密码保护选项、电子邮箱、手机号码、第三方账号信息",
      "requirement": "发布需求、与其他用户发送信息：",
      "sub_requirement": "发布的内容、位置信息",
      "location": "用于发布需求时，为您提供更精确和个性化的服务",
      "address_book": "发现通讯录好友：通讯录信息",
      "sub_address_book": "通讯录信息",
      "search": "搜索：",
      "sub_search": "关键字信息、搜索历史记录、设备信息",

      // mypages - privacy
      "follow_list": "关注列表",

      // mypages - settings
      "settings": "设置",
      "account_management": "账号管理",
      "account_and_security": "账号与安全",
      "push_notification_settings": "推送通知设置",
      "general_settings": "通用设置",
      "customer_service_center": "客服中心",
      "remCache": "清除缓存",
      "removingCache": "清除中",
      "remFailed": "清除失败：请检查存储权限后再试"
    },
    'en': {
      "login": "Sign in",
      "nearby_orders": "Orders Nearby",
      "register": "Sign up",
      "onekeyLogin": "Register or Login",
      "username": "Username",
      "gender": "Gender",
      "gender_female": "Female",
      "gender_male": "Male",
      "usernameLogin": "Phone",
      "pwdLogin": "Password",
      "loginFailedWithoutPhone": "Bad Format of Phone Number or Password",
      "loginFailedIncorrect": "Incorrect",
      "loginNoSuchUser": "No such user",
      "loginBadNetwork": "Bad network connection...",
      "loginBadNetworkTest": "Test Net",
      "registerAlreadyHaveSuchUser": "User already Exists",
      "registerSuccess": "Successfully Registered",
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
      "newOrder_button": "Pin!",
      "newOrder_description": "Description",
      "newOrder_description_hint": "Anyone who wanna karaoke now? ...",
      "newOrder_orderName": "Order Name",
      "newOrder_orderName_hint": "Karaoke NOW!!",
      "newOrder_location": "Location",
      "newOrder_location_hint": "Huaqiao University (Xiamen)",
      "newOrderInput": "Search who wanna karaoke now...",
      "ordering": "Matching",
      "orderSuccess": "Pin!",
      "orderFailed": "Failed...",
      "orderCancel?": "Sure to Cancel?",
      "orderCancel?sub": "If you wanna edit your match, press \"Edit\"",
      "orderInfoInitiator": "Initiator",
      "orderInfoParticipants": "Participants",
      "searchInput": "Search...",
      "privacy": "Privacy",
      "help": "Help Center",
      "setting": "Settings",
      "quit": "Quit",
      "lang": "Languages",
      "msgboxhint": "Type a message...",
      "leaveMsg": "Unfollow",
      "conversations_info": "Order Info",
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
      "noMsgs": "No messages...",
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
      "privacy_policy": "Privacy Policy",
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
      "follow_list": "follow list",
      "settings": "settings",
      "account_management": "account management",
      "account_and_security": "account and security",
      "push_notification_settings": "push notification settings",
      "general_settings": "general settings",
      "customer_service_center": "customer service center",
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
      Intl.defaultLocale = 'en_US';
    } else {
      _currentLanguage = "zh";
      Intl.defaultLocale = 'zh_CN';
    }
    notifyListeners();
  }

  String getCurLang() {
    return _currentLanguage;
  }
}
