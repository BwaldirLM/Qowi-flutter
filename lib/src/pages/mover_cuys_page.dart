
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/mover_cuy_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/providers/galpon_provider.dart';

class MoverCuyPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final cuyList = ModalRoute.of(context)!.settings.arguments as List<CuyModel>;
    final _galponProvider = GalponProvider();
    final _moverCuyBloc = MoverCuyBloc();
    final size = MediaQuery.of(context).size;

    return FutureBuilder<List>(
      future: _galponProvider.cargarGalponesData(),
        builder: (context, snapshot){
        if(!snapshot.hasData) return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator(),),
        );
        else{
          final data = snapshot.data;
          return DefaultTabController(
              length: data!.length,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Mover cuy'),
                  bottom: TabBar(
                    tabs: _tabs(data),
                  ),
                ),
                body: TabBarView(
                  children: _contenedores(data, _moverCuyBloc, size),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: StreamBuilder<Map>(
                  stream: _moverCuyBloc.contenedorStream,
                  builder: (_, snapshot){
                    if(!snapshot.hasData) return SizedBox.shrink();
                    else{
                      final contendor = snapshot.data;
                      return FloatingActionButton.extended(
                        label: Text('Mover a ${contendor!['tipo']} ${contendor['numero']}'),
                        onPressed: () {
                          _moverCuyBloc.moverCuys(cuyList, contendor as Map<String, dynamic>);
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                ),
              )
          );
        }}
    );
  }

  List<Widget> _tabs(List data) {
     return data.map((e) => Text(
       'Galpon ${e['nombre']}',
       style: TextStyle(
           fontSize: 18,
           color: Colors.black54,
           fontWeight: FontWeight.w700
        ),)).toList();
  }

  List<Widget>_contenedores(List data, MoverCuyBloc bloc, Size size) {
    return data.map((e){
      final contenedores = e['contenedor'] as List;
      return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.height*0.2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: contenedores.length,
        itemBuilder: (context, index){
          return _contenedor(contenedores[index], bloc);
        },
      );
    }).toList();
  }

  Widget _contenedor(Map contenedor, MoverCuyBloc bloc) {
    return InkWell(
      child: Container(
          //margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: contenedor['tipo'] == 'POSA'?
              Colors.deepOrangeAccent.withOpacity(0.8):Colors.yellowAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: contenedor['tipo'] == 'POSA'?
                  Colors.deepOrangeAccent: Colors.yellowAccent,
                  width: 5
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(4, 4)
                )
              ]
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${contenedor['tipo']}'),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text(
                    '${contenedor['numero']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),]
          )),
      onTap: (){
        bloc.selectContainer(contenedor);
      },
    );
  }
}
