import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:rxdart/rxdart.dart';

class MoverCuyBloc{
  final _contenedorController = BehaviorSubject<Map>();

  final _cuyProvider = CuyProvider();

  Stream<Map> get contenedorStream => _contenedorController.stream;

  void selectContainer(Map contenedor){
    _contenedorController.sink.add(contenedor);
  }

  void moverCuys(List<CuyModel> cuys, Map<String, dynamic> contendor ) async{
    final  contenedor = ContenedorModel.fromJson(contendor);
    await _cuyProvider.moverCuys(cuys, contenedor);
  }

  dispose(){
    _contenedorController.close();

  }
}