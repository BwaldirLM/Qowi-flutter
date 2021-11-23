import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/providers/galpon_provider.dart';

class GalponesPage extends StatelessWidget {
  GalponesPage({Key? key}) : super(key: key);
  final _galponProvider = GalponProvider();
  final rn = Random();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Carrito(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(15),
          child: FutureBuilder<List<GalponModel>>(
            future: _galponProvider.cargarGalpon(),
            builder: (context, snapshot){
              if(!snapshot.hasData) {return Center(child: CircularProgressIndicator());}
              else{
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i){
                      return Container(
                        width: 250,
                        height: 200,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(rn.nextInt(255), rn.nextInt(255), rn.nextInt(255), 0.3),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0,5)
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Galpon ${snapshot.data![i].name}'),
                            IconButton(
                              icon: Icon(Icons.zoom_out_map),
                              onPressed: () => Navigator.pushNamed(context, 'galpon', arguments: snapshot.data![i]),
                            )
                          ],
                        ),
                      );

                    }
                );
              }
            },
          ),
        ),
      )
    );
  }
}
