import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qowi/src/bloc/login_bloc.dart';

import 'package:qowi/src/disenos/curvas.dart';
import 'package:qowi/src/providers/usuario_provider.dart';
import 'package:qowi/src/services/auth_services.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = AuthServices.of(context).usuarioProvider;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [_fondo(context, size), _loginForm(context, size, usuarioProvider)],
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

  Widget _loginForm(BuildContext context, Size size, UsuarioProvider usuarioProvider) {
    final bloc = new LoginBloc();
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
                                onPressed: snapshot.hasData? () => _login(context, bloc, usuarioProvider):null,
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

  _login(BuildContext context, LoginBloc bloc, UsuarioProvider usuarioProvider) async{
    bool isLogin = await usuarioProvider.signIn(bloc.email, bloc.password);
    if(isLogin) Navigator.pushReplacementNamed(context, 'home');
  }


}