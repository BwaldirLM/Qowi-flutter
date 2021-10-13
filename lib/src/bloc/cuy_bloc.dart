import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:qowi/src/providers/galpon_provider.dart';
import 'package:rxdart/rxdart.dart';

class CuyBloc{
  final _cuyController = BehaviorSubject<List<CuyModel>>();
  final _madresController = BehaviorSubject<List<CuyModel>>();
  final _contadorController = BehaviorSubject<int>();
  final _tipoController = BehaviorSubject<String>();
  final _sellecionarController = BehaviorSubject<bool>();
  final _galponController = BehaviorSubject<List<GalponModel>>();
  final _contenedoresController = BehaviorSubject<List<ContenedorModel>>();
  final _contenedorController = BehaviorSubject<ContenedorModel>();


  final _cuyProvider = CuyProvider();
  final _galponProvider = GalponProvider();

  Stream<List<CuyModel>> get cuyStream => _cuyController.stream;
  Stream<List<CuyModel>> get cuyMadreSytream => _madresController.stream;
  Stream<int> get contadorStream => _contadorController.stream;
  Stream<String> get tipoStream => _tipoController.stream;
  Stream<bool> get seleccionarStream => _sellecionarController.stream;
  Stream<List<GalponModel>> get galponStream => _galponController.stream;
  Stream<List<ContenedorModel>> get contenedoresStream => _contenedoresController.stream;
  Stream<ContenedorModel> get contenedorStream =>_contenedorController.stream;

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

  void updateCuy(CuyModel cuy)async{
    await _cuyProvider.updateCuy(cuy);
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

  void changeSeleccionar(bool seleccionar){
    _sellecionarController.sink.add(seleccionar);
  }

  void cargarGalpones()async{
    final galpones = await _galponProvider.cargarGalpon();
    _galponController.sink.add(galpones);
  }
  void cargarContenedores(GalponModel galpon)async{
    final contenedores = await _galponProvider.cargarContenedores(galpon);
    _contenedoresController.sink.add(contenedores);
  }

  void cargarContenedorElegido(ContenedorModel contenedor){
    _contenedorController.sink.add(contenedor);
  }

  void moverCuys(List<CuyModel> lista)async{
    await _cuyProvider.moverCuys(lista, _contenedorController.value);
    lista.forEach((element) {
      _cuyController.value.remove(element);
    });
    _cuyController.sink.add(_cuyController.value);
    changeSeleccionar(false);
  }

  dispose(){
    _cuyController.close();
    _madresController.close();
    _contadorController.close();
    _tipoController.close();
    _sellecionarController.close();
    _galponController.close();
    _contenedoresController.close();
    _contenedorController.close();

  }
}