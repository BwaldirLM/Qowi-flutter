import 'package:flutter/material.dart';
import 'package:qowi/src/models/cuy_model.dart';

class CuyPageView extends StatelessWidget {
  const CuyPageView({
    required this.cuyList,
    required this.onPageChanged,
    Key? key,
  }) : super(key: key);

  final List<CuyModel> cuyList;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: cuyList.length,
        itemBuilder: (_, index) {
          final cuy = cuyList[index];
          return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text('$index'), Text('${cuy.nombre ?? cuy.tipo}')],
              ));
        },
        onPageChanged: onPageChanged);
  }
}
