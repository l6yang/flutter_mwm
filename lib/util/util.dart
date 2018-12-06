import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../impl/impl.dart';

class TextUtils {
  static bool isEmpty(String string) {
    return null == string || string.isEmpty;
  }
}

class ToastUtil {
  static void show(String toastStr) {
    showGravity(toastStr, ToastGravity.BOTTOM);
  }

  static void showGravity(String toastStr, ToastGravity gravity) {
    showByBgColor(toastStr, gravity, "#e74c3c");
  }

  static void showByBgColor(
      String toastStr, ToastGravity gravity, String bgColor) {
    showAll(toastStr, gravity, '#e74c3c', '#ffffff');
  }

  static void showAll(
      String toastStr, ToastGravity gravity, String bgColor, String textColor) {
    Fluttertoast.showToast(
        msg: '$toastStr',
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIos: 1,
        bgcolor: '$bgColor',
        textcolor: '$textColor');
  }
}

class HttpUtil {
  final Object tag;
  final int what;
  final String baseUrl;

  const HttpUtil(this.baseUrl, {this.what, this.tag}) : assert(null != baseUrl);

  void post(Map<String, String> bodyParams, HttpSubscriberImpl subscriberImpl) {
    var client = http.Client();
    client.post(baseUrl, body: bodyParams).then((response) {
      if (null != subscriberImpl)
        subscriberImpl.onResult(
            null == what ? 2 : what, tag, response.body);
    }).catchError((error) {
      if (null != subscriberImpl)
        subscriberImpl.onError(null == what ? 2 : what, tag, error.toString());
    }).whenComplete(client.close);
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
