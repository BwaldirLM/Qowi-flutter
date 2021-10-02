import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/nacimiento_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/models/padres_model.dart';

class NacimientoPage extends StatelessWidget {
  const NacimientoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nacimientoBloc = NacimientoBloc();
    final size = MediaQuery.of(context).size;
    nacimientoBloc.cargarGalpones();

    final padres = PadresModel();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Nacimiento', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _elegirGalpon(nacimientoBloc, size),
          _elegirContenedor(nacimientoBloc, size, padres),
          _elegirPadres(nacimientoBloc, size, padres)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: ()=> guardar(context, padres, nacimientoBloc),
      ),
    );
  }

  Widget _elegirGalpon(NacimientoBloc bloc, Size size) {
    return Container(
      //height: size.height*0.4,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
        )
      ),
      child: Column(
        children: [
          Text('Elegir galpon'),
          Container(
            height: size.height * 0.15,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<List<GalponModel>>(
                stream: bloc.galponStream,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i){
                          final galpon = snapshot.data![i];
                          return GestureDetector(
                            onTap: (){

                              bloc.cargarContenedor(galpon);
                            },
                            child: Container(
                              width: size.width*0.2,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                              ),
                              child: Center(child: Text(galpon.name)),
                            ),
                          );
                        }
                    );
                  }else return Center(child: CircularProgressIndicator());
                }

            ),
          )
        ],
      ),
    );
  }

  Widget _elegirContenedor(NacimientoBloc bloc, Size size, PadresModel padres) {
    return Container(
      child: Column(
        children: [
          Text('Elegir posa o jaula'),
          Container(
            height: size.height*0.28,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black
                )
            ),
            child: StreamBuilder<List<ContenedorModel>>(
              stream: bloc.contenedorStream,
              builder: (context, snapshot){
                if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                else{
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: size.height*0.1,
                        childAspectRatio: 2/3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i){
                        final contenedor = snapshot.data![i];
                        if(contenedor.tipo == 'POSA') return GestureDetector(
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Posa'),
                                Text('${contenedor.numero}')
                              ],
                            ),
                          ),
                          onTap: () {
                              bloc.cargarMadres(contenedor);
                              bloc.cargarPadres(contenedor);
                              padres.contenedorId=contenedor.id;
                            }
                        );
                        else return GestureDetector(
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.indigo,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Jaula'),
                                Text('${contenedor.numero}'),
                              ],
                            ),
                          ),
                          onTap: () {
                            bloc.cargarMadres(contenedor);
                            bloc.cargarPadres(contenedor);
                            padres.contenedorId=contenedor.id;
                          }
                        );

                      }
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _elegirPadres(NacimientoBloc bloc, Size size, PadresModel padres) {
    return Container(
      child: Column(
        children: [
          Text('Elige los padres'),
          Container(
            height: size.height*0.31,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black
                )
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Madre'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height*0.11,
                          width: size.width*0.4,
                          child: StreamBuilder<List<CuyModel>>(
                            stream: bloc.madreStream,
                            builder: (context, snapshot){
                              if(snapshot.hasData) return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, i){
                                    final cuy = snapshot.data![i];
                                    return Card(
                                        child: ListTile(
                                          title: Text('${cuy.nombre??'Cuy'}'),
                                          focusColor: Colors.lightBlueAccent,
                                          selectedTileColor: Colors.lightBlueAccent,
                                          onTap: () {
                                            bloc.cargarMadre(cuy);
                                            padres.madreId = cuy.id;
                                          },
                                        )
                                    );

                                  }
                              );
                              else return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Container(
                          height: size.height*0.11,
                          width: size.width*0.4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          child: StreamBuilder<CuyModel>(
                            stream: bloc.cuyMadreStream,
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return Text(snapshot.data!.color??'Sin descripcion');
                              }else return Center(child: CircularProgressIndicator());
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Divider(),
                //PADRE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Padre'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height*0.11,
                          width: size.width*0.4,
                          child: StreamBuilder<List<CuyModel>>(
                          stream: bloc.padreStream,
                            builder: (context, snapshot){
                              if(snapshot.hasData) return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, i){
                                    final cuy = snapshot.data![i];
                                    if(snapshot.data!.length == 1) {
                                      bloc.cargarPadre(cuy);
                                      padres.padreId = cuy.id;
                                    }
                                    return Card(
                                        child: ListTile(
                                          title: Text('${cuy.nombre??'cututu'}'),
                                          focusColor: Colors.lightBlueAccent,
                                          selectedTileColor: Colors.lightBlueAccent,
                                          onTap: ()  {
                                            bloc.cargarPadre(cuy);
                                            padres.padreId = cuy.id;
                                          }                                          ,
                                        )
                                    );

                                  }
                              );
                              else return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Container(
                          height: size.height*0.11,
                          width: size.width*0.4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          child: StreamBuilder<CuyModel>(
                            stream: bloc.cuyPadreStream,
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return Text(snapshot.data!.color??'Sin descripcion');
                              }else return Center(child: CircularProgressIndicator());
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void guardar(BuildContext cxt, PadresModel padres, NacimientoBloc bloc) {
  //final nacimientoProvider = NacimientoProvider();
  //nacimientoProvider.addNacimiento(padres);
  showDialog(
    barrierDismissible: false,
      context: cxt,
      builder: (cxt){
        return StreamBuilder<int>(
          stream: bloc.cantidadStream,
            initialData: 1,
            builder: (context, snapshot){
              int crias = snapshot.data!;
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text('Agregar crias'),
                content: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: IconButton(onPressed: ()=>bloc.incrementar(snapshot.data!-1), icon: Icon(Icons.exposure_minus_1)),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: Text('${snapshot.data}', style: TextStyle(fontWeight: FontWeight.w700),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle
                      ),
                      child: IconButton(onPressed: ()=>bloc.incrementar(snapshot.data!+1), icon: Icon(Icons.exposure_plus_1)),
                    ),

                  ],
                ),
                actions: [
                  TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Cancelar')),
                  TextButton(
                      onPressed: (){
                        bloc.agregarCrias(padres, crias);
                        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                      },
                      child: Text('Aceptar'))
                ],
              );
            }
        );
      }
  );
}