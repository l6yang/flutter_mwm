import 'package:flutter/material.dart';
import './widget/widget.dart';
import './ui/login.dart';

void main() => runApp(new MwMApp());

class MwMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          // accentColor: Colors.white FloatingActionButton真是通过这种方式找到accentColor
          ),
      home: new SplashHome(),
      title: 'MwM',
    );
  }
}

class SplashHome extends StatefulWidget {
  @override
  State createState() => new _SplashHomeState();
}

class _SplashHomeState extends State<SplashHome> {
  var hasStarted = false;

  @override
  void initState() {
    super.initState();
    startThread();
  }

  void hasStartedNextPage() {
    setState(() {
      hasStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/splash_background.jpg',
                  ),
                  fit: BoxFit.fill),
            ),
            child: TimeDownView(
              '跳 过',
              onPressed: () {
                toNextPage();
              },
            )));
  }

  void startThread() {
    var duration = Duration(seconds: 3);
    if (!hasStarted) new Future.delayed(duration, toNextPage);
  }

  void toNextPage() {
    hasStartedNextPage();
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new LoginIndex();
    }), (route) => route == null);
  }
}

class TimeDownView extends StatefulWidget {
  final String data;
  final VoidCallback onPressed;

  const TimeDownView(this.data, {@required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return _TimeDownState();
  }
}

class _TimeDownState extends State<TimeDownView> {
  @override
  Widget build(BuildContext context) {
    return Button(
      widget.data,
      style: TextStyle(color: Color(0xff808080), fontSize: 18.0),
      onPressed: widget.onPressed,
      radius: 8.0,
      margin: EdgeInsets.all(30.0),
      border: Border.all(
        width: 2.0,
        color: Color(0xff003355),
      ),
      padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
    );
  }
}