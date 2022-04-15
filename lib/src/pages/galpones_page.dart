import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';
import 'package:qowi/src/models/galpon_model.dart';
import 'package:qowi/src/providers/cuy_provider.dart';
import 'package:qowi/src/providers/galpon_provider.dart';

class GalponesPage extends StatelessWidget {
  GalponesPage({Key? key}) : super(key: key);
  final _galponProvider = GalponProvider();
  final _cuyProvider = CuyProvider();
  final rn = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<GalponModel>>(
          future: _galponProvider.cargarGalpon(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () => Navigator.pushNamed(context, 'galpon',
                          arguments: snapshot.data![i]),
                      child: Container(
                        width: 250,
                        height: 200,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(rn.nextInt(255),
                                rn.nextInt(255), rn.nextInt(255), 0.3),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Galpon ${snapshot.data![i].name}',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            FutureBuilder<List<CuyModel>>(
                                future: _cuyProvider.CuysPorGalpon(
                                    snapshot.data![i].id),
                                builder: (_, sn) {
                                  if (sn.hasData) {
                                    return Text('${sn.data!.length} cuys');
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
