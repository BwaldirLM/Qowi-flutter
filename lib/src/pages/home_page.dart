import 'package:flutter/material.dart';

import 'package:qowi/src/pages/login_page.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:qowi/src/services/auth_services.dart';

class HomePage extends StatelessWidget {


  final _prefs = PreferenciasUsuario();


  @override
  Widget build(BuildContext context) {
    final user = AuthServices.of(context).usuarioProvider.supabaseClint;
    return Scaffold(
      body: Stack(
        children: [_fondo(context), _body(context)],
      )
    );
  }

  Widget _fondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.7,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SafeArea(child: Container(),),
          Text('Bienvenido '+_prefs.username,
            style: TextStyle(
                color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),),
        ],
      ),
    );
  }
}

