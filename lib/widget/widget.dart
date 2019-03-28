import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../util/util.dart';

class ClickLayout extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final GestureLongPressCallback onLongPress;
  final Color color;
  final Decoration decoration;

  const ClickLayout({
    this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.onHighlightChanged,
    this.onLongPress,
    this.color,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() {
    return _LayoutState();
  }
}

class _LayoutState extends State<ClickLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.color,
        padding: widget.padding,
        margin: widget.margin,
        decoration: widget.decoration,
        child: InkWell(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            onHighlightChanged: widget.onHighlightChanged,
            child: widget.child));
  }
}

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
    updateBackGround();
    updateTextColor();
    super.initState();
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
class EditText extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final EdgeInsetsGeometry padding;
  final TextEditingController controller;
  final TextStyle style;
  final AlignmentGeometry alignment;
  final TextAlign textAlign;
  final bool showQueryIcon;
  final bool showClearIcon;
  final Decoration decoration;
  final EdgeInsetsGeometry margin;

  const EditText(
      {this.hintText,
      this.obscureText: false,
      this.keyboardType: TextInputType.emailAddress,
      this.controller,
      this.padding,
      this.style,
      this.alignment,
      this.textAlign,
      this.margin,
      this.decoration,
      this.showQueryIcon = false,
      this.showClearIcon = false});

  @override
  State<StatefulWidget> createState() {
    return _EditState();
  }
}

class _EditState extends State<EditText> {
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
      alignment: widget.alignment,
      decoration: widget.decoration,
      padding: widget.padding,
      margin: widget.margin,
      child: TextField(
        onChanged: (String inputText) {
          submitter(inputText);
        },
        controller: widget.controller,
        onSubmitted: submitter,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            //前缀Icon
            prefixIcon: widget.showQueryIcon ? Icon(Icons.search) : null,
            //后缀Icon
            suffixIcon: widget.showClearIcon ? _suffixIcon() : null),
        style: null == widget.style ? _textStyle() : widget.style,
      ),
    );
  }

  Widget _suffixIcon() {
    return IconButton(
      icon: Icon(null == widget.controller ? null : icon),
      onPressed: (() {
        widget.controller.clear();
        submitter('');
      }),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 15.0,
      color: Colors.black,
    );
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
  final AlignmentGeometry alignment;
  final String text;
  final EdgeInsetsGeometry padding, margin;
  final TextStyle style;
  final TextAlign textAlign;
  final Color color;
  final Decoration decoration;

  const TextView(this.text,
      {this.alignment,
      this.padding,
      this.margin,
      this.style,
      this.textAlign,
      this.color,
      this.decoration});

  @override
  State<StatefulWidget> createState() {
    return _TextViewState();
  }
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      decoration: widget.decoration,
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
      ),
      margin: widget.margin,
      padding: widget.padding,
      alignment:
          null == widget.alignment ? Alignment.centerLeft : widget.alignment,
    );
  }
}

class ProgressDialog extends Dialog {
  final String text;
  final Color textColor;

  const ProgressDialog(this.text, {Key key, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        //保证控件居中效果
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              //color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: ObjUtils.isEmpty(textColor)
                            ? Colors.blueAccent
                            : textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MwmDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MwmDialog();
  }
}

class _MwmDialog extends State<MwmDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Builder(builder: (BuildContext context) {
      return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.chat),
                              title: Text("开始会话"),
                            ),
                            ListTile(
                              leading: Icon(Icons.help),
                              title: Text("操作说明"),
                            ),
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text("系统设置"),
                            ),
                            ListTile(
                              leading: Icon(Icons.more),
                              title: Text("更多设置"),
                            ),
                          ],
                        )));
              });
        },
        child: Icon(Icons.add),
      );
    }));
  }
}
