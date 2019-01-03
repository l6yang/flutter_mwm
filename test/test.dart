import '../lib/bean/bean.dart';
import 'dart:convert';

void main() {
  String jsonStr =
      '{"code":"1","obj":{"account":"loyal","password":"111111","nickname":"loyal","sign":"y","locked":0}}';
  print(jsonStr);
  var user = ReturnAccountBean.json2Bean(jsonStr);
  print(json.encode(user.obj));
  Map<String,dynamic> map={
  };

  map.putIfAbsent("code", ()=>"-1");
  map.putIfAbsent("message", ()=>"fail");
  map.putIfAbsent("obj", ()=>"error");
 ReturnBean returnBean= ReturnBean.fromJson(map);
 print(returnBean.code);
 print(returnBean.message);
}
