import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/venta_detalle_model.dart';
import 'package:qowi/src/providers/venta_provider.dart';

class CarritoProvider with ChangeNotifier{
  final List<CardVenta> _carrito = [];
  final _ventaProvider = VentaProvider();

  List<CardVenta> get carritoProvider =>  _carrito;

  int get cantidad => _carrito.length;

  bool get listo{
    return confirmado();
  }

  void agregar(CuyModel cuy){
    if(!contains(cuy)) {
      _carrito.add(CardVenta(cuy: cuy));
      notifyListeners();
    }
  }
  bool contains(CuyModel cuy){
    bool exist = false;
    _carrito.forEach((cardItem) {
      if(cardItem.cuy.id! == cuy.id!)
        exist = true;
    });
    return exist;
  }

  void delete(int index) {
    _carrito.removeAt(index);
    notifyListeners();
  }

  bool confirmado() {
    //notifyListeners();
    return _carrito.every((element) => element.saved);
  }

  void guardarVenta() async{
    List<CuyModel> cuys = [];
    List<VentaDetalleModel> ventaDetalles = [];
    _carrito.forEach((element) {
      cuys.add(element.cuy);
      ventaDetalles.add(element.ventaDetalleModel!);
    });
    await _ventaProvider.addVenta(cuys, ventaDetalles);
  }

  void clear(){
    _carrito.clear();
    notifyListeners();
  }
}

class CardVenta{
  VentaDetalleModel? ventaDetalleModel;
  CuyModel cuy;
  bool saved;
  
  CardVenta({this.ventaDetalleModel, required this.cuy, this.saved = false}){
    ventaDetalleModel = VentaDetalleModel(
      cuyId: cuy.id,
    );
  }
}