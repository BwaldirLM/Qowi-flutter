
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

    final  galponesData = decodedData['data'];


    List<GalponModel> galpones = [];

    if(galponesData != null){
      galponesData.forEach((element) {
        final temp = GalponModel();
        temp.id = element['id'];
        temp.userId = element['user_id'];
        temp.name = element['nombre'];
        galpones.add(temp);
      });
    }

    return galpones;
  }

  Future<List> cargarGalponesData() async{
    final user = await getUser();
    final response = await client
        .from('app_users')
        .select(
        '*, galpon(*,contenedor(*))'
    )
        .eq('user_id', user.id)

        .execute();
    final decodedData  = response.toJson();
    final galponesData = decodedData['data'][0];
    return galponesData['galpon'];
  }



  //Contenedores
  Future<List<ContenedorModel>> cargarPosasTipo(GalponModel galpon, String container)async{
    await getUser();
    final response = await client.from('contenedor')
        .select()
        .eq('galpon_id', galpon.id)
        .eq('tipo', container)
        .execute();
    final decodedData = response.toJson();

    final posasData = decodedData['data'];


    List<ContenedorModel> posas = [];

    if(posasData != null){
      posasData.forEach((element) {
        final temp = ContenedorModel();
        temp.id = element['id'];
        temp.galponId = element['galpon_id'];
        temp.numero = element['numero'];
        posas.add(temp);
      });
    }

    return posas;
  }
  Future<List<ContenedorModel>> cargarContenedores(GalponModel galpon)async{
    await getUser();
    final response = await client.from('contenedor')
      .select()
      .eq('galpon_id', galpon.id)
      .execute();
    final decodedData = response.toJson();
    final contenedoresData = decodedData['data'];

    List<ContenedorModel> contenedores = [];

    contenedoresData.forEach((element) {
      final contenedor = ContenedorModel.fromJson(element);
      contenedores.add(contenedor);
    });

    return contenedores;
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
  Future<ContenedorModel> getContenedor(int id)async{
    final response = await client.from('contenedor')
        .select()
        .eq('id', id)
        .execute();
    final decodedData = response.toJson()['data'];

    final contenedor = ContenedorModel.fromJson(decodedData[0]);

    return contenedor;
  }


}