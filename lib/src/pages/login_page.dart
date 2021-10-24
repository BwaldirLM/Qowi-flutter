import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qowi/src/bloc/login_bloc.dart';

import 'package:qowi/src/disenos/curvas.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:qowi/src/providers/usuario_provider.dart';
import 'package:qowi/src/services/auth_services.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = AuthServices.of(context).usuarioProvider;
    final bloc = new LoginBloc();
    final prefs = PreferenciasUsuario();

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [_fondo(context, size), _loginForm(context, size, usuarioProvider, bloc, prefs), cargando(bloc)],
      ),
    );
  }

  Widget _fondo(BuildContext context, Size size) {
    return Stack(children: [
      EsquinaSuperiorSombra(),
      EsquinaSuperior(),
      EsquinaInferiorSombra(),
      EsquinaInferior()
    ]);
  }

  Widget _loginForm(BuildContext context, Size size, UsuarioProvider usuarioProvider, LoginBloc bloc, PreferenciasUsuario prefs) {

    return SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
                child: Container(
                  height: size.height * 0.25,
                )),
            Text('Qowi',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: size.width * 0.85,
                      margin: EdgeInsets.only(right: size.height * 0.1, top: 30),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                //offset: Offset(0, 5),
                                spreadRadius: 1)
                          ]),
                      child: StreamBuilder(
                          stream: bloc.emailStream,
                          initialData: prefs.email,
                          builder: (context,AsyncSnapshot<String> snapshot) {
                            return TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.email),
                                hintText: 'correo@mail.com',
                                labelText: 'Correo Electrónico',
                                errorText: snapshot.hasError? snapshot.error.toString(): null,
                              ),
                              onChanged: bloc.changeEmail,
                            );
                          }
                      ),

                    ),


                    Container(
                      width: size.width * 0.85,
                      margin: EdgeInsets.only(right: size.height * 0.1),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                                spreadRadius: 3)
                          ]),
                      child: StreamBuilder(
                          stream: bloc.passwordStream,
                          initialData: prefs.password,
                          builder: (context, snapshot) {
                            return TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: 'Contraseña',
                                errorText: snapshot.hasError? snapshot.error.toString(): null,
                              ),
                              onChanged: bloc.changePassword,

                            );
                          }
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(right: size.width * 0.1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                              colors: [Colors.lightGreen, Colors.lightGreenAccent]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                                spreadRadius: 3)
                          ]),
                      child: StreamBuilder(
                          stream: bloc.formValidStream,
                          builder: (context, snapshot) {
                            return IconButton(
                                onPressed: snapshot.hasData? () => _login(context, bloc, usuarioProvider, prefs):null,
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 35,
                                ));
                          }
                      )),
                )
              ],
            ),
            SizedBox(
              height: 150,
            ),
            ElevatedButton(
              child: Container(
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.blue,
                  primary: Colors.white,
                  padding: EdgeInsets.all(10)),
              onPressed: () => Navigator.pushNamed(context, 'register'),
            )
          ],
        ));
  }

  _login(BuildContext context, LoginBloc bloc, UsuarioProvider usuarioProvider, PreferenciasUsuario prefs) async{
    _saveUser(bloc, context, prefs);
    bloc.cargando(true);
    bool isLogin = await usuarioProvider.signIn(bloc.email, bloc.password);
    bloc.cargando(isLogin);

    if(isLogin)
      Navigator.pushReplacementNamed(context, 'home');

  }

  Widget cargando(LoginBloc bloc) {
    return Positioned.fill(
      child: StreamBuilder<bool>(
        stream: bloc.cargandoStream,
        initialData: false,
        builder: (context, snapshot){
          if(!snapshot.data!) return SizedBox.shrink();
          else return Container(
            color: Colors.white30,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }


}

void _saveUser(LoginBloc bloc, BuildContext context, PreferenciasUsuario prefs) {
  if(prefs.email!=null && prefs.password !=null){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('¿Desea guardar correo y contraseña?'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
              ElevatedButton(onPressed: (){
                prefs.email = bloc.email;
                prefs.password = bloc.password;
                Navigator.pop(context);
              }, child: Text('Aceptar'))
            ],
          );
        }
    );
  }

}