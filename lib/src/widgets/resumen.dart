import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/cuy_bloc.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';

class Resume extends StatelessWidget {
  const Resume({Key? key, required this.bloc, required this.contenedor}) : super(key: key);
  final CuyBloc bloc;
  final ContenedorModel contenedor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CuyModel>>(
      stream: bloc.cuyStream,
      builder: (_, snapshot){
        int cuysTipo(String tipo){
          int i = 0;
          snapshot.data!.forEach((element){
            if(element.tipo == tipo) i++;
          });
          return i;
        }
        int cuysNull(){
          int i = 0;
          snapshot.data!.forEach((element){
            if(element.tipo == null) i++;
          });
          return i;
        }
        if(snapshot.hasData) return Stack(
          children: [
            PieChart(
                PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        //title: 'Reproductora',
                        //badgePositionPercentageOffset: 0,
                        badgeWidget: cuysTipo('reproductora')!=0?Text(
                          '${cuysTipo('reproductora')} reproductoras',
                          style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
                        ):null,
                        color: Colors.deepPurple,
                        value: (cuysTipo('reproductora')* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 25,
                      ),
                      PieChartSectionData(
                        badgeWidget: cuysTipo('padrillo')!=0?Text(
                          '${cuysTipo('padrillo')} padrillos',
                          style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
                        ):null,
                        color: Color(0xFF26E5FF),
                        value: (cuysTipo('padrillo')* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 22,
                      ),
                      PieChartSectionData(
                        badgeWidget: cuysTipo('engorde')!=0?Text(
                          '${cuysTipo('engorde')} engordes',
                          style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
                        ):null,
                        color: Color(0xFFFFCF26),
                        value: (cuysTipo('engorde')* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 19,
                      ),
                      PieChartSectionData(
                        badgeWidget: cuysTipo('gasapo')!=0?Text(
                          '${cuysTipo('gasapo')} gasapos',
                          style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
                        ):null,
                        color: Color(0xFFEE2727),
                        value: (cuysTipo('gasapo')* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 16,
                      ),
                      PieChartSectionData(
                        badgeWidget: cuysTipo('cria')!=0?Text(
                          '${cuysTipo('cria')} crias',
                          style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
                        ):null,
                        color: Colors.blue,
                        value: (cuysTipo('cria')* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 12,
                      ),
                      PieChartSectionData(
                        badgeWidget: cuysNull()!=0?Text(
        '${cuysTipo('reproductora')} Reproductoras',
        style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen),
        ):null,
                        color: Colors.grey,
                        value: (cuysNull()* 100)/snapshot.data!.length,
                        showTitle: false,
                        radius: 10,
                      )
                    ],

                )
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('${snapshot.data!.length}',
                      style: TextStyle(fontWeight: FontWeight.w600,height: 0.5, fontSize: 20)),
                  Text('cuys')
                ],
              ),
            ),
          ],
        );
        else return Center(child: CircularProgressIndicator(),);
      },
    );


  }
}



