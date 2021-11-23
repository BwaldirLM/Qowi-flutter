import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';

class CuyItem extends StatefulWidget {
  final CuyModel cuy;
  final bool isSelected;
  final bool seleccionar;
  final Color color;
  final VoidCallback? onLongPress;
  const CuyItem({
    Key? key,
    required this.cuy,
    this.isSelected = false,
    this.color = Colors.transparent,
    required this.seleccionar,
    this.onLongPress
  }) : super(key: key);

  @override
  CuyItemState createState() => CuyItemState();
}

class CuyItemState extends State<CuyItem> {
  late bool _isSelected;
  late Color _color;
  late bool _seleccionar;
  late CuyModel _cuy;

  bool get isSelected => _isSelected;
  set isSelected(bool value){
    setState(() {
      _isSelected = value;
    });
  }

  Color get color => _color;
  set color(Color newColor){
    setState(() {
      _color = newColor;
    });
  }

  bool get seleccionar => _seleccionar;
  set seleccionar(bool value){
    setState(() {
      _seleccionar = value;
    });
  }



  CuyModel get cuy => _cuy;

  void _changeColor(){
    isSelected = !_isSelected;
    color = isSelected ? Color(0xFFDCEDC8): widget.color;
  }

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _color = widget.color;
    _seleccionar = widget.seleccionar;
    _cuy = widget.cuy;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: _color,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
          children: [
            Image(
                image: AssetImage('assets/cuy_detalle.png'),
                fit: BoxFit.cover
            ),
            Text(widget.cuy.nombre??'${widget.cuy.tipo}')
          ],
        ),
      ),
      onTap: () => widget.seleccionar? _changeColor() :
        Navigator.pushNamed(context, 'cuy', arguments: widget.cuy),
      onLongPress: widget.onLongPress,
    );
  }
}
