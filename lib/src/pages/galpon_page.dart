import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qowi/src/bloc/galpon_bloc.dart';
import 'package:qowi/src/models/galpon_model.dart';


class GalponPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w700);
    final  galpon = ModalRoute.of(context)!.settings.arguments as GalponModel;
    final _galponBloc = GalponBloc();
    final size = MediaQuery.of(context).size;

    _galponBloc.cargarPosas(galpon);
    _galponBloc.cargarJaulas(galpon);

    return DefaultTabController(
        length: 2,
         child: Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(color: Colors.black),
             backgroundColor: Colors.transparent,
             elevation: 0,
             title: Text('Galpon "${galpon.name}"', style: TextStyle(color: Colors.blue),),
             bottom: TabBar(
               indicatorSize: TabBarIndicatorSize.label,
               tabs: [
                 Text('Posas', style: _textStyle),
                 Text('Jaulas',style: _textStyle)
               ],
             ),
           ),
           body: TabBarView(
               children:[
                 SingleChildScrollView(
                    padding: EdgeInsets.only(top:15),
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.73,
                              child: StreamBuilder<List<ContenedorModel>>(
                                stream: _galponBloc.posaStream,
                                builder: (context, snapshot){
                                  if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                  else{
                                    return GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: size.height * 0.3,
                                          childAspectRatio: 2/3,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index){
                                          return GestureDetector(
                                            onTap: () => Navigator.pushNamed(context, 'detalleContenedor', arguments: snapshot.data![index]),
                                            child: Container(
                                              margin: EdgeInsets.all(15),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepOrangeAccent,
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              child: Text(snapshot.data![index].numero.toString()),
                                            ),
                                          );
                                        }
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              child: StreamBuilder<List<ContenedorModel>>(
                                  stream: _galponBloc.posaStream,
                                  builder: (context, snapshot){
                                    return IconButton(onPressed: ()=>_galponBloc.agregarContenedor(galpon, 'POSA'), icon: Icon(Icons.add));
                                  }
                              ),
                            )
                          ],
                        ),
                 ),
                 //JAULAS
                 SingleChildScrollView(
                   padding: EdgeInsets.only(top:15),
                   child: Column(
                     children: [
                       Container(
                         height: size.height * 0.73,
                         child: StreamBuilder<List<ContenedorModel>>(
                           stream: _galponBloc.jaulaStream,
                           builder: (context, snapshot){
                             if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                             else{
                               return GridView.builder(
                                   scrollDirection: Axis.vertical,
                                   shrinkWrap: true,
                                   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                     maxCrossAxisExtent: size.height * 0.3,
                                     childAspectRatio: 2/3,
                                     crossAxisSpacing: 20,
                                     mainAxisSpacing: 20,
                                   ),
                                   itemCount: snapshot.data!.length,
                                   itemBuilder: (context, index){
                                     return GestureDetector(
                                       onTap: () => Navigator.pushNamed(context, 'detalleContenedor', arguments: snapshot.data![index]),
                                       child: Container(
                                         margin: EdgeInsets.all(15),
                                         padding: EdgeInsets.all(10),
                                         decoration: BoxDecoration(
                                             color: Colors.yellowAccent,
                                             borderRadius: BorderRadius.circular(15)
                                         ),
                                         child: Text(snapshot.data![index].numero.toString()),
                                       ),
                                     );
                                   }
                               );
                             }
                           },
                         ),
                       ),
                       Container(
                         height: 100,
                         child: StreamBuilder<List<ContenedorModel>>(
                             stream: _galponBloc.posaStream,
                             builder: (context, snapshot){
                               return IconButton(
                                   onPressed: ()=>_galponBloc.agregarContenedor(galpon, 'JAULA'),
                                   icon: Icon(Icons.add)
                               );
                             }
                         ),
                       )
                     ],
                   ),
                 )
               ]
           ),
         )
    );
  }
}
