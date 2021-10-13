import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
import 'package:qowi/src/bloc/seleccion_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';

class DetalleContenedorPage extends StatelessWidget {
  DetalleContenedorPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final contenedor = ModalRoute.of(context)!.settings.arguments as ContenedorModel;
    final size = MediaQuery.of(context).size;
    final cuyBloc = CuyBloc();
    cuyBloc.cargarCuysContenedor(contenedor.id);
    bool seleccionar = false;
    final List<CuyModel> listSeleccionado = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false),
              icon: Icon(Icons.home)
          )
        ],
      ),
      body: StreamBuilder(
        stream: cuyBloc.cuyStream,
        builder: (BuildContext context, AsyncSnapshot<List<CuyModel>> snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else{
            if(snapshot.data!.isEmpty) return Center(child: Text('No hay cuys'));
            else{
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: size.height * .2,
                    childAspectRatio: 2/3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    final bloc = SeleccionarBloc();
                    final cuy = snapshot.data![index];
                    return StreamBuilder<bool>(
                      stream: bloc.seleccionarStream,
                      initialData: seleccionar,
                      builder: (context, snapshot){
                        return GestureDetector(
                          onTap: () {
                            if(seleccionar==false) Navigator.pushNamed(context, 'cuy', arguments: cuy);
                            else{
                              if(listSeleccionado.length == 0) {
                                seleccionar= false;
                                Navigator.pushNamed(context, 'cuy', arguments: cuy);
                              }else {
                                bloc.setState(!snapshot.data!);
                                if (!snapshot.data!) listSeleccionado.add(cuy);
                                else listSeleccionado.remove(cuy);
                              }
                            }
                            if(listSeleccionado.length == 0) cuyBloc.changeSeleccionar(false);
                          },
                          onLongPress: (){
                            if(listSeleccionado.length == 0){
                              listSeleccionado.add(cuy);
                              bloc.setState(true);
                              seleccionar=true;
                              cuyBloc.changeSeleccionar(seleccionar);
                            }

                          },
                          //URL=https://api-rest-auth-node.herokuapp.com
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            color: snapshot.data!?Color(0xFFDCEDC8):Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                              children: [
                                Image(
                                    image: AssetImage('assets/cuy_detalle.png'),
                                    fit: BoxFit.cover
                                ),
                                Text(cuy.nombre??'${cuy.tipo}')
                              ],
                            )
                          ),
                        );
                      },
                    );
                  }
              );
            }
          }
        },
      ),

      //floatingActionButton: FlowMenu(),

      floatingActionButton: StreamBuilder<bool>(
        stream: cuyBloc.seleccionarStream,
        initialData: seleccionar,
        builder: (context, snapshot){
          if(!snapshot.data!) {
            print('agregar: ${snapshot.data}');
            return FloatingActionButton(
              child: Icon(Icons.add),
              //onPressed: () => cuyBloc.addCuy(contenedor),
              onPressed: () => agregarCuys(context, cuyBloc, contenedor),
            );
          } else {
            print('mover: ${snapshot.data}');
            return FloatingActionButton(
              child: Icon(Icons.wifi_protected_setup),
              onPressed: () => _cambiarContenedor(context, listSeleccionado, cuyBloc)
            );
          }
        },
      ),
    );
  }

  _cambiarContenedor(BuildContext context, List<CuyModel> listSeleccionado, CuyBloc bloc) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Mover'),
            content: Column(

              children: [
                Text('Galpon'),
                Container(
                  height: 100,
                  width: 150,
                  child: StreamBuilder<List<GalponModel>>(
                    stream: bloc.galponStream,
                    builder: (context, snapshot){
                      bloc.cargarGalpones();
                      if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                      else return GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 130,
                            childAspectRatio: 2/3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i){
                            return Container(
                              height: 40,
                              width: 40,
                              child: InkWell(
                                onTap: () => bloc.cargarContenedores(snapshot.data![i]),
                                child: Card(
                                  margin: EdgeInsets.all(15),
                                  color: Colors.red,
                                  child: Text(snapshot.data![i].name),
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),
                /*Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 300,
                  child: StreamBuilder<List<GalponModel>>(
                    stream: bloc.galponStream,
                    builder: (context, snapshot){
                      bloc.cargarGalpones();
                      if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                      else return Center(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i){
                              return InkWell(
                                onTap: () => bloc.cargarContenedores(snapshot.data![i]),
                                child: Card(
                                  margin: EdgeInsets.all(15),
                                  color: Colors.red,
                                  child: Text(snapshot.data![i].name),
                                ),
                              );
                            }
                        ),
                      );
                    },
                  )
                ),*/
                Divider(),
                Text('Contenedores'),
                Container(
                  height: 200,
                  width: 200,
                  child: StreamBuilder<List<ContenedorModel>>(
                    stream: bloc.contenedoresStream,
                    builder: (context, snapshot){
                      if(!snapshot.hasData) return Text('Selecione un galpon');
                      else return GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 180,
                            childAspectRatio: 2/3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i){
                            return Container(
                              height: 20,
                              width: 40,
                              child: InkWell(
                                onTap: () => bloc.cargarContenedorElegido(snapshot.data![i]),
                                child: Card(
                                    color: snapshot.data![i].tipo=='POSA'?Color(0xFFFFB300):Color(0xFFFFF176),
                                    elevation: 5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data![i].tipo=='POSA'?'Posa':'Jaula'),
                                        Text('${snapshot.data![i].numero}')
                                      ],
                                    )
                                )
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),
                StreamBuilder<ContenedorModel>(
                  stream: bloc.contenedorStream,
                  builder: (context, snapshot){
                    if(snapshot.hasData)
                      return Text('Mover a: ${snapshot.data!.tipo} ${snapshot.data!.numero}');
                    else return Text('Selecciona un contenedor');
                  },
                )
              ]
            ),
            actions: [
              TextButton(
                  onPressed: ()=>Navigator.of(context).pop(),
                  child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    bloc.moverCuys(listSeleccionado);
                    Navigator.pop(context);
                  },
                  child: Text('Mover')
              )
            ],
          );
        }
    );
  }
}

void agregarCuys(BuildContext context, CuyBloc bloc, ContenedorModel contenedor) {
  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context){
      bloc.incrementar(1);
      bloc.changeTipo('reproductora');
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Agregar cuys'),
          content: StreamBuilder<int>(
            stream: bloc.contadorStream,
            //initialData: 1,
            builder: (context, snapshot){

              return Row(
                children: [
                  StreamBuilder<String>(
                      stream: bloc.tipoStream,
                      initialData: 'reproductora',
                      builder: (context, snapshot){
                        return DropdownButton(
                          value: snapshot.data,
                          items:[
                            DropdownMenuItem(
                              child: Text('Reproductora'),
                              value: 'reproductora',
                            ),
                            DropdownMenuItem(
                              child: Text('Padrillo'),
                              value: 'padrillo',
                            ),
                            DropdownMenuItem(
                              child: Text('Engorde'),
                              value: 'engorde',
                            ),
                            DropdownMenuItem(
                              child: Text('Cria'),
                              value: 'cria',
                            ),
                            DropdownMenuItem(
                              child: Text('Gasapo'),
                              value: 'gasapo',
                            )
                          ],
                          onChanged: (opt){
                            bloc.changeTipo(opt as String);
                          },
                        );
                      }
                  ),
                  IconButton(onPressed: (){
                    if(snapshot.data! > 1) bloc.incrementar(snapshot.data!-1);
                  }, icon: Icon(Icons.remove)),
                  SizedBox(child: Text(snapshot.data.toString())),
                  IconButton(onPressed: ()=>bloc.incrementar(snapshot.data!+1), icon: Icon(Icons.add)),

                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
              },
                child: Text('Cancelar')),
            TextButton(
                child: Text('Aceptar'),
              onPressed: (){
                final cuyTemp = CuyModel();
                cuyTemp.contenedor = contenedor.id;
                cuyTemp.tipo = bloc.tipoValue;
                  if(bloc.contadorValue == 1){
                    bloc.addCuy(cuyTemp);
                  }
                  else{
                    int count = bloc.contadorValue;
                    while(count != 0){
                      bloc.addCuy(cuyTemp);
                      count--;
                    }

                  }
                  Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}
