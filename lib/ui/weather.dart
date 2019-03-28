import 'package:flutter/material.dart';
import 'package:flutter_mwm/ui/city.dart';
import 'package:flutter_mwm/util/util.dart';
import 'package:flutter_mwm/widget/widget.dart';

class WeatherIndex extends StatefulWidget {
  final String cityName;

  WeatherIndex({this.cityName});

  @override
  State<StatefulWidget> createState() {
    return _WeatherState();
  }
}

class _WeatherState extends State<WeatherIndex> {
  var cName = '西安';

  @override
  void initState() {
    super.initState();
    cName = widget.cityName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF051728),
        centerTitle: true,
        title: Text('天气'),
        actions: <Widget>[_actionView()],
      ),
    );
  }

  /*appBar右侧编辑栏*/
  Widget _actionView() {
    return ClickLayout(
      onPressed: _changeCity,
      child: TextView(
        cName,
        textAlign: TextAlign.center,
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        margin: EdgeInsets.only(right: 10.0),
        alignment: Alignment.center,
        style: TextStyle(color: Colors.green, fontSize: 18.0),
      ),
    );
  }

  //------method-------
  void _changeCity() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CityIndex();
    })).then((value) {
      if (!TextUtils.isEmpty(value)) {
        setState(() {
          cName = value;
        });
      }
    });
  }
}
