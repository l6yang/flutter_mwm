import 'package:flutter/material.dart';
import '../widget/widget.dart';
import '../util/util.dart';
import '../impl/impl.dart';
import '../bean/bean.dart';

class RegisterIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterIndexState();
  }
}

class _RegisterIndexState extends State<RegisterIndex>
    implements HttpSubscriberImpl {
  TextEditingController accountController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nicknameController = new TextEditingController();
  TextEditingController repeatController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color lineColor = Color(0xFF00CCCC);
    return Scaffold(
        appBar: AppBar(
          title: Text('快速注册'),
          backgroundColor: Color(0xFF051728),
          centerTitle: true,
        ),
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
                      child: Container(
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
                          hintText: '账号名称(仅限数字和字母)',
                          controller: accountController,
                        ),
                        Line(height: 1.0, color: lineColor),
                        EditText(
                          showClearIcon: true,
                          padding: EdgeInsets.only(left: 8.0),
                          hintText: '昵称(可不填，默认使用账号名称)',
                          controller: nicknameController,
                        ),
                        Line(height: 1.0, color: lineColor),
                        EditText(
                            showClearIcon: true,
                            padding: EdgeInsets.only(left: 8.0),
                            keyboardType: TextInputType.emailAddress,
                            hintText: '用户密码',
                            obscureText: true,
                            controller: passwordController),
                        Line(height: 1.0, color: lineColor),
                        EditText(
                            showClearIcon: true,
                            padding: EdgeInsets.only(left: 8.0),
                            keyboardType: TextInputType.emailAddress,
                            hintText: '再次输入密码',
                            obscureText: true,
                            controller: repeatController)
                      ],
                    ),
                  )),
                  Row(
                    children: <Widget>[
                      ExpandedButton("立即注册",
                          radius: 8.0,
                          margin:
                              EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                          padding: EdgeInsets.all(10.0),
                          defaultColor: Color(0xFF3d6488),
                          highlightColor: Color(0xFF3d7999),
                          defaultTextColor: Color(0xFF0099CC),
                          highlightTextColor: Colors.white,
                          fontSize: 18.0,
                          onPressed: _press2Register)
                    ],
                  )
                ],
              )),
        ));
  }

  void _press2Register() {
    String account = accountController.text;
    if (TextUtils.isEmpty(account)) {
      ToastUtil.show("请输入用户名！");
      return;
    }
    String password = passwordController.text;
    if (TextUtils.isEmpty(password)) {
      ToastUtil.show("请输入密码！");
      return;
    }
    String repeat = repeatController.text;
    if (!TextUtils.equals(password, repeat)) {
      ToastUtil.show("两次输入密码不一致");
      return;
    }
    String nickName = nicknameController.text;
    AccountBean accountBean = AccountBean(
      account: account,
      password: password,
      nickname: nickName,
    );
    Map<String, String> bodyParams = {
      'beanJson': GsonUtil.bean2Json(accountBean)
    };
    var http = HttpUtil(context, 'mwmRegister', tag: account);
    http.post(bodyParams, this);
  }

  @override
  void onResult(int what, Object tag, String result) {
    try {
      ReturnAccountBean resultBean = ReturnAccountBean.json2Bean(result);
      if (null == resultBean) {
        DialogUtil(context, "数据格式错误或未返回数据").show();
        return;
      }
      String code = resultBean.code;
      String message = resultBean.message;
      if (!TextUtils.equals("1", code)) {
        DialogUtil(context, message).show();
      } else {
        ToastUtil.show('注册成功！');
        String account = tag;
        Future.delayed(Duration(milliseconds: 1500), _setResult(account));
      }
    } catch (error) {
      onError(what, tag, error.toString());
    }
  }

  Null _setResult(String account) {
    Navigator.pop(context, account);
  }

  @override
  void onError(int what, Object tag, String error) {
    DialogUtil(context, error).show();
  }
}
