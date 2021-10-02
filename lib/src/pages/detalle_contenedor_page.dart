import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
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
                    final cuy = snapshot.data![index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'cuy', arguments: cuy),
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: Image(
                            image: AssetImage('assets/cuy_detalle.png'),
                            fit: BoxFit.cover
                        ),
                      ),
                    );
                  }
              );
            }
          }
        },
      ),



      floatingActionButton: StreamBuilder(
        stream: cuyBloc.cuyStream,
        builder: (context, snapshot){
          return FloatingActionButton(
            child: Icon(Icons.add),
            //onPressed: () => cuyBloc.addCuy(contenedor),
            onPressed: () =>  agregarCuys(context, cuyBloc, contenedor),
          );
        },
      ),


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
