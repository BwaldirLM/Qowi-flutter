import 'package:flutter/material.dart';
import 'package:qowi/src/models/venta_detalle_model.dart';
import 'package:qowi/src/models/venta_model.dart';
import 'package:qowi/src/providers/venta_provider.dart';

class VentaInfoPage extends StatelessWidget {
  const VentaInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final venta = ModalRoute.of(context)!.settings.arguments as VentaModel;
    final _ventaProvider = VentaProvider();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la venta'),
      ),
      body: FutureBuilder<List<VentaDetalleModel>>(
          future: _ventaProvider.detalleVenta(venta),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Container(
                  width: size.width * 0.8,
                  padding: EdgeInsets.all(15),
                  child: Table(border: TableBorder.all(), children: [
                    const TableRow(
                        decoration: BoxDecoration(color: Colors.greenAccent),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cant. cuys'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total final'),
                          )
                        ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${snapshot.data!.length}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('S/. ${_totalFinal(snapshot.data!)}'),
                      )
                    ])
                  ]),
                ),
                const Spacer(),
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.75,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      color: Color(0xffe3f2fd),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            'Proposito',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text('Precio',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500))
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.6,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final detVenta = snapshot.data![index];
                            return Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: const Color(0xfffff59d),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(detVenta.proposito!),
                                  Text('S/. ${detVenta.precio}')
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }

  _totalFinal(List<VentaDetalleModel> data) {
    double tfinal = 0;
    data.forEach((element) {
      tfinal += element.precio!;
    });
    return tfinal;
  }
}
