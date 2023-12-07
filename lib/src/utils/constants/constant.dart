class Constant {
  static const bool isDebug = true;
  // TODO: make all constants

  ///手机端和桌面端
  /// base:网页端（待改）
  /// app:app端的接口
  /// search:搜索用到的接口
  /// login:登录时需要用到的接口
  static const Map<String, String> urlMap = {
    "app": "http://app.pin.fennland.me",
    "search": "http://s.pin.fennland.me",
    "login": "https://login.pin.fennland.me",
    "chat-debug": "http://192.168.5.6:3000"
  };

  ///网页端设置代理,处理跨域问题
  static const Map<String, String> urlWebMap = {
    "login": "http://127.0.0.1:8001",
    "search": "http://127.0.0.1:8002",
    "app": "http://127.0.0.1:8003",
  };
}
