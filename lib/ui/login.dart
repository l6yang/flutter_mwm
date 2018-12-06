import 'package:flutter/material.dart';
import '../widget/widget.dart';
import '../ui/register.dart';
import '../util/util.dart';
import '../impl/impl.dart';
import '../bean/bean.dart';
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
                        EditClearWidget(
                          hintText: '用户账号(仅限数字和字母)',
                          controller: accountController,
                        ),
                        Line(height: 1.0, color: Color(0xFF00cccc)),
                        EditClearWidget(
                            keyboardType: TextInputType.emailAddress,
                            hintText: '用户密码',
                            obscureText: true,
                            controller: passwordController),
                        Line(height: 1.0, color: Color(0xFF00cccc)),
                        EditClearWidget(
                            hintText: '服务器接入地址', controller: ipController)
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
                            onPressed: start2ResetPassword,
                          ),
                          Button(
                            "立即注册",
                            radius: 0.0,
                            margin: EdgeInsets.all(0.0),
                            padding: EdgeInsets.all(8.0),
                            defaultTextColor: Color(0xFF0099CC),
                            highlightTextColor: Color(0xFF0066CC),
                            fontSize: 18.0,
                            onPressed: press2Register,
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
                          onPressed: start2Login)
                    ],
                  )
                ],
              ),
            )));
  }

  void start2Login() {
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
    //login
    var url = 'http://192.168.0.110:8080/mwm/action.do?method=mwmLoginWithJson';
    print(url);
    Map<String, String> bodyParams = {
      'account': account,
      'password': password,
    };
    HttpUtil(url).post(bodyParams, this);
  }

  void start2ResetPassword() {
    print('resetPassword');
  }

  void press2Register() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new RegisterIndex();
    }));
  }

  @override
  void onResult(int what, Object tag, String result) {
    print(result);
    ToastUtil.show(result);
    //ResultBean<String> resultBean=ResultBean.f
  }

  @override
  void onError(int what, Object tag, String error) {
    ToastUtil.show(error);
  }
}
