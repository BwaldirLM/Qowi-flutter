import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/padres_model.dart';
import 'package:supabase/supabase.dart';

class NacimientoProvider{
  final clinte = SupabaseClient(supabaseUrl, supabaseKey);
  
  Future addNacimiento(PadresModel padres, int crias)async{
    late final respId;
    final response = await clinte.from('padres')
        .insert([padres.toJson()])
        .execute().then((value){
          final data =  value.data[0];
          respId = data['id'];
    });
    while(crias>0){
      crias--;
      final cuy = CuyModel();
      cuy.contenedor = padres.contenedorId;
      cuy.tipo = 'cria';
      cuy.fechaNacimiento = DateTime.now();
      cuy.padresId = respId;

      final resp = await clinte.from('cuy')
        .insert([cuy.toJson()])
        .execute();

    }
  }
  
}