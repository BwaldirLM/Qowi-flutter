import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';

class Carrito with ChangeNotifier{
  final List<CuyModel> _carrito = [];

  List<CuyModel> get carrito =>  _carrito;

  int get cantidad => _carrito.length;

  void agregar(CuyModel cuy){
    if(!_carrito.contains(cuy)) {
      _carrito.add(cuy);
      notifyListeners();
    }
  }
}