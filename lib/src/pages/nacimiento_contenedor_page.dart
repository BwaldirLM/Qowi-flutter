import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/nacimiento_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/models/padres_model.dart';
import 'package:qowi/src/widgets/cuy_page_view.dart';

class NacimientoContenedorPage extends StatelessWidget {
  const NacimientoContenedorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contenedor =
        ModalRoute.of(context)!.settings.arguments as ContenedorModel;
    final size = MediaQuery.of(context).size;
    final bloc = NacimientoBloc();
    late CuyModel padre;
    late CuyModel madre;
    bloc.cargarPadres(contenedor);
    bloc.cargarMadres(contenedor);
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrar Nacimiento'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('PADRE'),
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.5,
                      child: StreamBuilder<List<CuyModel>>(
                        stream: bloc.padreStream,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            padre = snapshot.data!.first;
                            return CuyPageView(
                              cuyList: snapshot.data!,
                              onPageChanged: (page) {
                                padre = snapshot.data![page];
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('MADRE'),
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.5,
                      child: StreamBuilder<List<CuyModel>>(
                        stream: bloc.madreStream,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            madre = snapshot.data!.first;
                            return CuyPageView(
                              cuyList: snapshot.data!,
                              onPageChanged: (page) {
                                madre = snapshot.data![page];
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //const SizedBox(height: 50,),
            Container(
              child: Column(
                children: [
                  Text('Numero de crias'),
                  StreamBuilder<int>(
                    stream: bloc.cantidadStream,
                    initialData: 1,
                    builder: (_, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            iconSize: size.width * 0.18,
                            padding: EdgeInsets.all(15),
                            splashColor: Colors.red,
                            splashRadius: 25.0,
                            onPressed: () {
                              bloc.incrementar(snapshot.data! - 1);
                            },
                          ),
                          Text('${snapshot.data}',
                              style: TextStyle(fontSize: 20)),
                          IconButton(
                            icon: Icon(Icons.add),
                            iconSize: size.width * 0.18,
                            padding: EdgeInsets.all(15),
                            splashColor: Colors.blue,
                            splashRadius: 25.0,
                            onPressed: () {
                              bloc.incrementar(snapshot.data! + 1);
                            },
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton:FloatingActionButton.extended(
          label: Text('Registrar'),
          icon: Icon(Icons.save),
          backgroundColor: Colors.indigoAccent,
          heroTag: 'nacimiento-contenedor',
          onPressed: () {
            PadresModel padres = PadresModel(
                madreId: madre.id,
                padreId: padre.id,
                contenedorId: contenedor.id);

            bloc.registrarNacimiento(padres);
            Navigator.of(context).popUntil((ModalRoute.withName('galpon')));
          },
        )
    );
  }
}
