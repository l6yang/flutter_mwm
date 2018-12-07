import '../lib/bean/bean.dart';
import 'dart:convert';

void main() {
  String jsonStr =
      '{"code":"1","obj":{"account":"loyal","password":"111111","nickname":"loyal","sign":"y","locked":0}}';
  print(jsonStr);
  var user = ReturnAccountBean.json2Bean(jsonStr);
  print(json.encode(user.obj));
}
