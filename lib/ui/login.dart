import 'package:flutter/material.dart';
import 'package:flutter_mwm/ui/main.dart';

import '../bean/bean.dart';
import '../impl/impl.dart';
import '../ui/register.dart';
import '../util/util.dart';
import '../widget/widget.dart';

class LoginIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginIndexState();
  }
}

class _LoginIndexState extends State<LoginIndex> implements HttpSubscriberImpl {
  TextEditingController accountController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController ipController = new TextEditingController();

  @override
  void initState() {
    _getShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/splash_background.jpg',
                  ),
                  fit: BoxFit.fill),
            ),
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height / 2),
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF003355), width: 3.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        EditText(
                          showClearIcon: true,
                          padding: EdgeInsets.only(left: 8.0),
                          hintText: '用户账号(仅限数字和字母)',
                          controller: accountController,
                        ),
                        Line(height: 1.0, color: Color(0xFF00cccc)),
                        EditText(
                          showClearIcon: true,
                            padding: EdgeInsets.only(left: 8.0),
                            keyboardType: TextInputType.emailAddress,
                            hintText: '用户密码',
                            obscureText: true,
                            controller: passwordController),
                        Line(height: 1.0, color: Color(0xFF00cccc)),
                        EditText(
                            showClearIcon: true,
                            padding: EdgeInsets.only(left: 8.0),
                            hintText: '服务器接入地址',
                            controller: ipController)
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Button(
                            "忘记密码？",
                            radius: 0.0,
                            margin: EdgeInsets.all(0.0),
                            padding: EdgeInsets.all(8.0),
                            defaultTextColor: Color(0xFF0099CC),
                            highlightTextColor: Color(0xFF0066CC),
                            fontSize: 18.0,
                            onPressed: _start2ResetPassword,
                          ),
                          Button(
                            "立即注册",
                            radius: 0.0,
                            margin: EdgeInsets.all(0.0),
                            padding: EdgeInsets.all(8.0),
                            defaultTextColor: Color(0xFF0099CC),
                            highlightTextColor: Color(0xFF0066CC),
                            fontSize: 18.0,
                            onPressed: _press2Register,
                          )
                        ],
                      )),
                  Row(
                    children: <Widget>[
                      ExpandedButton("登  录",
                          radius: 8.0,
                          margin:
                              EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                          padding: EdgeInsets.all(10.0),
                          defaultColor: Color(0xFF3d6488),
                          highlightColor: Color(0xFF3d7999),
                          defaultTextColor: Color(0xFF0099CC),
                          highlightTextColor: Colors.white,
                          fontSize: 18.0,
                          onPressed: _login)
                    ],
                  )
                ],
              ),
            )));
  }

  void _login() {
    String account = accountController.text;
    if (TextUtils.isEmpty(account)) {
      ToastUtil.show('用户名不能为空！');
      return;
    }
    String password = passwordController.text;
    if (TextUtils.isEmpty(password)) {
      ToastUtil.show('密码不能为空！');
      return;
    }
    AccountBean accountBean = AccountBean(account: account, password: password);
    Map<String, String> bodyParams = {
      'beanJson': GsonUtil.bean2Json(accountBean)
    };
    var http = HttpUtil(context, 'mwmLogin');
    http.post(bodyParams, this);
  }

  void _start2ResetPassword() {
    print('resetPassword');
  }

  void _press2Register() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RegisterIndex();
    })).then((value) {
      if (!TextUtils.isEmpty(value)) {
        accountController.text = value;
        passwordController.text = '';
      }
    });
  }

  @override
  void onResult(int what, Object tag, String result) {
    try {
      print(result);
      ReturnAccountBean resultBean = ReturnAccountBean.json2Bean(result);
      if (null == resultBean) {
        DialogUtil(context, "数据格式错误或未返回数据！").show();
        return;
      }
      var code = resultBean.code;
      var message = resultBean.message;
      var accountBean = resultBean.obj;
      if (TextUtils.equals("1", code)) {
        String json = GsonUtil.bean2Json(accountBean);
        print('json#$json');
        PreferUtil.set("accountJson", json);
        //intentBuilder.putExtra("account", account);
        _start2Main(json);
        //intentBuilder.setAction(StrImpl.actionDownload);
        //ImageService.startAction(activity, intentBuilder);
      } else
        DialogUtil(context, message).show();
    } catch (error) {
      onError(what, tag, error.toString());
    }
  }

  void _start2Main(String beanJson) {
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new MainIndex(
        beanJson: beanJson,
      );
    }), (route) => route == null);
  }

  @override
  void onError(int what, Object tag, String error) {
    print('override--onError----$error');
    DialogUtil(context, error).show();
  }

  void _getShared() {
    PreferUtil.get("accountJson").then((accountJson) {
      print("PreferUtil--$accountJson");
      if (!TextUtils.isEmpty(accountJson)) {
        AccountBean accountBean = AccountBean.json2Bean(accountJson);
        accountController.text = accountBean.account;
        passwordController.text = accountBean.password;
      }
    });
  }
}
