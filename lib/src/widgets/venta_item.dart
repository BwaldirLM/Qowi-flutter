import 'package:flutter/material.dart';
import 'package:qowi/src/models/venta_detalle_model.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';

class VentaItem extends StatefulWidget {
  const VentaItem(
      {required this.size,
      required this.cardVenta,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final Size size;
  final CardVenta cardVenta;
  final Function() onPressed;

  @override
  VentaItemState createState() => VentaItemState();
}

class VentaItemState extends State<VentaItem> {
  late int selectedRadioTile;
  late TextEditingController controller;
  late bool _saved;
  late VentaDetalleModel ventaDetalle;
  late double precio;

  bool get saved {
    return _saved;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadioTile =
        widget.cardVenta.ventaDetalleModel!.proposito == 'recria' ? 1 : 2;
    controller = TextEditingController(text: '20')
      ..text = '${widget.cardVenta.ventaDetalleModel!.precio ?? ''}';
    _saved = widget.cardVenta.saved;
    ventaDetalle = widget.cardVenta.ventaDetalleModel!;
    precio = widget.cardVenta.ventaDetalleModel!.precio ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(5, 5))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: widget.size.width * 0.1,
            child: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _saved ? null : widget.onPressed),
          ),
          SizedBox(
            width: widget.size.width * 0.3,
            child: Text(widget.cardVenta.cuy.tipo!),
          ),
          SizedBox(
            width: widget.size.width * 0.4,
            child: Column(
              children: [
                TextFormField(
                  initialValue: precio < 0 ? '' : precio.toString(),
                  //controller: controller,
                  //initialValue: widget.cardVenta.ventaDetalleModel!.precio.toString(),
                  readOnly: _saved,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ingrese el precio',
                      labelText: 'Precio',
                      prefixText: 'S/. '),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (p) => precio = double.parse(p),
                ),
                RadioListTile(
                  value: 1,
                  groupValue: selectedRadioTile,
                  onChanged: (value) {
                    if (!saved) setSelectedRadioTile(value as int);
                  },
                  title: Text('Recria'),
                  autofocus: true,
                ),
                RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTile,
                    onChanged: (value) {
                      if (!saved) setSelectedRadioTile(value as int);
                    },
                    title: Text('Consumo')),
                ElevatedButton(
                    onPressed: _save,
                    child: _saved ? Text('Confirmado') : Text('Confirmar'),
                    style: ElevatedButton.styleFrom(
                        primary: _saved ? Colors.lightGreen : Colors.blue))
              ],
            ),
          )
        ],
      ),
    );
  }

  void setSelectedRadioTile(int value) {
    setState(() {
      selectedRadioTile = value;
    });
  }

  void _save() {
    //print(controller.text);
    //print(selectedRadioTile);
    if (!precio.isNegative && selectedRadioTile != 0) {
      ventaDetalle.precio = precio;

      ventaDetalle.proposito = selectedRadioTile.isOdd ? 'recria' : 'consumo';
      setState(() {
        if (_saved)
          _saved = false;
        else
          _saved = true;
      });
      widget.cardVenta.saved = _saved;
    }
  }
}
