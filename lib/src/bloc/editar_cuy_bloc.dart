import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:rxdart/rxdart.dart';

class EditarCuyBLoc{
  final _editarCuyBloc = BehaviorSubject<bool>();
  final _cuyBloc = BehaviorSubject<CuyModel>();
  final _menuController = BehaviorSubject<bool>();
  final _incidenciaController = BehaviorSubject<String>();

  final _cuyProvider = CuyProvider();

  Stream<bool> get editarCuyStream => _editarCuyBloc.stream;
  Stream<CuyModel> get cuyStream => _cuyBloc.stream;
  Stream<bool> get menuStream => _menuController.stream;
  Stream<String> get incidenciaStream => _incidenciaController.stream;

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

  void updateCuy(CuyModel cuy){
    _cuyProvider.updateCuy(cuy);
  }

  void cambiarMenu(bool valor){
    _menuController.sink.add(valor);
  }
  void changeIncidencia(String opt) {
    _incidenciaController.sink.add(opt);
  }
  void newIncidencia(CuyModel cuy, String incidencia) async {
    await _cuyProvider.newIncidencia(cuy, incidencia);
  }

  dispose(){
    _editarCuyBloc.close();
    _cuyBloc.close();
    _menuController.close();
    _incidenciaController.close();
  }






}