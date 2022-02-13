import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/editar_cuy_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';

class CuyPage extends StatelessWidget {
  late bool isMale;
  @override
  Widget build(BuildContext context) {
    final cuy = ModalRoute.of(context)!.settings.arguments as CuyModel;
    final respaldo = CuyModel.fromJson(cuy.toJson());
    final size = MediaQuery.of(context).size;
    final subtittle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    final bloc = EditarCuyBLoc();
    bloc.cargarCuy(cuy);

    return Scaffold(
      body: Stack(
        children: [
          _fondo(cuy, size),
          _contenido(cuy, bloc, size, subtittle),
          _fechaNacimiento(size, cuy),
          _menu(size, bloc),
          _acciones(size, bloc, cuy)
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bloc.editarCuyStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.close),
            );
          } else {
            if (snapshot.data!) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      bloc.noEditar();
                      cuy.genero = isMale ? 'macho' : 'hembra';
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
                ],
              );
            } else
              return FloatingActionButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Positioned _fechaNacimiento(Size size, CuyModel cuy) {
    return Positioned(
      top: size.height * .4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15))),
        child: Column(
          children: [
            Text('${cuy.fechaNacimiento!.year}'),
            Text('${cuy.fechaNacimiento!.day}/${cuy.fechaNacimiento!.month}')
          ],
        ),
      ),
    );
  }

  Column _contenido(
      CuyModel cuy, EditarCuyBLoc bloc, Size size, TextStyle subtittle) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                height: size.height * 0.4,
                padding: EdgeInsets.all(20),
                child: _imagenCuy(cuy),
              ),
              _etiquetaNombre(cuy, bloc)
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _definirColor(bloc, size, cuy, subtittle),
                  _definirGenero(subtittle, bloc, cuy),
                  _definirTipo(subtittle, cuy),
                ],
              )),
        )
      ],
    );
  }

  Container _definirTipo(TextStyle subtittle, CuyModel cuy) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Tipo', style: subtittle),
          SizedBox(
            width: 100,
          ),
          Text('${cuy.tipo}'),
          Icon(Icons.edit, color: Colors.black45)
        ],
      ),
    );
  }

  Container _definirGenero(
      TextStyle subtittle, EditarCuyBLoc bloc, CuyModel cuy) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Genero', style: subtittle),
          SizedBox(width: 100),
          StreamBuilder<CuyModel>(
              stream: bloc.cuyStream,
              initialData: cuy,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.genero == 'macho')
                    return Icon(Icons.male);
                  else if (snapshot.data!.genero == 'hembra')
                    return Icon(Icons.female);
                  else
                    return StreamBuilder<bool>(
                      stream: bloc.editarCuyStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!) {
                            return StreamBuilder<bool>(
                                stream: bloc.genderStream,
                                initialData: true,
                                builder: (context, snapshot) {
                                  isMale = snapshot.data!;
                                  return Row(
                                    children: [
                                      snapshot.data!
                                          ? Icon(Icons.male)
                                          : Icon(Icons.female),
                                      IconButton(
                                          onPressed: () {
                                            bloc.changeGender(!snapshot.data!);
                                            isMale = snapshot.data!;
                                          },
                                          icon: Icon(Icons.refresh))
                                    ],
                                  );
                                });
                          } else
                            return IconButton(
                                onPressed: () {
                                  bloc.editar();
                                },
                                icon: Icon(Icons.add));
                        } else
                          return SizedBox.shrink();
                      },
                    );
                } else
                  return SizedBox();
              })
        ],
      ),
    );
  }

  Widget _etiquetaNombre(CuyModel cuy, EditarCuyBLoc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<CuyModel>(
            stream: bloc.cuyStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else {
                final cuyTemp = snapshot.data;
                if (cuyTemp!.nombre == null || cuyTemp.nombre!.isEmpty) {
                  return Container(
                    child: Text('${cuyTemp.tipo!.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  );
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${cuyTemp.nombre}',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('${cuyTemp.tipo!.toUpperCase()}',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }
              }
            }),
        StreamBuilder<bool>(
            stream: bloc.editarCuyStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    bloc.editar();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StreamBuilder<CuyModel>(
                              stream: bloc.cuyStream,
                              builder: (context, snapshot) {
                                final cuyTemp = snapshot.data;
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: Text('Cambiar nombre'),
                                  content: TextField(
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Ingrese un nombre'),
                                    onChanged: (value) =>
                                        cuyTemp!.nombre = value,
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Cancelar')),
                                    ElevatedButton(
                                        onPressed: () {
                                          bloc.cambiarNombre(cuyTemp);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok')),
                                  ],
                                );
                              });
                        });
                  },
                  icon: Icon(Icons.edit, color: Colors.black45));
            }),
      ],
    );
  }

  Widget _imagenCuy(CuyModel cuy) {
    if (cuy.esReproductora())
      return Image(
        image: AssetImage('assets/cuy-info.png'),
        fit: BoxFit.cover,
      );
    else if (cuy.esPadrillo())
      return Image(
        image: AssetImage('assets/cuy_cututu_detalle.png'),
        fit: BoxFit.cover,
      );
    else
      return Image(
        image: AssetImage('assets/cuy_cria.png'),
        fit: BoxFit.cover,
      );
  }

  _fondo(CuyModel cuy, Size size) {
    return Positioned(
      top: -size.height * 0.4,
      left: -10,
      child: Container(
        width: size.height * 0.85,
        height: size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.height * 0.85),
          color: _colorFondo(cuy),
        ),
      ),
    );
  }

  Widget _definirColor(
      EditarCuyBLoc bloc, Size size, CuyModel cuy, TextStyle subtittle) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Color', style: subtittle),
          SizedBox(
            width: 100,
          ),
          StreamBuilder<CuyModel>(
              stream: bloc.cuyStream,
              initialData: cuy,
              builder: (context, snapshot) {
                final colores = snapshot.data!.color;
                return SizedBox(
                  child: Column(
                    children: [
                      Text('${colores!['principal']}'),
                      Text('${colores['secundario']}'),
                    ],
                  ),
                );
              }),
          StreamBuilder<bool>(
            stream: bloc.editarCuyStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    bloc.editar();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StreamBuilder<CuyModel>(
                              stream: bloc.cuyStream,
                              initialData: cuy,
                              builder: (context, snapshot) {
                                final cuyTemp = snapshot.data;
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: Text('Seleccionar color'),
                                  content: Container(
                                      height: size.height * 0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Color principal: ${cuyTemp!.color!['principal']}'),
                                          Text(
                                              'Color secundario: ${cuyTemp.color!['secundario']}'),
                                          Divider(),
                                          Text('Color principal'),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () => cuyTemp
                                                          .color!['principal'] =
                                                      'blanco',
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      'Blanco',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => cuyTemp
                                                          .color!['principal'] =
                                                      'castaño',
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    163,
                                                                    87,
                                                                    9,
                                                                    1)),
                                                        color: Color.fromRGBO(
                                                            163, 87, 9, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      'Castaño',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Color(0xFFFFFF00),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text('Bayo',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Negro',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Plomo',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Colors.brown,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text('Chiqchipa',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text('Color secundario'),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Blanco',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color.fromRGBO(
                                                              163, 87, 9, 1)),
                                                      color: Color.fromRGBO(
                                                          163, 87, 9, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Castaño',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Color(0xFFFFFF00),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text('Bayo',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Negro',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Plomo',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.brown),
                                                      color: Colors.brown,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text('Chiqchipa',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(3),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              'Ninguno',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      )),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Cancelar')),
                                    ElevatedButton(
                                        onPressed: () {
                                          bloc.cambiarNombre(cuyTemp);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok')),
                                  ],
                                );
                              });
                        }).then((value) => print(value));
                  },
                  icon: Icon(Icons.edit, color: Colors.black45));
            },
          )
        ],
      ),
    );
  }

  Color _colorFondo(CuyModel cuy) {
    if (cuy.esReproductora())
      return Colors.blue;
    else if (cuy.esPadrillo())
      return Colors.green;
    else
      return Color.fromRGBO(202, 184, 255, 1);
  }

  Widget _menu(Size size, EditarCuyBLoc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.editarCuyStream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data!)
          return SizedBox.shrink();
        else
          return Positioned(
              bottom: size.height * 0.02,
              right: size.width * 0.015,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                  child: Icon(Icons.menu, size: 40),
                ),
                onTap: () {
                  bloc.cambiarMenu(true);
                },
              ));
      },
    );
  }

  Widget _acciones(Size size, EditarCuyBLoc bloc, CuyModel cuy) {
    return StreamBuilder<bool>(
        stream: bloc.menuStream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data!)
            return Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  //color: Colors.blueAccent,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.blueAccent])),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(),
                    _accion('Vender'),
                    GestureDetector(
                      child: _accion('Reportar muerte'),
                      onTap: () {
                        late String incidencia;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Incidencia de muerte'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                content: StreamBuilder<String>(
                                  stream: bloc.incidenciaStream,
                                  initialData: 'repentina',
                                  builder: (context, snapshot) {
                                    incidencia = snapshot.data!;
                                    return DropdownButton(
                                      value: snapshot.data,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('Al nacer'),
                                          value: 'murio al nacer',
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Al parir'),
                                          value: 'pariendo',
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Repentina'),
                                          value: 'repentina',
                                        )
                                      ],
                                      onChanged: (opt) {
                                        bloc.changeIncidencia(opt as String);
                                        incidencia = opt;
                                      },
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        cuy.fechaMuerte = DateTime.now();
                                        cuy.estado = false;
                                        bloc.newIncidencia(cuy, incidencia);
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName('galpon'));
                                      },
                                      child: Text('Reportar'))
                                ],
                              );
                            });
                      },
                    ),
                    InkWell(
                      onTap: () => bloc.cambiarMenu(false),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          border: Border.all(
                            color: Colors.cyan,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Cerrar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          else
            return SizedBox.shrink();
        });
  }

  Widget _accion(String accion) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.cyan,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        accion,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
