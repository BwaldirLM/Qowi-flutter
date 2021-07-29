import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  String id;
  bool esNuevo;
  String nombres;
  String apellidos;

  UserModel(
    {
      this.id = '',
      this.esNuevo = true,
      this.nombres = '',
      this.apellidos = ''
    }
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
    id              : json["id_user"],
    esNuevo         : json["es_nuevo"],
    nombres         : json["nombres"],
    apellidos       : json["apellidos"]
  );

  Map<String, dynamic> toJson() => {
    //"user_id"         : id,
    "es_nuevo"     : true,
    "nombres"      : nombres,
    "apellidos" : apellidos
  };



}