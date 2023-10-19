import 'zh-CN.dart';

class strings {
  String region;
  strings(this.region);

  String get(String request){
    if(region == "zh-CN"){
      return zhCNStrings().zhCN[request] ?? "default";
    }
    else if(region == "en-US"){
      return zhCNStrings().zhCN[request] ?? "default";
    }
    else{
      return zhCNStrings().zhCN[request] ?? "default";
    }
  }
  
}
