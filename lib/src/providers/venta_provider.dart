import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/venta_detalle_model.dart';
import 'package:qowi/src/models/venta_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:qowi/src/providers/galpon_provider.dart';
import 'package:supabase/supabase.dart';

class VentaProvider {
  final _client = SupabaseClient(supabaseUrl, supabaseKey);

  final _cuyProvider = CuyProvider();
  final _galponProvider = GalponProvider();

  Future<void> addVenta(
      List<CuyModel> cuys, List<VentaDetalleModel> ventaDetalles) async {
    final user = await _galponProvider.getUser();
    final response = await _client
        .from('venta')
        .insert([VentaModel(userId: user.id).toJson()])
        .execute()
        .then((value) async {
          final resp = value.data[0];
          final respId = resp['id'];
          int n = cuys.length;
          for (int i = 0; i < n; i++) {
            final cuy = cuys[i]..estado = false;
            cuy.observacion = 'vendido';
            final ventaDetalle = ventaDetalles[i]..ventaId = respId;
            await _cuyProvider.updateCuy(cuy);
            await addVentaDetalle(ventaDetalle);
          }
        });
  }

  Future<void> addVentaDetalle(VentaDetalleModel ventaDetalle) async {
    final response = await _client
        .from('venta_detalle')
        .insert(ventaDetalle.toJson())
        .execute();
  }

  Future<List<VentaModel>> obtenerVentas() async {
    final user = await _galponProvider.getUser();

    final response = await _client
        .from('venta')
        .select()
        .eq('user_id', user.id)
        .order('fecha')
        .execute();

    if (response.error == null) {
      final decodedData = response.toJson();
      final data = decodedData['data'] as List;
      final List<VentaModel> ventas = [];
      data.forEach((element) => ventas.add(VentaModel(
          userId: element['user_id'],
          fecha: DateTime.parse(element['fecha']),
          id: element['id'])));

      return ventas;
    } else {
      return [];
    }
  }

  Future<List<VentaDetalleModel>> detalleVenta(VentaModel venta) async {
    final response = await _client
        .from('venta_detalle')
        .select()
        .eq('venta_id', venta.id)
        .execute();
    if (response.error == null) {
      final decodedData = response.toJson();
      final List data = decodedData['data'];
      List<VentaDetalleModel> detalles = [];
      data.forEach((element) {
        final detVenta = VentaDetalleModel.fromJson(element);
        detalles.add(detVenta);
      });
      return detalles;
    } else {
      return [];
    }
  }
}
