import 'dart:convert';

VentaModel ventaModelFromJson(String str) =>
    VentaModel.fromJson(json.decode(str));
String ventaModelToJson(VentaModel data) => json.encode(data.toJson());

class VentaModel {
  int? id;
  DateTime? fecha;
  String userId;

  VentaModel({this.id, this.fecha, required this.userId}) {
    fecha = fecha ?? DateTime.now();
  }

  String toStringFecha() {
    return '${fecha!.day}/${fecha!.month}/${fecha!.year}';
  }

  factory VentaModel.fromJson(Map<String, dynamic> json) => VentaModel(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      userId: json['user_id']);

  Map<String, dynamic> toJson() =>
      {'fecha': fecha.toString(), 'user_id': userId};
}
