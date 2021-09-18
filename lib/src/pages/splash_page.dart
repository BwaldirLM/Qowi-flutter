import 'package:flutter/material.dart';
import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/pages/home_page.dart';
import 'package:qowi/src/pages/login_page.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:supabase/supabase.dart';

const persistentSessionKey = 'persistentSessionKey';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    authentication();
  }

  Future<void> authentication() async {
    final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
    final prefs = PreferenciasUsuario();
    final session = prefs.supabaseSessionKey;

    if (session == null) {
      redirectToLogin();
      return;
    } else {
      final response = await supabaseClient.auth.recoverSession(session);
      if (response.data == null) {
        redirectToLogin();
      } else {
        prefs.supabaseSessionKey = response.data!.persistSessionString;
      }
    }

    final user = supabaseClient.auth.user();
    if (user == null) {
      // redirect to login
      redirectToLogin();
    } else {
      final username = await supabaseClient.
      from('app_users').
          select('nombres').
          eq('user_id', user.id).execute();
      if(username.data == null) redirectToLogin();
      else{
        prefs.username = username.data[0]['nombres'];
        redirectToHome();
      }
    }
  }

  void redirectToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void redirectToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
          child: CircularProgressIndicator()
          ),
        )
    );
  }
}