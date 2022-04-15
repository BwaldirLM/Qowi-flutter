import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qowi/src/models/venta_model.dart';
import 'package:qowi/src/providers/venta_provider.dart';

class ReporteVentaPage extends StatelessWidget {
  const ReporteVentaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ventasProvider = VentaProvider();
    return Scaffold(
      appBar: AppBar(title: Text('Reporte de ventas')),
      body: FutureBuilder(
        future: _ventasProvider.obtenerVentas(),
        builder: (context, AsyncSnapshot<List<VentaModel>> snapshot) {
          if (snapshot.hasData) {
            final ventas = snapshot.data;
            return ListView.builder(
              itemCount: ventas!.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.piano_outlined),
                title: Text('Venta'),
                subtitle: Text(ventas[index].toStringFecha()),
                onTap: () => Navigator.pushNamed(context, 'ventaInfo',
                    arguments: ventas[index]),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
