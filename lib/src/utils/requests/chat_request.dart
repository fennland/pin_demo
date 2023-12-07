import 'package:pin_demo/src/model/custom_result_model.dart';
import 'package:pin_demo/src/model/users_model.dart';
import 'package:pin_demo/src/model/login_model.dart';
import 'package:pin_demo/src/utils/requests/http_base_request.dart';

///聊天功能
class ChatRequest {
  ChatRequest._internal();

  static final ChatRequest _instance = ChatRequest._internal();

  factory ChatRequest() => _instance;

  ///获取用户列表
  Future<UsersModel> getChatUsers() async {
    String url = "/users";
    final result = await HttpBaseRequest().request("", url);
    return UsersModel.fromJson(result);
  }

  ///注册账号
  Future<CustomResultModel> registerUser(params) async {
    String url = "/register";
    final result = await HttpBaseRequest()
        .request("", url, method: "POST", params: params);
    return CustomResultModel.fromJson(result);
  }

  ///登录账号
  Future<LoginModel> loginUser(params) async {
    String url = "/login";
    final result = await HttpBaseRequest()
        .request("", url, method: "POST", params: params);
    return LoginModel.fromJson(result);
  }
}
