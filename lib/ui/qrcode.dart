import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mwm/bean/bean.dart';
import 'package:flutter_mwm/util/util.dart';
import 'package:flutter_mwm/widget/widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class QrCodeIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrCodeIndexIndexState();
  }
}

class _QrCodeIndexIndexState extends State<QrCodeIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的二维码'),
        backgroundColor: Color(0xFF051728),
        centerTitle: true,
        actions: <Widget>[_actionView()],
      ),
      body: Center(
        child: ClickLayout(child: _qrView(), onLongPress: () => _action()),
      ),
    );
  }

  //-----------View-------------

  var _actionUrl = 'images/menu_white.png';

  /*标题栏action*/
  Widget _actionView() {
    return ClickLayout(
        onPressed: () => _action(),
        margin: EdgeInsets.only(right: 10.0),
        child: Container(
          color: Color(0xFF051728),
          alignment: Alignment.center,
          child: Image.asset(_actionUrl),
          width: 32.0,
          height: 32.0,
        ),
        onHighlightChanged: (bool changed) {
          setState(() {
            _actionUrl =
                changed ? 'images/menu_grey8a.png' : 'images/menu_white.png';
          });
        });
  }

  QrImage qrView;

  /*二维码*/
  Widget _qrView() {
    /*qrView = QrImage(
      data: 'test',
      size: 256.0,
      onError: (error) {
        print(error);
      },
    );
    return qrView;*/
    return QrImage(
      data: 'test',
      size: 256.0,
      onError: (error) {
        print(error);
      },
    );
  }

  Widget _line() {
    return Line(
      color: Colors.grey[300],
      height: 1,
    );
  }

  Widget _bottomItemMenu(String menuText, {GestureTapCallback itemCallback}) {
    return ListTile(
      dense: true,
      title: TextView(
        menuText,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
      onTap: itemCallback,
    );
  }

  //---------method---------

  void _action() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _bottomItemMenu('保存到手机', itemCallback: (() {
                Navigator.pop(context);
                _saveQrImage();
              })),
              _line(),
              _bottomItemMenu('扫一扫', itemCallback: (() {
                Navigator.pop(context);
                _startQr();
              })),
              _line(),
              _bottomItemMenu("分享", itemCallback: () {
                Navigator.pop(context);
                ToastUtil.show('暂未实现，请耐心等候！');
              })
            ],
          );
        });
  }

  /*保存二维码*/
  void _saveQrImage() {
    FileUtil.createDir('images').then((file) {
      print('file.existsSync()--${file.existsSync()}');
      file.exists().then((bool success) {
        print("file.exists()--$success");
      });
      print(file.path);
    });
    FileUtil.createFile('txt/text.txt', "what's your name？\n and you？")
        .then((file) {
      print(file.readAsStringSync());
      print(file.path);
    });
  }

  void _startQr() {
    Navigator.pop(context);
    _start2Qr().then((ReturnBean resultBean) {
      String code = null == resultBean ? '' : resultBean.code;
      String message = null == resultBean ? '' : resultBean.message;
      if (!TextUtils.equals('1', code)) {
        DialogUtil(
                context, TextUtils.isEmpty(message) ? "解析失败，请重新扫描！" : message)
            .show();
        return;
      }
      ToastUtil.show('$message');
    });
  }
}

/*扫一扫*/
Future<ReturnBean> _start2Qr() async {
  Map<String, dynamic> map = {};
  /*这块不能用{'code':'',message:''},如果用的话，下面需要用
      map.update("code", (dynamic value){
       value="";
     });
     map.update("message", (dynamic value){
       value="";
     });
     */
  try {
    String barcode = await BarcodeScanner.scan();
    map.putIfAbsent('code', () => '1');
    map.putIfAbsent('message', () => barcode);
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      map.putIfAbsent('code', () => '-1');
      map.putIfAbsent(
          'message', () => 'The user did not grant the camera permission!');
    } else {
      map.putIfAbsent('code', () => '-1');
      map.putIfAbsent('message', () => 'Unknown error: $e');
    }
  } on FormatException {
    map.putIfAbsent('code', () => '-1');
    map.putIfAbsent(
        'message',
        () =>
            'null (User returned using the "back"-button before scanning anything. Result)');
  } catch (e) {
    map.putIfAbsent('code', () => '-1');
    map.putIfAbsent('message', () => 'Unknown error: $e');
  }
  return ReturnBean.fromJson(map);
}
