import 'package:flutter/material.dart';
import 'package:flutter_mwm/widget/widget.dart';

class CityIndex extends StatefulWidget {
  final String cityName;

  CityIndex({
    this.cityName = '西安',
  });

  @override
  State<StatefulWidget> createState() {
    return _CityState();
  }
}

class _CityState extends State<CityIndex> {
  TextEditingController cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF051728),
        centerTitle: true,
        title: Text('选择城市'),
      ),
      body: ListView(
        children: <Widget>[
          EditText(
            showClearIcon: true,
            controller: cityController,
            hintText: '--------------',
            showQueryIcon: false,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
          //ScrollView(),
          Row(
            children: <Widget>[_cityView(), _flexView(), _slideView()],
          )
        ],
      ),
    );
  }

  Widget _cityView() {
    List<Widget> list = List();
    for (int i = 0; i < 40; i++) {
      list.add(_itemSlideView(i.toString()));
    }
    return Column(children: list,);
  }

  /*用来将weatherView放置在右下角*/
  Widget _flexView() {
    return Expanded(
      child: Text(''),
    );
  }

//---------View--------
  Widget _slideView() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: _listSlideView(),
      ),
    );
  }

  List<Widget> _listSlideView() {
    List<String> array = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    List<Widget> list = List();
    int length = array.length;
    for (int i = 0; i < length; i++) {
      list.add(_itemSlideView(array.elementAt(i)));
    }
    return list;
  }

  Widget _itemSlideView(String data) {
    return Text(
      data,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: TextStyle(color: Colors.black, fontSize: 15.0),
    );
  }

  //------method-------
  void _changeCity() {}
}
