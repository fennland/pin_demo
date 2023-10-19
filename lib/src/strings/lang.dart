String lang = "zh-CN";

class langStrings {
  String lang;
  langStrings(this.lang);

  String get(String request) {
    if (lang == "zh-CN") {
      return zhCN[request] ?? "default";
    } else if (lang == "en-US") {
      return enUS[request] ?? "default";
    } else {
      return zhCN[request] ?? "default";
    }
  }

  Map<String, String> zhCN = {
    "home": "首页",
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
  };

  Map<String, String> enUS = {
    "home": "Home",
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
  };
}
