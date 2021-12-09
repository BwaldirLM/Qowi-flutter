import 'dart:convert';

import 'package:qowi/src/models/cuy_model.dart';

VentaModel ventaModelFromJson(String str) => VentaModel.fromJson(json.decode(str));
String ventaModelToJson(VentaModel data) => json.encode(data.toJson());
class VentaModel{
  int? id;
  DateTime? fecha;

  VentaModel({this.id, this.fecha}){
   fecha = DateTime.now();
  }

  factory VentaModel.fromJson(Map<String, dynamic> json) => new VentaModel(
    id: json['id'],
    fecha: DateTime.parse(json['fecha'])
  );

  Map<String, dynamic> toJson() => {
    'fecha' : fecha.toString()
  };
}