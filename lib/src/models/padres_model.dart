import 'dart:convert';

PadresModel contenedorModelFromJson(String str) => PadresModel.fromJson(json.decode(str));

String contenedorModelToJson(PadresModel data) => json.encode(data.toJson());
class PadresModel{
  int id;
  int? padreId;
  int? madreId;
  int? contenedorId;


  PadresModel({this.id = 0, this.padreId, this.madreId, this.contenedorId});

  factory PadresModel.fromJson(Map<String, dynamic> json) => new PadresModel(
      id      : json["id"],
      padreId : json["padre_id"],
      madreId : json['madre_id'],

  );

  Map<String, dynamic> toJson() => {
    //"id"        : id,
    "padre_id"  : padreId,
    "madre_id"  :madreId,

  };
}