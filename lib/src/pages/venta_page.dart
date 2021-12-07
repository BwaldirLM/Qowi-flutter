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
    final carrito = Provider.of<Carrito>(context);
    final size = MediaQuery.of(context).size;
    List<GlobalKey<VentaItemState>> globalKeyList = [];
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
            Text('${carrito.cantidad} cuys', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),),
            Expanded(
              //height: size.height*0.9 - kTextTabBarHeight,
              child: ListView.builder(
                  itemCount: carrito.cantidad,
                  itemBuilder: (context, index){
                    final cuy = carrito.carrito[index];
                    final itemKey = GlobalKey<VentaItemState>();
                    globalKeyList.add(itemKey);
                    return VentaItem(
                      //key: itemKey,
                        size: size,
                        cuy: cuy,
                        onPressed: (){
                          carrito.delete(cuy);
                      },
                    );
                  }
              ),
            )
          ],
        ),
      ),

    );
  }
}


