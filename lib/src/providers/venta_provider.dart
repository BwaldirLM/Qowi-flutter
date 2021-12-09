import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/venta_detalle_model.dart';
import 'package:qowi/src/models/venta_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:supabase/supabase.dart';

class VentaProvider{
  final _client = SupabaseClient(supabaseUrl, supabaseKey);

  final _cuyProvider = CuyProvider();
  
  Future<void> addVenta(List<CuyModel> cuys, List<VentaDetalleModel> ventaDetalles) async{
    final response = await _client.from('venta')
        .insert([VentaModel().toJson()])
        .execute().then((value)async{
          final resp = value.data[0];
          final respId = resp['id'];
          int n = cuys.length;
          for(int i=0; i<n; i++){
            final cuy = cuys[i]..estado = false;
            final ventaDetalle = ventaDetalles[i]..ventaId = respId;
            await _cuyProvider.updateCuy(cuy);
            await addVentaDetalle(ventaDetalle);

          }
    });
  }

  Future<void> addVentaDetalle(VentaDetalleModel ventaDetalle)async{
    final response = await _client.from('venta_detalle')
        .insert(ventaDetalle.toJson())
        .execute();
  }
}