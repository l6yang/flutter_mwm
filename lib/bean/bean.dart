abstract class Result<T> {
  //String get code;
  T getObj();

  void setObj(T e);
}

abstract class ResultBean<T> {
  String get code;

  String get message;

  T get obj;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'code': code, 'message': message, 'obj': obj};
}
