import 'package:flutter/material.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _reporte(context, 'Reporte de ventas', const Color(0xFF81C784),
            Icons.sell, 'reporteVentas', size),
        _reporte(context, 'Reporte de nacimientos', const Color(0xFF4DD0E1),
            Icons.family_restroom_outlined, 'ventas', size),
        _reporte(context, 'Reporte de muertes', const Color(0xFFEF5350),
            Icons.nearby_off_sharp, 'ventas', size)
      ],
    );
  }

  Widget _reporte(BuildContext context, String titulo, Color color,
      IconData icon, String ruta, Size size) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ruta),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.18,
              width: size.width * 0.60,
              child: Text(titulo,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              width: size.width * 0.2,
              child: Icon(
                icon,
                size: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
