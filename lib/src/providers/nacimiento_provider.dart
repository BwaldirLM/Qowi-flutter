import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/padres_model.dart';
import 'package:supabase/supabase.dart';

class NacimientoProvider{
  final clinte = SupabaseClient(supabaseUrl, supabaseKey);
  
  Future addNacimiento(PadresModel padres, int crias)async{
    late final respId;
    final PostgrestResponse find = await clinte.from('padres')
        .select()
        .eq('padre_id', padres.padreId)
        .eq('madre_id', padres.madreId)
        .execute();
    final List data = find.data;
   if(data.isEmpty){
      final response = await clinte.from('padres')
          .insert([padres.toJson()])
          .execute().then((value){
            final data =  value.data[0];
            respId = data['id'];
      });
    }else respId = data[0]['id'];
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