import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cuyBloc = CuyBloc();

    cuyBloc.cargarCuys();

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.2,
                        spreadRadius: .2,
                        offset: Offset(2, 5))
                  ]),
              child: StreamBuilder<List<CuyModel>>(
                  stream: cuyBloc.cuyStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());
                    else {
                      int cuysTipo(String tipo) {
                        int i = 0;
                        snapshot.data!.forEach((element) {
                          if (element.tipo == tipo) i++;
                        });
                        return i;
                      }

                      return Column(
                        children: [
                          const Text('Resumen',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15),
                          SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  PieChart(PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 70,
                                      startDegreeOffset: -90,
                                      sections: [
                                        PieChartSectionData(
                                          color: Colors.deepPurple,
                                          value:
                                              (cuysTipo('reproductora') * 100) /
                                                  snapshot.data!.length,
                                          showTitle: false,
                                          radius: 25,
                                        ),
                                        PieChartSectionData(
                                          color: const Color(0xFF26E5FF),
                                          value: (cuysTipo('padrillo') * 100) /
                                              snapshot.data!.length,
                                          showTitle: false,
                                          radius: 22,
                                        ),
                                        PieChartSectionData(
                                          color: const Color(0xFF76FF03),
                                          value: (cuysTipo('recria') * 100) /
                                              snapshot.data!.length,
                                          showTitle: false,
                                          radius: 20,
                                        ),
                                        PieChartSectionData(
                                          color: const Color(0xFFFFCF26),
                                          value: (cuysTipo('engorde') * 100) /
                                              snapshot.data!.length,
                                          showTitle: false,
                                          radius: 19,
                                        ),
                                        PieChartSectionData(
                                          color: const Color(0xFFEE2727),
                                          value: (cuysTipo('gasapo') * 100) /
                                              snapshot.data!.length,
                                          showTitle: false,
                                          radius: 16,
                                        ),
                                        PieChartSectionData(
                                          color: Colors.blue,
                                          value: (cuysTipo('cria') * 100) /
                                              snapshot.data!.length,
                                          showTitle: false,
                                          radius: 12,
                                        ),
                                      ])),
                                  Positioned.fill(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text('${snapshot.data!.length}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                height: 0.5,
                                                fontSize: 20)),
                                        const Text('cuys')
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          _tipoCuy(Colors.deepPurple, 'Reproductoras',
                              cuysTipo('reproductora')),
                          _tipoCuy(const Color(0xFF26E5FF), 'Padrillos',
                              cuysTipo('padrillo')),
                          _tipoCuy(const Color(0xFF76FF03), 'Recrias',
                              cuysTipo('recria')),
                          _tipoCuy(const Color(0xFFFFCF26), 'Engorde',
                              cuysTipo('engorde')),
                          _tipoCuy(const Color(0xFFEE2727), 'Gasapos',
                              cuysTipo('gasapo')),
                          _tipoCuy(Colors.blue, 'Crias', cuysTipo('cria')),
                        ],
                      );
                    }
                  })),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.indigo)),
              child: Table(
                children: [
                  TableRow(children: [
                    _accion(context, 'venta', 'venta', Colors.green),
                    _accion(
                        context, 'nacimiento', 'Nuevo nacimiento', Colors.amber)
                  ])
                ],
              ))
        ],
      ),
    ));
  }

  Widget _tipoCuy(Color color, String tipo, int cantidad) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black45),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Icon(Icons.circle, color: color),
          ),
          const SizedBox(width: 20),
          Text(tipo),
          const Expanded(child: const SizedBox()),
          Text('$cantidad'),
          const SizedBox(width: 20)
        ],
      ),
    );
  }

  Widget _accion(
      BuildContext context, String page, String texto, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: color, blurRadius: 15, spreadRadius: 5)
          ]),
      child: Column(
        children: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, page),
              icon: const Icon(Icons.add)),
          Text(texto)
        ],
      ),
    );
  }
}
