import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qowi/src/bloc/venta_bloc.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/widgets/venta_item.dart';

class VentaPage extends StatelessWidget {
  const VentaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final size = MediaQuery.of(context).size;
    final ventaBloc = VentaBloc();
    ventaBloc.cargar(carritoProvider.carritoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venta'),
        actions: [
          StreamBuilder<List<CardVenta>>(
              stream: ventaBloc.ventaStream,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: () => _asignarPrecio(context, ventaBloc),
                    icon: const Icon(Icons.border_color_sharp));
              })
        ],
      ),
      body: Container(
        height: size.height - kTextTabBarHeight,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${carritoProvider.cantidad} cuys',
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w700),
            ),
            Expanded(
              //height: size.height*0.9 - kTextTabBarHeight,
              child: StreamBuilder<List<CardVenta>>(
                  stream: ventaBloc.ventaStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final cardVenta = snapshot.data![index];
                            return VentaItem(
                              //key: itemKey,
                              size: size,
                              cardVenta: cardVenta,
                              //saved: cardVenta.saved,
                              //precio: cardVenta.ventaDetalleModel!.precio,
                              onPressed: () {
                                carritoProvider.delete(index);
                              },
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (carritoProvider.listo) {
            carritoProvider.guardarVenta();
            carritoProvider.clear();
            Navigator.of(context).popUntil(ModalRoute.withName('galpon'));
          }
        },
        label: const Text('Confirmar Venta'),
        backgroundColor: Color(0xFF00796B),
      ),
    );
  }
}

void _asignarPrecio(BuildContext context, VentaBloc bloc) {
  late String price;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Modalidad de venta'),
          content: TextField(
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingrese el precio',
                labelText: 'Precio',
                prefixText: 'S/. '),
            keyboardType: TextInputType.number,
            onChanged: (precio) => price = precio,
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () {
                  //carrito.asignarTodo(price);
                  Navigator.of(context).pop(price);
                },
                child: const Text('Aceptar'))
          ],
        );
      }).then((value) {
    if (value != null) bloc.asignarATodo(value);
  });
}
