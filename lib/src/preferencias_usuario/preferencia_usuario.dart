import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
  new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Genero
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  String get supabaseSessionKey{
    return _prefs.getString('supabaseSessionKey')??'';
  }
  set supabaseSessionKey(String value){
    _prefs.setString('supabaseSessionKey', value);
  }

  String get username{
    return _prefs.getString('username')??'';
  }
  set username(String value){
    _prefs.setString('username', value);
  }
}
