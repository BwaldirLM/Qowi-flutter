
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/editar_cuy_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';

class CuyPage extends StatelessWidget {
  const CuyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cuy = ModalRoute.of(context)!.settings.arguments as CuyModel;
    final respaldo = CuyModel.fromJson(cuy.toJson());
    //final respaldo = cuy;
    //final cuy = CuyModel();
    //cuy.nombre = 'Benito';
    //cuy.fechaNacimiento = DateTime.now();
    //cuy.tipo = 'padrillo';
    final size = MediaQuery.of(context).size;
    final subtittle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    final bloc = EditarCuyBLoc();
    bloc.cargarCuy(cuy);
    
    return Scaffold(
      body: Stack(
        children: [
          _fondo(cuy, size),
          SafeArea(
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                          child: _imagenCuy(cuy),
                      ),
                      _etiquetaNombre(cuy, bloc)
                    ],
                  ),
                ),
                Divider(),
                Container(
                  height: size.height * .4,
                  child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          _definirColor(bloc, size, cuy, subtittle),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Genero', style: subtittle),
                                SizedBox(width: 100),
                                StreamBuilder<CuyModel>(
                                  stream: bloc.cuyStream,
                                    builder: (context, snapshot){
                                      if(!snapshot.hasData)
                                        return Center(child: CircularProgressIndicator());
                                      else{
                                        final cuyTemp = snapshot.data;
                                        if(cuyTemp!.genero == 'hembra')
                                          return Icon(Icons.female);
                                        else if(cuyTemp.genero == 'macho')
                                          return Icon(Icons.male);
                                        else if(cuyTemp.genero == null){
                                          if(cuyTemp.tipo == 'padrillo'){
                                            cuyTemp.genero = 'macho';
                                            bloc.editar();
                                            return Icon(Icons.male);
                                          }else if(cuyTemp.tipo == 'reproductora'){
                                            cuyTemp.genero = 'hembra';
                                            bloc.editar();
                                            return Icon(Icons.female);
                                          }else if(cuyTemp.tipo == 'engorde'){
                                            return Row(
                                              children: [
                                                Icon(Icons.male),
                                                Icon(Icons.assistant_direction)
                                              ],
                                            );
                                          }
                                          else return Container();

                                        }else return Icon(Icons.settings);
                                      }
                                    }
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Tipo', style: subtittle),
                                SizedBox(width: 100,),
                                Text('${cuy.tipo}'),
                                Icon(Icons.edit, color: Colors.black45)
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Fecha de \nnacimiento', style: subtittle),
                                SizedBox(width: 70),
                                _fechaSalida(cuy.fechaNacimiento),
                                Icon(Icons.edit, color: Colors.black45)
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                )
              ],
            )
          ),
          Positioned(
            top: size.height * .4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)
                )
              ),
              child: Column(
                children: [
                  Text('2021'),
                  Text('20/09')
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bloc.editarCuyStream,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.close),
            );
          }else{
            if(snapshot.data == true){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: (){
                      bloc.noEditar();
                      bloc.updateCuy(cuy);
                    },
                    child: Icon(Icons.save_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      bloc.noEditar();
                      print(respaldo.nombre);
                      bloc.cargarCuy(respaldo);
                    },
                    child: Icon(Icons.cancel),

                  ),

                ],);
            }
            else return FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.close),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Widget _etiquetaNombre(CuyModel cuy, EditarCuyBLoc bloc) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<CuyModel>(
          stream: bloc.cuyStream,
            builder: (context, snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              else{
                final cuyTemp = snapshot.data;
                if(cuyTemp!.nombre == null || cuyTemp.nombre!.isEmpty){
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${cuyTemp.tipo!.toUpperCase()}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                      ],
                    ),
                  );
                }
                else{
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${cuyTemp.nombre}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('${cuyTemp.tipo!.toUpperCase()}', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }
              }
            }
        ),
        StreamBuilder<bool>(
            stream: bloc.editarCuyStream,
            builder: (context, snapshot){

              return IconButton(
                  onPressed: (){
                    bloc.editar();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context){
                          return StreamBuilder<CuyModel>(
                            stream: bloc.cuyStream,
                              builder: (context, snapshot){
                              final cuyTemp = snapshot.data;
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  title: Text('Cambiar nombre'),
                                  content: TextField(
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Ingrese un nombre'
                                    ),
                                    onChanged: (value) => cuyTemp!.nombre = value,
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
                                    ElevatedButton(
                                        onPressed: () {
                                            bloc.cambiarNombre(cuyTemp);
                                            Navigator.of(context).pop();
                                          }
                                      , child: Text('Ok')),
                                  ],
                                );
                              }
                          );
                        }
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.black45)
              );
            }
        ),
      ],
    );
  }

  Widget _fechaSalida(DateTime? fecha) {
    if(fecha != null)
      return Text('${fecha.day}-${fecha.month}-${fecha.year}');
    else
      return Icon(Icons.add);
  }

  Widget _imagenCuy(CuyModel cuy) {
    if(cuy.esReproductora()) return Image(
      image: AssetImage('assets/cuy-info.png'),
      fit: BoxFit.cover,
    );
    else if( cuy.esPadrillo())return Image(
      image: AssetImage('assets/cuy_cututu_detalle.png'),
      fit: BoxFit.cover,
    );
    else return Image(
        image: AssetImage('assets/cuy_cria.png'),
        fit: BoxFit.cover,
      ); 
  }

  _fondo(CuyModel cuy, Size size) {
    return Positioned(
      top: -size.height * 0.4,
      left: -10,
      child: Container(
        width: size.height * 0.85 ,
        height: size.height * 0.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.height * 0.85),
            color: _colorFondo(cuy),
        ),
      ),
    );
  }

  Widget _definirColor(EditarCuyBLoc bloc, Size size,CuyModel cuy ,TextStyle subtittle) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Color', style: subtittle),
          SizedBox(width: 100,),
          StreamBuilder<CuyModel>(
            stream: bloc.cuyStream,
              initialData: cuy,
              builder: (context, snapshot){
              final colores = snapshot.data!.color;
                return SizedBox(
                  child: Column(
                    children: [
                      Text('${colores!['principal']}'),
                      Text('${colores['secundario']}'),
                    ],
                  ),
                );
              }
          ),
          StreamBuilder<bool>(
            stream: bloc.editarCuyStream,
            builder: (context, snapshot){
              return IconButton(
                  onPressed: (){
                    bloc.editar();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context){
                          return StreamBuilder<CuyModel>(
                              stream: bloc.cuyStream,
                              initialData: cuy,
                              builder: (context, snapshot){
                                final cuyTemp = snapshot.data;
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  title: Text('Seleccionar color'),
                                  content: Container(
                                    height: size.height*0.4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Color principal: ${cuyTemp!.color!['principal']}'),
                                          Text('Color secundario: ${cuyTemp.color!['secundario']}'),
                                          Divider(),
                                          Text('Color principal'),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap:()=> cuyTemp.color!['principal']='blanco',
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black),
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Text('Blanco', style: TextStyle(fontWeight: FontWeight.w700),),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap:()=> cuyTemp.color!['principal']='castaño',
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Color.fromRGBO(163, 87, 9, 1)),
                                                        color: Color.fromRGBO(163, 87, 9, 1),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Text('Castaño', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                  ),
                                                ),

                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Color(0xFFFFFF00),
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Bayo', style: TextStyle(fontWeight: FontWeight.w700)),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Negro', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Plomo', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Colors.brown,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Chiqchipa', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Text('Color secundario'),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Blanco', style: TextStyle(fontWeight: FontWeight.w700),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Color.fromRGBO(163, 87, 9, 1)),
                                                      color: Color.fromRGBO(163, 87, 9, 1),
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Castaño', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Color(0xFFFFFF00),
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Bayo', style: TextStyle(fontWeight: FontWeight.w700)),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Negro', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Plomo', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.brown),
                                                      color: Colors.brown,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Text('Chiqchipa', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(3),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Text('Ninguno', style: TextStyle(fontWeight: FontWeight.w700),),
                                          ),

                                        ],
                                      )
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
                                    ElevatedButton(
                                        onPressed: () {
                                          //bloc.cambiarNombre(cuyTemp);
                                          Navigator.of(context).pop();
                                        }
                                        , child: Text('Ok')),
                                  ],
                                );
                              }
                          );
                        }
                    ).then((value) => print(value));
                  },
                  icon: Icon(Icons.edit, color: Colors.black45)
              );
            },
          )
        ],
      ),
    );
  }

  Color _colorFondo(CuyModel cuy) {
    if(cuy.esReproductora()) return Colors.blue;
    else if(cuy.esPadrillo()) return Colors.green;
    else return Color.fromRGBO(202, 184, 255, 1);
  }

}
