import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/login_bloc.dart';

import 'package:qowi/src/disenos/curvas.dart';
import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:qowi/src/providers/usuario_provider.dart';
import 'package:qowi/src/services/auth_services.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioProvider = AuthServices.of(context).usuarioProvider;
    final bloc = LoginBloc();
    final prefs = PreferenciasUsuario();

    final size = MediaQuery.of(context).size;
    if (prefs.password.isNotEmpty) {
      bloc.setPassword(prefs.password);
    }
    return Scaffold(
      body: Stack(
        children: [
          _fondo(context, size),
          _loginForm(context, size, usuarioProvider, bloc, prefs),
          cargando(bloc)
        ],
      ),
    );
  }

  Widget _fondo(BuildContext context, Size size) {
    return Stack(children: [
      const EsquinaSuperiorSombra(),
      const EsquinaSuperior(),
      const EsquinaInferiorSombra(),
      const EsquinaInferior()
    ]);
  }

  Widget _loginForm(
      BuildContext context,
      Size size,
      UsuarioProvider usuarioProvider,
      LoginBloc bloc,
      PreferenciasUsuario prefs) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SafeArea(
            child: Container(
          height: size.height * 0.25,
        )),
        const Text('Qowi',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: size.width * 0.85,
                  margin: EdgeInsets.only(right: size.height * 0.1, top: 30),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: const BoxDecoration(
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
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (prefs.email.isNotEmpty) bloc.setEmail(prefs.email);
                        return TextFormField(
                          initialValue: snapshot.data,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(Icons.email),
                            hintText: 'correo@mail.com',
                            labelText: 'Correo Electrónico',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                          ),
                          onChanged: bloc.changeEmail,
                        );
                      }),
                ),
                Container(
                  width: size.width * 0.85,
                  margin: EdgeInsets.only(right: size.height * 0.1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: const BoxDecoration(
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
                  child: StreamBuilder<String>(
                      stream: bloc.passwordStream,
                      initialData: prefs.password,
                      builder: (context, snapshot) {
                        //if (prefs.password.isNotEmpty)
                        //bloc.setPassword(prefs.password);
                        return TextFormField(
                          initialValue: snapshot.data,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Contraseña',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                          ),
                          onChanged: bloc.changePassword,
                        );
                      }),
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
                      gradient: const LinearGradient(
                          colors: [Colors.lightGreen, Colors.lightGreenAccent]),
                      boxShadow: const [
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
                            onPressed: snapshot.hasData
                                ? () => _login(
                                    context, bloc, usuarioProvider, prefs)
                                : null,
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 35,
                            ));
                      })),
            )
          ],
        ),
        Row(
          children: [
            StreamBuilder<bool>(
              stream: bloc.recordarStream,
              initialData: false,
              builder: (_, snapshot) {
                bloc.recordar(snapshot.data!);
                return Checkbox(
                    value: snapshot.data,
                    onChanged: (value) => bloc.recordar(value!));
              },
            ),
            const Text('Deseo recordar este usuario')
          ],
        ),
        const SizedBox(
          height: 150,
        ),
        ElevatedButton(
          child: Container(
            child: const Text(
              'Registrarse',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.blue,
              primary: Colors.white,
              padding: const EdgeInsets.all(10)),
          onPressed: () => Navigator.pushNamed(context, 'register'),
        )
      ],
    ));
  }

  _login(BuildContext context, LoginBloc bloc, UsuarioProvider usuarioProvider,
      PreferenciasUsuario prefs) async {
    bloc.cargando(true);
    bool isLogin = await usuarioProvider.signIn(bloc.email, bloc.password);
    if (bloc.save) {
      prefs.email = bloc.email;
      prefs.password = bloc.password;
    }
    bloc.cargando(isLogin);
    bloc.cargando(false);

    if (isLogin) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al iniciar sesion'),
        duration: Duration(seconds: 4),
      ));
    }
  }

  Widget cargando(LoginBloc bloc) {
    return Positioned.fill(
      child: StreamBuilder<bool>(
        stream: bloc.cargandoStream,
        initialData: false,
        builder: (context, snapshot) {
          if (!snapshot.data!) {
            return const SizedBox.shrink();
          } else {
            return Container(
              color: Colors.white30,
              child: const Center(child: const CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
