import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:rxdart/subjects.dart';

class VentaBloc {
  final _ventaController = BehaviorSubject<List<CardVenta>>();

  Stream<List<CardVenta>> get ventaStream => _ventaController.stream;

  dispose() {
    _ventaController.close();
  }

  Future<void> asignarATodo(String price) async {
    _ventaController.value.forEach((element) {
      element.ventaDetalleModel!.precio = double.parse(price);
    });
    _ventaController.sink.add(_ventaController.value);
  }

  void cargar(List<CardVenta> carritoProvider) {
    _ventaController.sink.add(carritoProvider);
  }
}
