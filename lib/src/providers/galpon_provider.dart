
import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';

import 'package:supabase/supabase.dart';

class GalponProvider{
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  final _prefs = PreferenciasUsuario();

  late User user;

  Future<User> getUser() async{
    final session = await client.auth.recoverSession(_prefs.supabaseSessionKey);
    return session.data!.user!;
  }
  //Galpones
  Future<List<GalponModel>> cargarGalpon() async{
    user = await getUser();
    final response = await client.from('galpon')
        .select()
        .eq('user_id', user.id)
        .execute();
    final Map decodedData = response.toJson();

    final List galponesData = decodedData['data'];


    List<GalponModel> galpones = [];

    galponesData.forEach((element) {
      final temp = GalponModel();
      temp.id = element['id'];
      temp.userId = element['user_id'];
      temp.name = element['nombre'];
      galpones.add(temp);
    });

    return galpones;
  }



  //Contenedores
  Future<List<ContenedorModel>> cargarPosas(GalponModel galpon, String container)async{
    await getUser();
    final response = await client.from('contenedor')
        .select()
        .eq('galpon_id', galpon.id)
        .eq('tipo', container)
        .execute();
    final decodedData = response.toJson();

    final posasData = decodedData['data'];


    List<ContenedorModel> posas = [];

    posasData.forEach((element) {
      final temp = ContenedorModel();
      temp.id = element['id'];
      temp.galponId = element['galpon_id'];
      temp.numero = element['numero'];
      posas.add(temp);
    });

    return posas;
  }
  Future<void> addPosa(GalponModel galpon, ContenedorModel posa, String container) async{
    await getUser();
    final posas = await client.from('contenedor')
        .select()
        .eq('galpon_id', galpon.id)
        .eq('tipo', container)
        .execute();
    final posasDecoded = posas.toJson();
    final List listPosa = posasDecoded['data'];

    int? nro = listPosa.length+1;

    final response = await client.from('contenedor')
    .insert([{'galpon_id':galpon.id, 'numero':nro, 'tipo':container}])
    .execute();

  }


}