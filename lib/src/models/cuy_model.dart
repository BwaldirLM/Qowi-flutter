import 'dart:convert';

import 'package:qowi/src/models/galpon_model.dart';

CuyModel cuyModelFromJson(String str) => CuyModel.fromJson(json.decode(str));
String cuyModelToJson(CuyModel data) => json.encode(data.toJson());
class CuyModel{
  int? id;
  String? color;
  String? tipo;
  String? genero;
  DateTime? fechaNacimiento;
  DateTime? fechaMuerte;
  bool? estado;
  ContenedorModel? contenedor;
  String? nombre;

  CuyModel({this.id, this.color, this.tipo, this.genero,
      this.fechaNacimiento, this.fechaMuerte, this.estado = true,
    this.contenedor, this.nombre});

  factory CuyModel.fromJson(Map<String, dynamic> json) => new CuyModel(
    id: json['id'],
    color: json['color'],
    tipo: json['tipo'],
    genero: json['genero'],
    estado: json['estado'],
    nombre: json['nombre'],
    //contenedor: json['contenedor']
  );
  Map<String, dynamic> toJson()=>{
    //id
    'color'     : color,
    'tipo'      : tipo,
    'genero'    : genero,
    'fecha_nacimiento'  : fechaNacimiento,
    'fecha_muerte'      : fechaMuerte,
    'estado'            : estado,
    'contenedor'         : contenedor!.id,
    'nombre'            : nombre
  };

  bool esReproductora(){
    return this.tipo == 'reproductora';
  }

  bool esPadrillo(){
    return this.tipo == 'padrillo';
  }

  bool esEngorde() {
    return this.tipo == 'engorde';
  }
}