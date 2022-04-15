import 'dart:convert';

VentaDetalleModel ventaDetalleModelFromJson(String str) =>
    VentaDetalleModel.fromJson(json.decode(str));
String ventaDetalleModelToJson(VentaDetalleModel data) =>
    json.encode(data.toJson());

class VentaDetalleModel {
  int? id;
  double? precio;
  String? proposito;
  int? cuyId;
  int? ventaId;

  VentaDetalleModel(
      {this.id, this.precio, this.proposito, this.cuyId, this.ventaId});

  factory VentaDetalleModel.fromJson(Map<String, dynamic> json) =>
      VentaDetalleModel(
          id: json['id'],
          precio: double.parse(json['precio'].toString()),
          proposito: json['proposito'],
          cuyId: json['cuy_id'],
          ventaId: json['venta_id']);

  Map<String, dynamic> toJson() => {
        'precio': precio,
        'proposito': proposito,
        'cuy_id': cuyId,
        'venta_id': ventaId
      };
}
