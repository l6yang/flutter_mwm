import 'package:flutter/material.dart';
import 'package:flutter_mwm/ui/city.dart';

import './util/util.dart';
import './widget/widget.dart';

void main() => runApp(MwMApp());

class MwMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // accentColor: Colors.white FloatingActionButton真是通过这种方式找到accentColor
          ),
      home: SplashHome(),
      title: 'MwM',
    );
  }
}

class SplashHome extends StatefulWidget {
  @override
  State createState() => _SplashHomeState();
}

class _SplashHomeState extends State<SplashHome> {
  var state = "";
  var duration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    startThread();
  }

  void hasStartedNextPage() {
    setState(() {
      state = "started";
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
                print("start2Login");
                toNextPage();
              },
            )));
  }

  void startThread() {
    Future.delayed(duration, toNextPage);
  }

  void toNextPage() {
    if (TextUtils.isEmpty(state)) {
      hasStartedNextPage();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return /*LoginIndex()*/
          CityIndex();
      }), (route) => route == null);
    }
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
