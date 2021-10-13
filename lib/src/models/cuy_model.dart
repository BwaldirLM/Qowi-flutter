import 'dart:convert';

CuyModel cuyModelFromJson(String str) => CuyModel.fromJson(json.decode(str));
String cuyModelToJson(CuyModel data) => json.encode(data.toJson());
class CuyModel{
  int? id;
  Map<String,dynamic>? color;
  String? tipo;
  String? genero;
  DateTime? fechaNacimiento;
  DateTime? fechaMuerte;
  bool? estado;
  int? contenedor;
  String? nombre;
  int? padresId;

  CuyModel({this.id, this.color, this.tipo, this.genero,
      this.fechaNacimiento, this.fechaMuerte, this.estado = true,
    this.contenedor, this.nombre, this.padresId}){
    if(fechaNacimiento == null) fechaNacimiento = DateTime(2021);
    if(color == null) color = {
      'principal'  : '',
      'secundario' : 'ninguno'

    };
  }

  factory CuyModel.fromJson(Map<String, dynamic> json) => new CuyModel(
    id: json['id'],
    color: json['color'],
    tipo: json['tipo'],
    genero: json['genero'],
    fechaNacimiento: DateTime.parse(json['fecha_nacimiento']??'2021-01-01'),
    estado: json['estado'],
    nombre: json['nombre'],
    contenedor: json['contenedor'],
    padresId: json['padres_id']
  );
  Map<String, dynamic> toJson()=>{
    //id
    'color'     : color,
    'tipo'      : tipo,
    'genero'    : genero,
    'fecha_nacimiento'  : fechaNacimiento.toString(),
    'fecha_muerte'      : fechaMuerte,
    'estado'            : estado,
    'contenedor'        : contenedor,
    'nombre'            : nombre,
    'padres_id'          : padresId
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