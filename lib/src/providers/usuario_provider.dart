
import 'package:supabase/supabase.dart';
import 'package:qowi/src/models/user_model.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';

class UsuarioProvider {
  final GoTrueClient _client;

  UsuarioProvider(this._client);


  final _prefs = new PreferenciasUsuario();

  final supabaseClint = SupabaseClient(
      'https://gfthknhrvduohibdqdly.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyNzAwOTQ4MiwiZXhwIjoxOTQyNTg1NDgyfQ.759JBbTZUtR01BYkwD59D5nVxDEuet-wOXYL5H_roCU'
  );



  Future<bool> signIn(String email, String password) async {
    final response = await _client.signIn(email: email, password: password);
    if(response.error != null){
      print('Error al inciar sesion');
      return false;
    }else{
      _prefs.supabaseSessionKey = response.data!.persistSessionString;
      return true;
    }
  }

  Future<bool> signUp(String email, String password, UserModel userModel) async {
    final response = await _client.signUp(email, password);

    if (response.error != null) {
      print('Error al registrar');
      return false;
    } else {
      final user = response.data!.user!;
      _prefs.supabaseSessionKey = response.data!.persistSessionString;
      await _createUser(user, userModel);
      return true;
    }
  }

    Future<PostgrestResponse> _createUser(User user,
        UserModel usermodel) async {

      return await supabaseClint.from('app_users')
          .insert([
            {
              'user_id' : user.id,
              'nombres' : usermodel.nombres,
              'apellidos' : usermodel.apellidos,
              'es_nuevo' : true
            }
      ])
          .execute();
    }

    Future<bool> recoverSession()async{
      final jsonStr = _prefs.supabaseSessionKey;
      final response = await _client.recoverSession(jsonStr);
      if(response.error == null){
        _prefs.supabaseSessionKey = response.data!.persistSessionString;
        return true;
      }
      return false;

    }
    Future signOut() async {
      final response = await _client.signOut();
      if(response.error == null) _prefs.clear();
    }
  }

