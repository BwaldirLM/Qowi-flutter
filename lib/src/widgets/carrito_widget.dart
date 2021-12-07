import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';

class CarritoVenta extends StatelessWidget {
  final List<CuyModel> carrito;

  const CarritoVenta({
    Key? key,
    required this.carrito
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
                colors: [Colors.lightGreen, Colors.green]
            )
        ),
        child: Stack(
          children: [
            Positioned.fill(child: Icon(Icons.shopping_cart, size: 35,)),
            Positioned(
                right: 5,
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: Text(
                    '${carrito.length}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
            )
          ],
        ),
      ),
      onTap: () => Navigator.pushNamed(context, 'venta'),
    );
  }
}
