abstract class HttpSubscriberImpl {
  void onResult(int what, Object tag, String result);

  void onError(int what, Object tag, String error);
}