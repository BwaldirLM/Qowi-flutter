import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/widgets/venta_item.dart';

class VentaPage extends StatelessWidget {
  const VentaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Venta'),
      ),
      body: Container(
        height: size.height-kTextTabBarHeight,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${carritoProvider.cantidad} cuys', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),),
            Expanded(
              //height: size.height*0.9 - kTextTabBarHeight,
              child: ListView.builder(
                  itemCount: carritoProvider.cantidad,
                  itemBuilder: (context, index){
                    final cardVenta = carritoProvider.carritoProvider[index];

                    return VentaItem(
                      //key: itemKey,
                        size: size,
                        cardVenta: cardVenta,
                        //saved: cardVenta.saved,
                        onPressed: (){
                          carritoProvider.delete(index);
                      },
                    );
                  }
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(carritoProvider.listo){
              carritoProvider.guardarVenta();
              carritoProvider.clear();
              Navigator.of(context).popUntil(ModalRoute.withName('galpon'));
            }
          },
          label: Text('Confirmar Venta'),
          backgroundColor: Color(0xFF00796B),
      ),

    );
  }
}


