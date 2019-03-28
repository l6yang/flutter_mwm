import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

import '../impl/impl.dart';
import '../widget/widget.dart';

class TextUtils {
  static bool isEmpty(String string) {
    return null == string || string.isEmpty;
  }

  static bool equals(String a, String b) {
    return a == b;
  }

  static String replaceNull(String a) {
    return isEmpty(a) || 'null' == a ? "" : a.trim();
  }
}

class ObjUtils {
  static bool isEmpty(Object obj) {
    return null == obj;
  }
}

class ToastUtil {
  static void show(String toastStr) {
    showGravity(toastStr, ToastGravity.BOTTOM);
  }

  static void showGravity(String toastStr, ToastGravity gravity) {
    showByBgColor(toastStr, gravity, Color(0xffe74c3c));
  }

  static void showByBgColor(
      String toastStr, ToastGravity gravity, Color bgColor) {
    showAll(toastStr, gravity, bgColor, Color(0xffffffff));
  }

  static void showAll(
      String toastStr, ToastGravity gravity, Color bgColor, Color textColor) {
    Fluttertoast.showToast(
        msg: '$toastStr',
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIos: 1,
        backgroundColor: bgColor,
        textColor: textColor);
  }
}

class HttpUtil {
  final Object tag;
  final int what;
  final String baseUrl = 'http://192.168.0.110:8080/mwm/action.do?method=';
  final String method;
  final BuildContext context;

  const HttpUtil(this.context, this.method, {this.what, this.tag})
      : assert(null != method);

  String getAccountIcon(String account) {
    return '$baseUrl$method&account=$account';
  }

  void post(Map<String, String> bodyParams, HttpSubscriberImpl subscriberImpl) {
    try {
      _show('加载中...');
      var client = http.Client();
      client
          .post('$baseUrl$method', body: bodyParams, encoding: Utf8Codec())
          .then((response) {
            _hide();
            /*if (null != subscriberImpl)
                subscriberImpl.onResult(
                    null == what ? 2 : what, tag, response.body);*/
            Future.delayed(Duration(milliseconds: 300), () {
              if (null != subscriberImpl)
                subscriberImpl.onResult(
                    null == what ? 2 : what, tag, response.body);
            });
          })
          .timeout(Duration(seconds: 15))
          .whenComplete(client.close)
          .catchError((error) {
            print('whenComplete--error--${error.toString()}');
            _error(error, subscriberImpl);
          });
    } catch (error) {
      _error(error, subscriberImpl);
    }
  }

  void postMultiple(
      Map<String, String> bodyParams, HttpSubscriberImpl subscriberImpl) {
    var client = http.Client();
    client.post('$baseUrl', body: bodyParams).then((result) {
      _hide();
      if (null != subscriberImpl)
        subscriberImpl.onResult(
            null == what ? 2 : what, tag, result.toString());
    }).catchError((onError) {
      _hide();
      if (null != subscriberImpl)
        subscriberImpl.onError(null == what ? 2 : what, tag, onError);
    }).whenComplete(client.close);
  }

  void _show(String text) {
    if (null != context) {
      showDialog<Null>(
          context: context, //BuildContext对象
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(
              //调用对话框
              TextUtils.isEmpty(text) ? "" : text,
            );
          });
    }
  }

  void _hide() {
    if (null != context) Navigator.pop(context);
    //Navigator.of(context).pop(true);
  }

  void _error(Object error, HttpSubscriberImpl subscriberImpl) {
    _hide();
    Future.delayed(Duration(milliseconds: 300), () {
      if (null != subscriberImpl)
        subscriberImpl.onError(
            null == what ? 2 : what, tag, ConnectUtil.getError(error));
    });
  }
}

//使用dialog或者progressDialog的时候⚠注意全局context和当前控件的context
class DialogUtil {
  final BuildContext context;
  final String message;
  final String btnText;
  final VoidCallback callback;
  final bool outsideDismiss;

  const DialogUtil(this.context, this.message,
      {this.btnText, this.callback, this.outsideDismiss})
      : assert(null != context);

  void show() {
    showDialog<bool>(
      context: context,
      barrierDismissible: null == outsideDismiss ? false : outsideDismiss,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: Text('温馨提示'),
          contentPadding: EdgeInsets.only(left: 24.0, top: 10.0, right: 24.0),
          content: Text(message,
              style: TextStyle(color: Colors.red, fontSize: 18.0)),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.black,
              child: Text(
                TextUtils.isEmpty(btnText) ? "确 定" : btnText,
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                if (null != callback)
                  callback();
                else {
                  //Navigator.of(context).pop(true);
                  dismiss();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void dismiss() {
    if (null != context) Navigator.pop(context);
  }
}

class PreferUtil {
  static Future<Null> set(String key, Object object) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (object is String)
      preferences.setString(key, object);
    else if (object is bool)
      preferences.setBool(key, object);
    else if (object is double)
      preferences.setDouble(key, object);
    else if (object is int)
      preferences.setInt(key, object);
    else if (object is List<String>) preferences.setStringList(key, object);
  }

  static Future<dynamic> get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(key);
  }

  static void clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}

class GsonUtil {
  static String bean2Json(Object obj) {
    if (null == obj) return "{}";
    return json.encode(obj);
  }

  static String list2Json(Object obj) {
    if (null == obj) return "[]";
    return json.encode(obj);
  }
}

class FileUtil {
  static Future<String> getInstance() async {
    Directory parentDir = await getApplicationDocumentsDirectory();
    String path = parentDir.path;
    return path;
  }

  static Future<Directory> createDir(String dirName) async {
    String dirPath = await getInstance();
    Directory parentDir =
        await Directory('$dirPath${Platform.pathSeparator}images')
            .create(recursive: true);
    return parentDir;
  }

  static Future<File> createFile(String filePath, String content) async {
    String dirPath = await getInstance();
    File file = File('$dirPath/$filePath');
    Future<bool> exists = file.exists();
    if (!await exists) {
      file.create(recursive: true);
    }
    file = await file.writeAsString(content, flush: true);
    return file;
  }
}

class PermissionKit {
  static Future<bool> request(Permission permission) async {
    bool res = await SimplePermissions.checkPermission(permission);
    if (res)
      return true;
    else {
      PermissionStatus res =
          await SimplePermissions.requestPermission(permission);
      print("permission request result is " + res.toString());
      return res == PermissionStatus.authorized;
    }
  }
}

class ConnectUtil {
  static String getError(Object error) {
    print('getError=${error.toString()}');
    if (null == error) {
      return "未知异常";
    }
    if (error is SocketException) {
      //error.address;
      return error.osError.message;
    } else if (error is TimeoutException) {
      return '连接服务器超时';
    } else
      return error.toString();
  }
}
