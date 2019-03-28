import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_mwm/ui/weather.dart';
import '../ui/personal.dart';
import '../ui/qrcode.dart';
import '../bean/bean.dart';
import '../impl/impl.dart';
import '../util/util.dart';
import '../widget/widget.dart';

class MainIndex extends StatefulWidget {
  final String beanJson;

  const MainIndex({this.beanJson});

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainIndex> implements HttpSubscriberImpl {
  var account = '', sign = "", iconUrl = '';
  var cityName = '西安';

  @override
  void initState() {
    if (!TextUtils.isEmpty(widget.beanJson)) {
      AccountBean accountBean = AccountBean.json2Bean(widget.beanJson);
      account = accountBean.account;
      sign = accountBean.sign;
    }
    super.initState();
    iconUrl = HttpUtil(context, 'mwmShowIconByIO').getAccountIcon(account);
  }

  @override
  Widget build(BuildContext context) {
    String signStr = TextUtils.isEmpty(sign) ? "此人很懒..." : sign;
    Color color = TextUtils.isEmpty(sign) ? Colors.grey[300] : Colors.white;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF051728),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF051728)),
                accountName: Text(account),
                accountEmail: Text(
                  signStr,
                  style: TextStyle(color: color),
                ),
                otherAccountsPictures: <Widget>[
                  _qrView(),
                ],
                currentAccountPicture: _iconView(),
              ),
              _menuView('1', null),
              _flexView(),
              _weatherView(),
            ],
          ),
        ),
        body: Container(
          child: Text('MainIndex'),
        ));
  }

/*圆形头像*/
  Widget _iconView() {
    return ClickLayout(
        child: CircleAvatar(
            radius: 150.0,
            backgroundImage: TextUtils.isEmpty(account)
                ? AssetImage('images/icon.png')
                : NetworkImageWithRetry(iconUrl),
            backgroundColor: Colors.green),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PersonalIndex(
              beanJson: widget.beanJson,
            );
          })).then((value) {
            //onActivityResult之后
            //重新加载用户头像
            setState(() {
              iconUrl =
                  HttpUtil(context, 'mwmShowIconByIO').getAccountIcon(account);
              _queryByAccount(context);
            });
          });
        });
  }

  void _queryByAccount(BuildContext context) {
    Map<String, String> bodyParams = {'account': account};
    var http = HttpUtil(context, 'mwmQueryAccount');
    http.post(bodyParams, this);
  }

  var imgUrl = 'images/qr_normal.png';

  /*二维码*/
  Widget _qrView() {
    return ClickLayout(
        child: Image.asset(imgUrl),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return QrCodeIndex();
          }));
        },
        onHighlightChanged: (bool changed) {
          setState(() {
            imgUrl = changed ? 'images/qr_pressed.png' : 'images/qr_normal.png';
          });
        });
  }

  /*侧滑菜单*/
  Widget _menuView(String text, VoidCallback callBack) {
    return ClickLayout(
      child: Text(text),
      onPressed: callBack,
    );
  }

  /*用来将weatherView放置在右下角*/
  Widget _flexView() {
    return Expanded(
      child: Text(''),
    );
  }

  /*底部天气☁️*/
  Widget _weatherView() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        child: ClickLayout(
            onPressed: _weather,
            child: Column(
              children: <Widget>[
                TextView(
                  '-2˚',
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(bottom: 4.0),
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
                ),
                TextView(
                  cityName,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  textAlign: TextAlign.right,
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                  alignment: Alignment.centerRight,
                ),
              ],
            )),
      ),
    ]);
  }

  void _weather() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return WeatherIndex();
    })).then((value) {
      if (!TextUtils.isEmpty(value)) {
        setState(() {
          cityName = value;
        });
      }
    });
  }

  @override
  void onResult(int what, Object tag, String result) {
    try {
      ReturnAccountBean returnAccountBean = ReturnAccountBean.json2Bean(result);
      if (null == returnAccountBean) {
        return;
      }
      String code = returnAccountBean.code;
      String message = returnAccountBean.message;
      if (!TextUtils.equals("1", code)) {
        ToastUtil.show(message);
        return;
      }
      AccountBean accountBean = returnAccountBean.obj;
      setState(() {
        sign = accountBean.sign;
        //widget.beanJson=GsonUtil.bean2Json(accountBean);
      });
    } catch (error) {
      onError(what, tag, error);
    }
  }

  @override
  void onError(int what, Object tag, String error) {
    DialogUtil(context, error).show();
  }
}
