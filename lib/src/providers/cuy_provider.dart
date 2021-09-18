import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:supabase/supabase.dart';

import 'galpon_provider.dart';

class CuyProvider{
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  final galponProvider = GalponProvider();

  Future<List<CuyModel>> cargarCuys()async{
    final user =  await galponProvider.getUser();

    final response = await client
        .from('app_users')
        .select(
          '*, galpon(*,contenedor(*, cuy(*)))'
        )
        .eq('user_id', user.id)
        .execute();

    final decodedData = response.toJson();
    final cuysData = decodedData['data'][0];

    final galpones = cuysData['galpon'];
    List<CuyModel> cuysList = [];
    galpones.forEach((element){
      //print('=============${element}');
      final contenedor = element['contenedor'];
      contenedor.forEach((element){
        final cuys = element['cuy'];
        cuys.forEach((cuy){
          final cuyTemp = CuyModel.fromJson(cuy);
          cuysList.add(cuyTemp);

        });
      });
    });




    return cuysList;
  }


  Future<List<CuyModel>> cargarCuysContenedor(ContenedorModel contenedor)async{
    final response = await client
        .from('cuy')
        .select()
        .eq('contenedor', contenedor.id)
        .execute();

    final decodedData = response.toJson();
    final cuysData = decodedData['data'];

    List<CuyModel> cuys = [];
    cuysData.forEach((element){
      final cuyTemp = CuyModel.fromJson(element);
      cuys.add(cuyTemp);

    });

    return cuys;
  }
  Future<void> addCuy(CuyModel cuy)async{
    if(cuy.esReproductora()) cuy.genero = 'hembra';
    else if(cuy.esPadrillo()) cuy.genero = 'macho';
    else if(cuy.esEngorde()) cuy.genero = 'macho';
    final response = await client.from('cuy')
        .insert([cuy.toJson()])
        .execute();
  }

  Future<List<CuyModel>> cargarCuysMadres()async{
    final response = await client
        .from('cuy')
        .select()
        .eq('genero', 'hembra')
        .execute();

    final decodedData = response.toJson();
    final cuysData = decodedData['data'];

    List<CuyModel> cuys = [];
    cuysData.forEach((element){
      final cuyTemp = CuyModel.fromJson(element);
      cuys.add(cuyTemp);

    });

    return cuys;
  }
}