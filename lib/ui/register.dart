import 'package:flutter/material.dart';
import '../widget/widget.dart';

class RegisterIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterIndexState();
  }
}

class _RegisterIndexState extends State<RegisterIndex> {
  TextEditingController accountController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nicknameController = new TextEditingController();
  TextEditingController repeatController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: ListView(children: <Widget>[
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
                          new EditClearWidget(
                            hintText: '账号名称(仅限数字和字母)',
                            controller: accountController,
                          ),
                          new Line(height: 1.0, color: Color(0xFF00cccc)),
                          new EditClearWidget(
                            hintText: '昵称(可不填，默认使用账号名称)',
                            controller: nicknameController,
                          ),
                          new Line(height: 1.0, color: Color(0xFF00cccc)),
                          new EditClearWidget(
                              keyboardType: TextInputType.emailAddress,
                              hintText: '用户密码',
                              obscureText: true,
                              controller: passwordController),
                          new Line(height: 1.0, color: Color(0xFF00cccc)),
                          new EditClearWidget(
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
                        margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                        padding: EdgeInsets.all(10.0),
                        defaultColor: Color(0xFF3d6488),
                        highlightColor: Color(0xFF3d7999),
                        defaultTextColor: Color(0xFF0099CC),
                        highlightTextColor: Colors.white,
                        fontSize: 18.0,
                        onPressed: press2Login)
                  ],
                )
              ],)),
        )

        /*
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        )),*/

        );
  }

  void press2Login() {
    print('login');
  }

  void press2ResetPassword() {
    print('resetPassword');
  }

  void press2Register() {
    print('register');
  }
}
