import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';

class Carrito with ChangeNotifier{
  final List<CuyModel> _carrito = [];

  List<CuyModel> get carrito =>  _carrito;

  int get cantidad => _carrito.length;

  void agregar(CuyModel cuy){
    if(!contains(cuy)) {
      _carrito.add(cuy);
      notifyListeners();
    }
  }
  bool contains(CuyModel cuy){
    bool exist = false;
    _carrito.forEach((cuyItem) {
      if(cuyItem.id! == cuy.id!)
        exist = true;
    });
    return exist;
  }

  void delete(CuyModel cuy) {
    _carrito.remove(cuy);
    notifyListeners();
  }
}