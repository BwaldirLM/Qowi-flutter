import 'package:rxdart/rxdart.dart';

class SeleccionarBloc{
  final _seleccionarController = BehaviorSubject<bool>();

  Stream<bool> get seleccionarStream => _seleccionarController.stream;

  void setState(bool state){
    _seleccionarController.sink.add(state);
  }
  dispose(){
    _seleccionarController.close();
  }
}