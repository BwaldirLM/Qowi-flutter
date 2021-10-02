import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providers/galpon_provider.dart';
import 'package:rxdart/rxdart.dart';

class GalponBloc{
  final _posaController = BehaviorSubject<List<ContenedorModel>>();
  final _jaulaController = BehaviorSubject<List<ContenedorModel>>();
  final _galponController= BehaviorSubject<List<GalponModel>>();

  final _galponProvider = GalponProvider();

  Stream<List<ContenedorModel>> get posaStream => _posaController.stream;
  Stream<List<ContenedorModel>> get jaulaStream =>  _jaulaController.stream;
  Stream<List<GalponModel>> get galponStream => _galponController.stream;

  void cargarGalpones()async{
    final galpones = await _galponProvider.cargarGalpon();
    _galponController.sink.add(galpones);
  }

  void cargarPosas(GalponModel galpon)async{
    final posas = await _galponProvider.cargarPosasTipo(galpon, 'POSA');
    _posaController.sink.add(posas);
  }

  void cargarJaulas(GalponModel galpon) async{
    final jaulas = await _galponProvider.cargarPosasTipo(galpon, 'JAULA');
    _jaulaController.sink.add(jaulas);
  }

  void agregarContenedor(GalponModel galpon, String container) async {
    final posa = ContenedorModel();
    await _galponProvider.addPosa(galpon, posa, container);
    if (container == 'POSA')  cargarPosas(galpon);
    else cargarJaulas(galpon);

  }

  dispose(){
    _posaController.close();
    _jaulaController.close();
    _galponController.close();
  }
}