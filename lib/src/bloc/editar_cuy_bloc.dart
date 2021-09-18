import 'package:qowi/src/models/cuy_model.dart';
import 'package:rxdart/rxdart.dart';

class EditarCuyBLoc{
  final _editarCuyBloc = BehaviorSubject<bool>();
  final _cuyBloc = BehaviorSubject<CuyModel>();

  Stream<bool> get editarCuyStream => _editarCuyBloc.stream;
  Stream<CuyModel> get cuyStream => _cuyBloc.stream;

  Function(bool) get changeEditState  => _editarCuyBloc.sink.add;

  void editar(){
    _editarCuyBloc.sink.add(true);
  }

  void noEditar(){
    _editarCuyBloc.sink.add(false);
  }

  void cargarCuy(CuyModel cuy) {
    _cuyBloc.sink.add(cuy);
  }

  void cambiarNombre(CuyModel? cuy){
    _cuyBloc.sink.add(cuy!);
  }

  dispose(){
    _editarCuyBloc.close();
    _cuyBloc.close();
  }


}