import 'dart:convert';
import 'dart:ui' show Color;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../impl/impl.dart';

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
  final String baseUrl;

  const HttpUtil(this.baseUrl, {this.what, this.tag}) : assert(null != baseUrl);

  void post(Map<String, String> bodyParams, HttpSubscriberImpl subscriberImpl) {
    var client = http.Client();
    client
        .post(baseUrl, body: bodyParams, encoding: Utf8Codec())
        .then((response) {
          if (null != subscriberImpl)
            subscriberImpl.onResult(
                null == what ? 2 : what, tag, response.body);
        })
        .timeout(Duration(seconds: 30))
        .catchError((error) {
          if (null != subscriberImpl)
            subscriberImpl.onError(
                null == what ? 2 : what, tag, error.toString());
        })
        .whenComplete(client.close);
  }

  void postMultiple(
      Map<String, String> bodyParams, HttpSubscriberImpl subscriberImpl) {
    var client = http.Client();
    client.post('$baseUrl', body: bodyParams).then((result) {
      if (null != subscriberImpl)
        subscriberImpl.onResult(
            null == what ? 2 : what, tag, result.toString());
    }).catchError((onError) {
      if (null != subscriberImpl)
        subscriberImpl.onError(null == what ? 2 : what, tag, onError);
    }).whenComplete(client.close);
  }
}
