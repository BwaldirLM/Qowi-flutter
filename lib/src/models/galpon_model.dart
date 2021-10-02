import 'dart:convert';

GalponModel galponModelFromJson(String str) => GalponModel.fromJson(json.decode(str));

String galponModelToJson(GalponModel data) => json.encode(data.toJson());
class GalponModel{
  int id;
  String userId;
  String name;

  GalponModel({this.id = 0, this.userId = '', this.name = ''});

  factory GalponModel.fromJson(Map<String, dynamic> json) => new GalponModel(
      id              : json["id"],
      userId          : json["user_id"],
      name            : json['nombre']
  );

  Map<String, dynamic> toJson() => {
    //"user_id"         : id,
    "user_id"     : userId,
    'nombre'  : name

  };
}

ContenedorModel contenedorModelFromJson(String str) => ContenedorModel.fromJson(json.decode(str));

String contenedorModelToJson(ContenedorModel data) => json.encode(data.toJson());
class ContenedorModel{
  int id;
  int galponId;
  int numero;
  String tipo;

  ContenedorModel({this.id = 0, this.galponId = 0, this.numero = 0, this.tipo = ''});

  factory ContenedorModel.fromJson(Map<String, dynamic> json) => new ContenedorModel(
      id              : json["id"],
      galponId        : json["galpon_id"],
      numero          : json['numero'],
      tipo: json['tipo']
  );

  Map<String, dynamic> toJson() => {
    "id"         : id,
    "galpon_id"  : galponId,
    "numero"      :numero,
    "tipo"    : tipo
  };
}