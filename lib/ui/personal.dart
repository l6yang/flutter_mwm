import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_mwm/bean/bean.dart';
import 'package:flutter_mwm/ui/qrcode.dart';
import 'package:flutter_mwm/util/util.dart';
import 'package:flutter_mwm/widget/widget.dart';
import 'package:flutter_mwm/impl/impl.dart';

class PersonalIndex extends StatefulWidget {
  final String beanJson;

  const PersonalIndex({this.beanJson});

  @override
  State<StatefulWidget> createState() {
    return _PersonalIndexState();
  }
}

class _PersonalIndexState extends State<PersonalIndex>
    implements HttpSubscriberImpl {
  var account = '', nickName = '', sign = "", iconUrl = '';
  TextEditingController nickNameController = new TextEditingController();
  TextEditingController signController = new TextEditingController();

  @override
  void initState() {
    if (!TextUtils.isEmpty(widget.beanJson)) {
      AccountBean accountBean = AccountBean.json2Bean(widget.beanJson);
      account = accountBean.account;
      sign = accountBean.sign;
      nickName = accountBean.nickname;
      iconUrl = HttpUtil(context, 'mwmShowIconByIO').getAccountIcon(account);
      sign = TextUtils.isEmpty(sign) ? '这个人很懒...' : sign;
      nickName = TextUtils.isEmpty(nickName) ? account : nickName;
      nickNameController.text = nickName;
      signController.text = TextUtils.isEmpty(sign) ? "" : sign;
    }
    super.initState();
  }

  var _actionEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人资料'),
        backgroundColor: Color(0xFF051728),
        centerTitle: true,
        actions: <Widget>[_actionView()],
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: _iconView(),
              margin: EdgeInsets.only(top: 48.0)),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                _topLeftView('账号'),
                _bottomRightView(account),
                _lineView(),
                _topLeftView('昵称'),
                _bottomNickNameView(nickName),
                _lineView(),
                _topLeftView('签名'),
                _bottomSignView(sign),
                _lineView(),
                _topLeftView('名片'),
                _bottomQrView(),
              ],
            ),
          ),
        ],
      )),
    );
  }

/*appBar右侧编辑栏*/
  Widget _actionView() {
    return ClickLayout(
      onPressed: () => _edit(),
      child: Container(
        child: Image.asset(
          _actionEdit ? 'images/save_white.png' : 'images/edit_white.png',
          width: 32.0,
          height: 32.0,
        ),
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        margin: EdgeInsets.only(right: 10.0),
        alignment: Alignment.center,
      ),
    );
  }

  void _edit() {
    setState(() {
      if (_actionEdit) {
        _update();
      } else {
        _actionEdit = true;
      }
    });
  }

  /*修改信息*/
  void _update() {
    String account = this.account;
    if (TextUtils.isEmpty(account)) {
      ToastUtil.show('用户名不能为空！');
      return;
    }
    String nickName = nickNameController.text;
    nickName = TextUtils.isEmpty(nickName) ? account : nickName;
    String sign = signController.text;
    AccountBean accountBean =
        AccountBean(account: account, nickname: nickName, sign: sign);
    Map<String, String> bodyParams = {
      'beanJson': GsonUtil.bean2Json(accountBean)
    };
    var http = HttpUtil(context, 'mwmUpdateAccount',what: 4, tag: accountBean);
    http.post(bodyParams, this);
  }

/*appBar右侧编辑栏*/
  Widget _iconView() {
    return CircleAvatar(
        radius: 50.0,
        backgroundImage: NetworkImageWithRetry(iconUrl),
        backgroundColor: Colors.green);
  }

  Widget _topLeftView(String text) {
    return TextView(
      text,
      style: TextStyle(fontSize: 16.0, color: Color(0xFF808080)),
      margin: EdgeInsets.only(
        top: 10.0,
      ),
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      alignment: Alignment.bottomLeft,
    );
  }

  /*横线*/
  Widget _lineView() {
    return Line(
      height: 1.0,
      color: Colors.grey[300],
    );
  }

  Widget _bottomNickNameView(String text) {
    return _actionEdit
        ? EditWidget(
            textAlign: TextAlign.end,
            alignment: Alignment.bottomRight,
            controller: nickNameController,
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            style: TextStyle(fontSize: 18.0, color: Color(0xFF808080)))
        : _bottomRightView(text);
  }

  Widget _bottomSignView(String text) {
    var hintStr = TextUtils.isEmpty(text) ? '这个人很懒...' : sign;
    return _actionEdit
        ? EditWidget(
            textAlign: TextAlign.end,
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            alignment: Alignment.bottomRight,
            controller: signController,
            hintText: hintStr,
            style: TextStyle(fontSize: 18.0, color: Color(0xFF808080)))
        : _bottomRightView(text);
  }

  Widget _bottomRightView(String text) {
    return TextView(text,
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        alignment: Alignment.bottomRight,
        style: TextStyle(fontSize: 18.0, color: Colors.black));
  }

  Widget _bottomQrView() {
    return ClickLayout(
      child: Container(
        child: Image.asset(
          'images/qr_pressed.png',
          width: 32.0,
          height: 32.0,
        ),
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        alignment: Alignment.bottomRight,
      ),
      onPressed: _start2QrPage,
    );
  }

  void _start2QrPage() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new QrCodeIndex();
    }));
  }

  void _queryByAccount() {
    Map<String, String> bodyParams = {'account': account};
    var http = HttpUtil(context, 'mwmQueryAccount',what: 2);
    http.post(bodyParams, this);
  }

  @override
  void onResult(int what, Object tag, String result) {
    try {
      print(result);
      switch(what){
        case 2:

          break;
        case 4:
          ReturnBean returnBean = ReturnBean.json2Bean(result);
          if (null == returnBean) {
            return;
          }
          String code = TextUtils.replaceNull(returnBean.code);
          String message = TextUtils.replaceNull(returnBean.message);
          ToastUtil.show(message);
          if (TextUtils.equals("1", code)) {
            AccountBean accountBean = tag;
            setState(() {
              _actionEdit = false;
              nickName = accountBean.nickname;
              sign = accountBean.sign;
            });
          }
          break;
      }
    } catch (error) {
      onError(what, tag, error);
    }
  }

  @override
  void onError(int what, Object tag, String error) {
    DialogUtil(context, error).show();
  }
}
