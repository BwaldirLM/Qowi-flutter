import 'package:flutter/material.dart';

class BoolButton extends StatefulWidget {
  const BoolButton({Key? key, required this.widget, required this.visible}) : super(key: key);

  final Widget widget;
  final bool visible;


  @override
  _BoolButtonState createState() => _BoolButtonState();
}

class _BoolButtonState extends State<BoolButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _esVisible(),
      child: widget.widget,
    );
  }
}

_esVisible() {

}
