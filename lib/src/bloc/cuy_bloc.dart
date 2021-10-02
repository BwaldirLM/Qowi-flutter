import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:rxdart/rxdart.dart';

class CuyBloc{
  final _cuyController = BehaviorSubject<List<CuyModel>>();
  final _madresController = BehaviorSubject<List<CuyModel>>();
  final _contadorController = BehaviorSubject<int>();
  final _tipoController = BehaviorSubject<String>();


  final _cuyProvider = CuyProvider();

  Stream<List<CuyModel>> get cuyStream => _cuyController.stream;
  Stream<List<CuyModel>> get cuyMadreSytream => _madresController.stream;
  Stream<int> get contadorStream => _contadorController.stream;
  Stream<String> get tipoStream => _tipoController.stream;

  int get contadorValue => _contadorController.value;
  String get tipoValue => _tipoController.value;

  //void Function(String?)? get changeTipo => _tipoController.sink.add;

  void cargarCuys()async{
    final cuys = await _cuyProvider.cargarCuys();
    _cuyController.sink.add(cuys);
  }

  void cargarCuysContenedor(int contenedor)async{
    final cuys = await _cuyProvider.cargarCuysContenedor(contenedor);
    _cuyController.sink.add(cuys);
  }

  void addCuy(CuyModel cuy)async{
    await _cuyProvider.addCuy(cuy);
     cargarCuysContenedor(cuy.contenedor!);
  }

  void cargarCuysMadre()async{
    final cuys = await _cuyProvider.cargarCuysMadres();
    _madresController.sink.add(cuys);
  }

  void incrementar(int count){
    _contadorController.sink.add(count);
  }

  void changeTipo(String tipo){
    _tipoController.sink.add(tipo);
  }

  dispose(){
    _cuyController.close();
    _madresController.close();
    _contadorController.close();
    _tipoController.close();

  }
}