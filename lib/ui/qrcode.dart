import 'package:flutter/material.dart';

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
      ),
      body: Center(child: Image.asset('images/icon.png'),),
    );
  }
}
