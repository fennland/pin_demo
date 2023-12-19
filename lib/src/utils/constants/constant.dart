class Constant {
  static const bool isDebug = true;

  static const Map<String, String> urlMap = {
    "app": "https://pin.fennland.me/",
    "search": "https://pin.fennland.me/search",
    "login": "https://pin.fennland.me/user/login",
    // "chat-debug": "http://192.168.5.6:3000"
  };

  ///网页端设置代理,处理跨域问题
  static const Map<String, String> urlWebMap = {
    // "login": "http://s.pin.fennland.me:5000/user/login",
    // "logined": "http://s.pin.fennland.me:5000/user/logined",
    // "register": "http://s.pin.fennland.me:5000/user/register",
    // "get_user": "http://s.pin.fennland.me:5000/user/get/",
    // "new_order": "http://s.pin.fennland.me:5000/orders/new",
    // "join_order": "http://s.pin.fennland.me:5000/orders/join",
    // "surrounding_order": "http://s.pin.fennland.me:5000/orders/get",
    // "get_order": "http://s.pin.fennland.me:5000/orders/get",
    // "msg_get": "http://s.pin.fennland.me:5000/orders/msg/get",
    // "new_msg": "http://s.pin.fennland.me:5000/orders/msg/new",
    // "order": "http://s.pin.fennland.me:5000/orders",
    // "order_match_distances": "http://s.pin.fennland.me:5000/orders/distance",
    // "database": "http://s.pin.fennland.me:5000/database",
    // "hello": "http://s.pin.fennland.me:5000/hello"
    "login": "http://124.223.116.195:5000/user/login",
    "logined": "http://124.223.116.195:5000/user/logined",
    "register": "http://124.223.116.195:5000/user/register",
    "get_user": "http://124.223.116.195:5000/user/get/",
    "new_order": "http://124.223.116.195:5000/orders/new",
    "join_order": "http://124.223.116.195:5000/orders/join",
    "surrounding_order": "http://124.223.116.195:5000/orders/get",
    "get_order": "http://124.223.116.195:5000/orders/get",
    "msg_get": "http://124.223.116.195:5000/orders/msg/get",
    "new_msg": "http://124.223.116.195:5000/orders/msg/new",
    "order": "http://124.223.116.195:5000/orders",
    "order_match_distances": "http://124.223.116.195:5000/orders/distance",
    "order_distance": "http://124.223.116.195:5000/orders/distance/get",
    "database": "http://124.223.116.195:5000/database",
    "hello": "http://124.223.116.195:5000/hello",

    "defaultAvatar": "http://s.pin.fennland.me:5000/static/avatar.jpeg",
    // "search": "http://127.0.0.1:8002",
    // "app": "http://127.0.0.1:8003",
  };
}
