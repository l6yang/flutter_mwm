import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Button
class Button extends StatefulWidget {
  final String data;
  final Color defaultColor;
  final Color highlightColor;
  final Color defaultTextColor;
  final Color highlightTextColor;
  final double radius, fontSize;
  final BoxBorder border;
  final TextStyle style;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;

  const Button(this.data,
      {@required this.onPressed,
      this.padding,
      this.margin,
      this.defaultColor,
      this.highlightColor,
      this.defaultTextColor,
      this.highlightTextColor,
      this.radius: 2.0,
      this.fontSize,
      this.border,
      this.decoration,
      this.style});

  @override
  State<StatefulWidget> createState() {
    return _ButtonState();
  }
}

class _ButtonState extends State<Button> {
  Color backGround, textColor; //=  widget.defaultColor;
  bool pressed = false;

  void updateBackGround() {
    setState(() {
      backGround = pressed ? widget.highlightColor : widget.defaultColor;
    });
  }

  void updateTextColor() {
    setState(() {
      textColor = pressed ? widget.highlightTextColor : widget.defaultTextColor;
    });
  }

  @override
  void initState() {
    super.initState();
    //Color defaultColor = widget.defaultColor;
    //Color high = widget.highlightColor;
    //print('$pressed  ::$defaultColor  ::$high');
    updateBackGround();
    updateTextColor();
  }

  @override
  Widget build(BuildContext context) {
    /* return  InkWell(
      onTap: widget.onPressed,
      highlightColor: Colors.blue,
      child:  Container(
          padding: widget.padding,
          color: widget.color,
          decoration: widget.decoration,
          margin: widget.margin,
          child:  Text(
            widget.data,
            textAlign: TextAlign.center,
            style: widget.style,
          )),
    );*/
    return Container(
        padding: null == widget.padding ? EdgeInsets.all(5.0) : widget.padding,
        decoration: null == widget.decoration
            ? BoxDecoration(
                color: backGround,
                border: widget.border,
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)))
            : widget.decoration,
        margin: null == widget.margin ? EdgeInsets.all(5.0) : widget.margin,
        child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (bool changed) {
              this.pressed = changed;
              updateBackGround();
              updateTextColor();
            },
            highlightColor: widget.highlightColor,
            child: Text(
              widget.data,
              textAlign: TextAlign.center,
              style: null == widget.style
                  ? TextStyle(color: textColor, fontSize: widget.fontSize)
                  : widget.style,
            )));
  }
}

//Line
class Line extends StatelessWidget {
  final double height;
  final Color color;

  const Line({this.height: 3.0, this.color}) : assert(height >= 0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
    );
  }
}

//List
class ListWidget extends StatefulWidget {
  final String data;

  const ListWidget(this.data);

  @override
  State<StatefulWidget> createState() {
    return _ListState();
  }
}

class _ListState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    String title = widget.data;
    return Scaffold(
      appBar:
          null == title ? null : AppBar(title: Text(title), centerTitle: true),
      body: Column(
        children: <Widget>[
          Line(height: 1.0, color: Colors.white),
          Container(
            child: _MainTitleText(),
            color: const Color(0xff067ff0),
          ),
          Line(height: 1.0, color: Colors.white),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) {
                  return Line(height: 1.0, color: Colors.green);
                }
                return Text('$index');
              },
              itemCount: 50,
            ),
          )
        ],
      ),
    );
  }
}

class _MainTitleText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTitleState();
  }
}

class _MainTitleState extends State<_MainTitleText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _TitleText(
          '号牌号码',
          lineWidth: 0.0,
        ),
        _TitleText(
          '所有人',
          lineWidth: 1.0,
        ),
        _TitleText(
          '录入时间',
          lineWidth: 1.0,
        ),
      ],
    );
  }
}

class _TitleText extends StatefulWidget {
  final String data;
  final double lineWidth;

  const _TitleText(this.data, {this.lineWidth});

  @override
  State<StatefulWidget> createState() {
    return _TitleTextState();
  }
}

class _TitleTextState extends State<_TitleText> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: Text(
              widget.data,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: widget.lineWidth, color: Colors.white)))));
  }
}

//Dialog
class DialogWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DialogState();
  }
}

class _DialogState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            //Navigator.pop(context, Department.treasury);
          },
          child: const Text('Treasury department'),
        ),
        SimpleDialogOption(
          onPressed: () {
            //Navigator.pop(context, Department.state);
          },
          child: const Text('State department'),
        ),
      ],
    );
  }
}

/*带有清除的输入框*/
class EditClearWidget extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final EdgeInsetsGeometry padding;
  final TextEditingController controller;
  final TextStyle style;

  const EditClearWidget(
      {this.hintText,
      this.obscureText: false,
      this.keyboardType: TextInputType.emailAddress,
      this.controller,
      this.padding,
      this.style});

  @override
  State<StatefulWidget> createState() {
    return _EditClearState();
  }
}

class _EditClearState extends State<EditClearWidget> {
  bool iconVisible = false;
  IconData icon;

  void submitter(String text) {
    iconVisible = null != text && text.isNotEmpty;
    updateIcons();
  }

  void updateIcons() {
    setState(() {
      icon = iconVisible ? Icons.close : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: null == widget.padding
            ? EdgeInsets.only(left: 8.0)
            : widget.padding,
        child: Row(children: <Widget>[
          Flexible(
              child: TextField(
            onChanged: (String inputText) {
              submitter(inputText);
            },
            controller: widget.controller,
            onSubmitted: submitter,
            obscureText: widget.obscureText,
            decoration: InputDecoration.collapsed(hintText: widget.hintText),
            style: null == widget.style
                ? TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  )
                : widget.style,
          )),
          Container(
              child: IconButton(
                  icon: Icon(null == widget.controller ? null : icon),
                  onPressed: () {
                    widget.controller.clear();
                    submitter('');
                  }))
        ]));
  }
}

/*对话框*/
class ProgressWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProgressState();
  }
}

class _ProgressState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

//Expanded 充满布局
class ExpandedButton extends StatefulWidget {
  final String data;
  final Color defaultColor;
  final Color highlightColor;
  final double radius, fontSize;
  final BoxBorder border;
  final TextStyle style;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color defaultTextColor;
  final Color highlightTextColor;
  final VoidCallback onPressed;

  const ExpandedButton(
    this.data, {
    this.defaultColor,
    this.highlightColor,
    this.radius = 2.0,
    this.fontSize,
    this.border,
    this.style,
    this.decoration,
    this.padding,
    this.margin,
    this.defaultTextColor,
    this.highlightTextColor,
    @required this.onPressed,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExpandedButtonState();
  }
}

/*Button*/
class _ExpandedButtonState extends State<ExpandedButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(widget.data,
          onPressed: widget.onPressed,
          margin: widget.margin,
          padding: widget.padding,
          radius: widget.radius,
          decoration: widget.decoration,
          defaultColor: widget.defaultColor,
          fontSize: widget.fontSize,
          highlightColor: widget.highlightColor,
          defaultTextColor: widget.defaultTextColor,
          highlightTextColor: widget.highlightTextColor,
          style: widget.style),
    );
  }
}

class TextView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextViewState();
  }
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class ProgressDialog extends StatefulWidget {
  final String loadingText;
  final Color textColor;
  final bool outSideTouch;

  const ProgressDialog(this.loadingText, {this.outSideTouch, this.textColor}):assert(null!=loadingText);

  @override
  State<StatefulWidget> createState() {
    return _ProgressDialogState();
  }
}

class _ProgressDialogState extends State<ProgressDialog> {
  bool gone = false;
  bool outSideCancel = true;

  @override
  void initState() {
    gone = false;
    outSideCancel = widget.outSideTouch == null ? true : widget.outSideTouch;
    super.initState();
  }

  void updateState() {
    setState(() {
      if (this.outSideCancel) {
        gone = !gone;
      } else {}
    });
  }

  void onDismiss() {
    gone = true;
  }

  void onDismissListener() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onDismissListener,
        child: Offstage(
            offstage: gone,
            child: Container(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue)),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.loadingText,
                          style: TextStyle(
                              inherit: false,
                              color: Colors.white,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
