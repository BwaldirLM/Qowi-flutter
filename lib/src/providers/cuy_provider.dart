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
          if(cuyTemp.estado!) cuysList.add(cuyTemp);

        });
      });
    });




    return cuysList;
  }


  Future<List<CuyModel>> cargarCuysContenedor(int contenedor)async{
    final response = await client
        .from('cuy')
        .select()
        .eq('contenedor', contenedor)
        .eq('estado', true)
        .execute();

    final decodedData = response.toJson();
    final cuysData = decodedData['data'];

    List<CuyModel> cuys = [];
    if(cuysData != null){
      cuysData.forEach((element){
        final cuyTemp = CuyModel.fromJson(element);
        cuys.add(cuyTemp);
      });
    }
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

  //--Actulizar cuy
  Future<void> updateCuy(CuyModel cuy)async{
    final response = await client.from('cuy')
        .update(cuy.toJson())
        .eq('id', cuy.id)
        .execute();
  }

  Future<void> moverCuys(List<CuyModel> lista, ContenedorModel contenedor)async{
    lista.forEach((cuy)async{
      cuy.contenedor = contenedor.id;
      await updateCuy(cuy);
    });
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

  Future<List<CuyModel>> cargarMadres(ContenedorModel contenedor)async{
    final response = await client.from('cuy')
        .select()
        .eq('contenedor', contenedor.id)
        .eq('tipo', 'reproductora')
        .eq('estado', true)
        .execute();
    final decodedData = response.toJson();
    final cuysData = decodedData['data'];
    List<CuyModel> cuys = [];
    cuysData.forEach((element){
      final cuy = CuyModel.fromJson(element);
      cuys.add(cuy);
    });
    return cuys;
  }

  Future<List<CuyModel>> cargarPadres(ContenedorModel contenedor)async {
    final response = await client.from('cuy')
        .select()
        .eq('contenedor', contenedor.id)
        .eq('tipo', 'padrillo')
        .eq('estado', true)
        .execute();

    final decodedData = response.toJson();
    final cuysData = decodedData['data'];
    List<CuyModel> cuys = [];
    cuysData.forEach((element){
      final cuy = CuyModel.fromJson(element);
      cuys.add(cuy);
    });
    if(cuys.isEmpty){
      final response = await client.from('cuy')
          .select()
          .eq('tipo', 'padrillo')
          .eq('estado', true)
          .execute();

      final decodedData = response.toJson();
      final cuysData = decodedData['data'];
      cuysData.forEach((element){
        final cuy = CuyModel.fromJson(element);
        cuys.add(cuy);
      });
    }
    return cuys;

  }

  Future<void> newIncidencia(CuyModel cuy, String incidencia) async {
    final response = await client.from('incidencia_muerte').
          insert([{'descripcion': incidencia, 'cuy_id':cuy.id}])
          .execute();
    await updateCuy(cuy);

  }

}