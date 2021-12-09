import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
import 'package:qowi/src/bloc/galpon_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/widgets/carrito_widget.dart';
import 'package:qowi/src/widgets/menu_flow.dart';


class GalponPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w700);
    final  galpon = ModalRoute.of(context)!.settings.arguments as GalponModel;
    final _galponBloc = GalponBloc();

    final carrito  = Provider.of<CarritoProvider>(context);

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
           body: Stack(
             children: [
               TabBarView(
                   children:[
                     Container(
                       color: Colors.white54,
                       height: size.height * 0.83 - kToolbarHeight,
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
                                   crossAxisSpacing: 15,
                                   mainAxisSpacing: 15,
                                 ),
                                 itemCount: snapshot.data!.length,
                                 itemBuilder: (context, index){
                                   final cuyBloc = CuyBloc();
                                   cuyBloc.cargarCuysContenedor(snapshot.data![index].id);
                                   return GestureDetector(
                                       onTap: () => Navigator.pushNamed(context, 'detalleContenedor', arguments: snapshot.data![index]),
                                       child: Container(
                                         margin: EdgeInsets.all(15),
                                         padding: EdgeInsets.all(10),
                                         decoration: BoxDecoration(
                                             color: Colors.deepOrangeAccent.withOpacity(0.8),
                                             borderRadius: BorderRadius.circular(15),
                                             border: Border.all(
                                                 color: Colors.deepOrangeAccent,
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
                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: [
                                             SizedBox(height: 20),
                                             Container(
                                               padding: EdgeInsets.all(8),
                                               decoration: BoxDecoration(
                                                   color: Colors.cyanAccent,
                                                   borderRadius: BorderRadius.circular(15)
                                               ),
                                               child: Text(
                                                 snapshot.data![index].numero.toString(),
                                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                               ),
                                             ),
                                             Text('Cantidad de cuys'),
                                             StreamBuilder<List<CuyModel>>(
                                               stream: cuyBloc.cuyStream,
                                               builder: (context, snapshot){
                                                 if(snapshot.hasData){
                                                   final galpon = snapshot.data as List<CuyModel>;
                                                   return Text('${galpon.length}');
                                                 }
                                                 else return CircularProgressIndicator();
                                               },
                                             ),
                                             SizedBox(height: 25,)
                                           ],
                                         ),
                                       )
                                   );
                                 }
                             );
                           }
                         },
                       ),
                     ),
                     //JAULAS
                     Container(
                       color: Colors.white54,
                       height: size.height * 0.83 - kToolbarHeight,
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
                                   crossAxisSpacing: 15,
                                   mainAxisSpacing: 15,
                                 ),
                                 itemCount: snapshot.data!.length,
                                 itemBuilder: (context, index){
                                   final cuyBloc = CuyBloc();
                                   cuyBloc.cargarCuysContenedor(snapshot.data![index].id);
                                   return GestureDetector(
                                       onTap: () => Navigator.pushNamed(context, 'detalleContenedor', arguments: snapshot.data![index]),
                                       child: Container(
                                         margin: EdgeInsets.all(15),
                                         padding: EdgeInsets.all(10),
                                         decoration: BoxDecoration(
                                             color: Colors.yellow.withOpacity(0.9),
                                             borderRadius: BorderRadius.circular(15),
                                             border: Border.all(
                                                 color: Colors.yellowAccent,
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
                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: [
                                             SizedBox(height: 20),
                                             Container(
                                               padding: EdgeInsets.all(8),
                                               decoration: BoxDecoration(
                                                   color: Colors.cyanAccent,
                                                   borderRadius: BorderRadius.circular(15)
                                               ),
                                               child: Text(
                                                 snapshot.data![index].numero.toString(),
                                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                               ),
                                             ),
                                             Text('Cantidad de cuys'),
                                             StreamBuilder<List<CuyModel>>(
                                               stream: cuyBloc.cuyStream,
                                               builder: (context, snapshot){
                                                 if(snapshot.hasData){
                                                   final galpon = snapshot.data as List<CuyModel>;
                                                   return Text('${galpon.length}');
                                                 }
                                                 else return CircularProgressIndicator();
                                               },
                                             ),
                                             SizedBox(height: 25,)
                                           ],
                                         ),
                                       )
                                   );
                                 }
                             );
                           }
                         },
                       ),
                     ),
                   ]
               ),
               carrito.cantidad!=0?
                 Positioned(
                   bottom: 25,
                   left: 25,
                   child: CarritoVenta(cantidad: carrito.cantidad),
                 ):SizedBox.shrink(),

             ],
           ),
           floatingActionButton: FlowMenu(
             children: [
               StreamBuilder<List<ContenedorModel>>(
                   stream: _galponBloc.posaStream,
                   builder: (context, snapshot){
                     return FloatingActionButton(
                       heroTag: 'add_posa',
                         onPressed: ()=>_galponBloc.agregarContenedor(galpon, 'POSA'),
                         child: Icon(Icons.add_circle_outline),
                       tooltip: 'Agregar posa',
                     );
                   }
               ),
               StreamBuilder<List<ContenedorModel>>(
                   stream: _galponBloc.posaStream,
                   builder: (context, snapshot){
                     return FloatingActionButton(
                       heroTag: 'add_jaula',
                         onPressed: ()=>_galponBloc.agregarContenedor(galpon, 'JAULA'),
                         child: Icon(Icons.add_circle),
                       tooltip: 'Agregar jaula',
                     );
                   }
               ),
             ],
           ),

         )
    );
  }
//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


  
}
