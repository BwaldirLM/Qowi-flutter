import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
import 'package:qowi/src/bloc/seleccion_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/widgets/carrito_widget.dart';
import 'package:qowi/src/widgets/cuy_item.dart';
import 'package:qowi/src/widgets/menu_flow.dart';
import 'package:qowi/src/widgets/resumen.dart';

class DetalleContenedorPage extends StatelessWidget {
  DetalleContenedorPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final contenedor = ModalRoute.of(context)!.settings.arguments as ContenedorModel;
    final size = MediaQuery.of(context).size;
    final cuyBloc = CuyBloc();
    cuyBloc.cargarCuysContenedor(contenedor.id);
    late List<CuyModel> listSeleccionado;
    late  List<GlobalKey<CuyItemState>> _cuyItemKeyList;
    final carrito = Provider.of<Carrito>(context);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: cuyBloc.seleccionarStream,
          initialData: false,
          builder: (_, snapshot){
            if(snapshot.data!) return Text('Seleccionar cuys', style: TextStyle(color: Colors.black45));
            else return Text('Detalles', style: TextStyle(color: Colors.black));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          StreamBuilder<bool>(
            stream: cuyBloc.seleccionarStream,
              initialData: false,
              builder: (_, snapshot){
              if(!snapshot.data!) return IconButton(
                  onPressed: ()=>Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false),
                  icon: Icon(Icons.home)
              );
              else return SizedBox.shrink();
              }
          ),
          StreamBuilder<bool>(
              stream: cuyBloc.seleccionarStream,
              initialData: false,
              builder: (_, snapshot){
                if(!snapshot.data!) return IconButton(
                    onPressed: ()=>_informacion(context, cuyBloc, contenedor),
                    icon: Icon(Icons.info));
                else return SizedBox.shrink();
              }
          ),
          StreamBuilder<bool>(
              stream: cuyBloc.seleccionarStream,
              initialData: false,
              builder: (_, snapshot){
                if(snapshot.data!) return InkWell(
                  child: Center(

                    child: Text('Cancelar', style: TextStyle(color: Colors.black)),
                  ),
                  onTap: (){
                    cuyBloc.changeSeleccionar(false);
                    _cuyItemKeyList.forEach((element) {
                      if(element.currentState!.isSelected){
                        element.currentState!.isSelected = false;
                        element.currentState!.color = Colors.transparent;
                      }
                    });
                  },
                );
                else return SizedBox.shrink();
              }
          ),

        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: cuyBloc.cuyStream,
            builder: (BuildContext context, AsyncSnapshot<List<CuyModel>> snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              else{
                if(snapshot.data!.isEmpty) return Center(child: Text('No hay cuys'));
                else{
                  final cuyList = snapshot.data!;
                  _cuyItemKeyList = List.generate(cuyList.length, (index) => GlobalKey<CuyItemState>());
                  return StreamBuilder<bool>(
                      stream: cuyBloc.seleccionarStream,
                      initialData: false,
                      builder: (_, snapshot){
                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: size.height * .2,
                              childAspectRatio: 2/3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: cuyList.length,
                            itemBuilder: (context, index){
                              final cuy = cuyList[index];
                              return CuyItem(
                                key: _cuyItemKeyList[index],
                                cuy: cuy,
                                seleccionar: snapshot.data!,
                                onLongPress: () {
                                  if(!snapshot.data!){
                                    cuyBloc.changeSeleccionar(true);
                                    _cuyItemKeyList[index].currentState!.isSelected = true;
                                    _cuyItemKeyList[index].currentState!.color = Color(0xFFDCEDC8);
                                  }
                                  //_cuyKey.currentState!.seleccionar = true;
                                },
                              );
                            }
                        );
                      }
                  );
                }
              }
            },
          ),
          carrito.cantidad!=0?
          Positioned(
            bottom: 25,
            left: 25,
            child: CarritoVenta(carrito: carrito.carrito,),
          ):SizedBox.shrink(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: StreamBuilder<bool>(
        stream: cuyBloc.seleccionarStream,
        initialData: false,
        builder: (_, snapshot){
          if(!snapshot.data!) return FlowMenu(
            children: [
              FloatingActionButton(
                heroTag: 'agregar',
                tooltip: 'Agregar cuys',
                child: Icon(Icons.add, size: 40,),
                //onPressed: () => cuyBloc.addCuy(contenedor),
                onPressed: () => agregarCuys(context, cuyBloc, contenedor),
              )
            ],
          );
          else return Column(
            children: [
              Spacer(),
              FloatingActionButton.extended(
                heroTag: 'mover',
                  onPressed: (){
                  listSeleccionado = [];
                    _cuyItemKeyList.forEach((cuy) {
                      if(cuy.currentState!.isSelected) {
                        print(cuy.currentState!.cuy.id);
                        listSeleccionado.add(cuy.currentState!.cuy);
                      }
                    });
                    if(listSeleccionado.isNotEmpty) {
                      Navigator.pushNamed(context, 'mover', arguments: listSeleccionado).then((value){
                        cuyBloc.cargarCuysContenedor(contenedor.id);
                        cuyBloc.changeSeleccionar(false);
                      });
                    }
                  },
                  label: Text('Mover'),
              ),
              SizedBox(height: 10,),
              FloatingActionButton.extended(
                heroTag: 'vender',
                label: Text('Vender'),
                onPressed: (){
                  _cuyItemKeyList.forEach((element) {
                    if(element.currentState!.isSelected){
                      carrito.agregar(element.currentState!.cuy);
                      element.currentState!.isSelected = false;
                    }
                    cuyBloc.changeSeleccionar(false);
                  });
                },
                //child: Text('Mover'),
              ),
              SizedBox(height: 10,),
            ],
          );
        },
      )



    );
  }



  void _informacion(BuildContext context, CuyBloc bloc, ContenedorModel contenedor) {
    showDialog(
        context: context,
        builder: (context){

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Resumen'),
            content: Resume(bloc: bloc, contenedor: contenedor),
              actions: [
                TextButton(onPressed: ()=>Navigator.pop(context), child: Text('Aceptar'))
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
                  SizedBox(child: Text('${snapshot.data}')),
                  IconButton(onPressed: ()=>bloc.incrementar(snapshot.data!+1), icon: Icon(Icons.add)),

                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: ()=> Navigator.of(context).pop(),
                child: Text('Cancelar')
            ),
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
