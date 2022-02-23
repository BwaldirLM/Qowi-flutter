import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/models/padres_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:qowi/src/providers/galpon_provider.dart';
import 'package:qowi/src/providers/nacimiento_provider.dart';
import 'package:rxdart/rxdart.dart';

class NacimientoBloc {
  final _galponController = BehaviorSubject<List<GalponModel>>();
  final _contenedorController = BehaviorSubject<List<ContenedorModel>>();
  final _seleccionController = BehaviorSubject<bool>();
  final _padreController = BehaviorSubject<List<CuyModel>>();
  final _madreController = BehaviorSubject<List<CuyModel>>();
  final _criasController = BehaviorSubject<List<CuyModel>>();
  final _cuyPadreController = BehaviorSubject<CuyModel>();
  final _cuyMadreController = BehaviorSubject<CuyModel>();
  final _cantidadController = BehaviorSubject<int>();
  final _cantidadIncidenciaController = BehaviorSubject<int>();
  final _contController = BehaviorSubject<ContenedorModel>();
  final _cargandoControlller = BehaviorSubject<bool>();

  final _galponProvider = GalponProvider();
  final _cuyProvider = CuyProvider();
  final _nacimientoProvider = NacimientoProvider();

  Stream<List<ContenedorModel>> get contenedorStream =>
      _contenedorController.stream;
  Stream<List<GalponModel>> get galponStream => _galponController.stream;
  Stream<List<CuyModel>> get madreStream => _madreController.stream;
  Stream<List<CuyModel>> get padreStream => _padreController.stream;
  Stream<bool> get selectedStream => _seleccionController.stream;
  Stream<CuyModel> get cuyPadreStream => _cuyPadreController.stream;
  Stream<CuyModel> get cuyMadreStream => _cuyMadreController.stream;
  Stream<int> get cantidadStream => _cantidadController.stream;
  Stream<int> get cantidadIncStream => _cantidadIncidenciaController.stream;
  Stream<ContenedorModel> get contStream => _contController.stream;

  bool get seleccionValue => _seleccionController.value;
  int get cantidadValue => _cantidadController.value;

  void cargarContenedor(GalponModel galpon) async {
    final contenedores = await _galponProvider.cargarContenedores(galpon);
    _contenedorController.sink.add(contenedores);
  }

  void cargarGalpones() async {
    final galpones = await _galponProvider.cargarGalpon();
    _galponController.sink.add(galpones);
  }

  void seleccionado(bool selected) {
    _seleccionController.sink.add(selected);
  }

  void cargarMadres(ContenedorModel contenedor) async {
    final cuys = await _cuyProvider.cargarMadres(contenedor);
    _madreController.sink.add(cuys);
  }

  void cargarPadresTodo() async {
    final cuys = await _cuyProvider.cargarPadresTodo();
    _padreController.sink.add(cuys);
  }

  void cargarPadres(ContenedorModel contenedor) async {
    final cuys = await _cuyProvider.cargarPadres(contenedor);
    _padreController.sink.add(cuys);
  }

  void cargarMadre(CuyModel cuy) {
    _cuyMadreController.sink.add(cuy);
  }

  void cargarPadre(CuyModel cuy) {
    _cuyPadreController.sink.add(cuy);
  }

  void incrementar(int i) {
    if (i < 1) i = 1;
    _cantidadController.sink.add(i);
  }

  void incrementarInc(int i) {
    if (i < 1) i = 0;

    _cantidadIncidenciaController.sink.add(i);
  }

  void agregarCrias(PadresModel padres, int crias) async {
    await _nacimientoProvider.addNacimiento(padres, crias, null);
  }

  void registrarNacimiento(
      PadresModel padres, DateTime? fechaNacimiento) async {
    int crias = !_cantidadController.hasValue ? 1 : _cantidadController.value;

    await _nacimientoProvider.addNacimiento(padres, crias, fechaNacimiento);
  }

  void contendor(int id) async {
    final contenedor = await _galponProvider.getContenedor(id);
    _contController.sink.add(contenedor);
  }

  dispose() {
    _contenedorController.close();
    _galponController.close();
    _seleccionController.close();
    _padreController.close();
    _madreController.close();
    _criasController.close();
    _cuyPadreController.close();
    _cuyMadreController.close();
    _cantidadController.close();
    _cantidadIncidenciaController.close();
    _contController.close();
    _cargandoControlller.close();
  }
}
