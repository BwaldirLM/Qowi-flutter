import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/nacimiento_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/models/padres_model.dart';
import 'package:qowi/src/widgets/cuy_page_view.dart';
import 'package:qowi/src/widgets/date_picker_widget.dart';

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
    final datePickerKey = GlobalKey<DatePickerWidgetState>();
    bloc.cargarPadres(contenedor);
    bloc.cargarMadres(contenedor);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Nacimiento'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text('PADRE'),
                      SizedBox(
                        height: size.height * 0.4,
                        width: size.width * 0.5,
                        child: StreamBuilder<List<CuyModel>>(
                          stream: bloc.padreStream,
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
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
                      SizedBox(
                        height: size.height * 0.4,
                        width: size.width * 0.5,
                        child: StreamBuilder<List<CuyModel>>(
                          stream: bloc.madreStream,
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
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
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  const Text('Numero de crias'),
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
              Column(
                children: [
                  const Text('Fecha de Nacimiento'),
                  SizedBox(
                      width: size.width * 0.8,
                      height: 50,
                      child: DatePickerWidget(
                        key: datePickerKey,
                      )),
                ],
              ),
              const Divider(),
              /*Column(
                children: [
                  const Text('Incidencias'),
                  StreamBuilder<int>(
                    stream: bloc.cantidadIncStream,
                    initialData: 0,
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
                              bloc.incrementarInc(snapshot.data! - 1);
                            },
                          ),
                          Text('${snapshot.data}',
                              style: const TextStyle(fontSize: 20)),
                          IconButton(
                            icon: Icon(Icons.add),
                            iconSize: size.width * 0.18,
                            padding: EdgeInsets.all(15),
                            splashColor: Colors.blue,
                            splashRadius: 25.0,
                            onPressed: () {
                              bloc.incrementarInc(snapshot.data! + 1);
                            },
                          )
                        ],
                      );
                    },
                  )
                ],
              )*/
            ],
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Registrar'),
          icon: const Icon(Icons.save),
          backgroundColor: Colors.indigoAccent,
          heroTag: 'nacimiento-contenedor',
          onPressed: () {
            PadresModel padres = PadresModel(
                madreId: madre.id,
                padreId: padre.id,
                contenedorId: contenedor.id);
            final date = datePickerKey.currentState!.currentDate;

            bloc.registrarNacimiento(padres, date);
            Navigator.of(context).popUntil((ModalRoute.withName('galpon')));
          },
        ));
  }
}
