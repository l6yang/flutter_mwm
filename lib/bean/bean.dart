import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'bean.g.dart';
//需要在项目根目录运行以下命令--
// flutter packages pub run build_runner build
@JsonSerializable()
class ReturnAccountBean {
  String code;
  String message;
  AccountBean obj;

  ReturnAccountBean({this.code, this.message, this.obj});

  static ReturnAccountBean json2Bean(String result) {
    Map userMap = json.decode(result);
    return ReturnAccountBean.fromJson(userMap);
  }

  factory ReturnAccountBean.fromJson(Map<String, dynamic> json) =>
      _$ReturnAccountBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnAccountBeanToJson(this);
}

@JsonSerializable()
class AccountBean {
  int locked;
  String account;
  String nickname;
  String password;
  String sign;

  AccountBean(
      this.locked, this.account, this.nickname, this.password, this.sign);

  factory AccountBean.fromJson(Map<String, dynamic> json) =>
      _$AccountBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBeanToJson(this);
}
