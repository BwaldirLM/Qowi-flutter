import 'package:flutter/material.dart';
import 'package:qowi/src/bloc/login_bloc.dart';
import 'package:qowi/src/disenos/curvas.dart';
import 'package:qowi/src/models/user_model.dart';
import 'package:qowi/src/providers/usuario_provider.dart';
import 'package:qowi/src/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  UserModel user = new UserModel();
  late String email;
  late String password;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final usuarioProvider = AuthServices.of(context).usuarioProvider;

    return Scaffold(
      body: Stack(
        children: [_fondo(), register(context, size, usuarioProvider)],
      ),
    );
  }

  Widget _fondo() {
    return Stack(
      children: [
        EsquinaSuperiorSombra(),
        EsquinaSuperior(),
        EsquinaInferiorSombra(),
        EsquinaInferior()
      ],
    );
  }

  Widget register(BuildContext context, Size size, UsuarioProvider usuarioProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
                height: size.height * 0.25,
              )),
          Text(
            'Nuevo Usuario',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _crearNombre(size),
                  _crearApellido(size),
                  _crearEmail(size),
                  _crearContrasena(size),
                  _crearBoton(usuarioProvider)
                ],
              ),
            ),
          ),
        ],
      )

    );
  }

  Widget _crearNombre(Size size) {
    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.only(top: 30, right: size.height * 0.075),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                //blurRadius: 3,
                spreadRadius: 1
            )
          ]
      ),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person_outline),
          labelText: 'Nombres',
        ),
        onSaved: (value) => user.nombres = value!,
        validator: (value){
          if(value!.isEmpty) return 'Este campo es obligatorio';
        },
      ),
    ) ;

  }

  Widget _crearApellido(Size size) {
    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.only(right: size.height * 0.075),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                //blurRadius: 3,
                spreadRadius: 1
            )
          ]
      ),
      child: TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.person_outline),
            labelText: 'Apellidos',
          ),
        onSaved: (value) => user.apellidos=value!,
        validator: (value){
            if(value!.isEmpty) return 'Este campo es obligatorio';
        },
      )
    );
  }

  Widget _crearEmail(Size size) {
    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.only(right: size.height * 0.075),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                //blurRadius: 3,
                spreadRadius: 1
            )
          ]
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.alternate_email),
            labelText: 'Correo Electrónico',
            hintText:  'correo@mail.com',
        ),
        onSaved: (value) => email = value!,
        validator: (value){
          RegExp regExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
          if(!regExp.hasMatch(value!))
            return 'Email no es correcto';
        },
      ),
    );
  }

  Widget _crearContrasena(Size size) {
    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.only(right: size.height * 0.075),
      //padding: EdgeInsets.symmetric(horizontal: 10),
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
          ]
      ),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Contraseña',
        ),
        onSaved: (value) => password = value!,
        validator: (value){
          if(value!.length < 6) return 'Debe ser al menos de seis caracteres';
        },
      ),
    );
  }

  _crearBoton(UsuarioProvider usuarioProvider) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: ElevatedButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              formKey.currentState!.save();
              final success = await usuarioProvider.signUp(email, password, user);
              if(success) Navigator.pushReplacementNamed(context, 'home');
            }

          },
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black26,
            elevation: 20,
          ),
          child: Text('Registrar'),
        )
    );
  }
}



/*class RegisterPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [_fondo(), _register(context, size)]),
    );
  }

  Widget _fondo() {
    return Stack(
      children: [
        EsquinaSuperiorSombra(),
        EsquinaSuperior(),
        EsquinaInferiorSombra(),
        EsquinaInferior()
      ],
    );
  }

  Widget _register(BuildContext context, Size size) {
    final bloc = new LoginBloc();
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: size.height * 0.25,
          )),
          Text(
            'Nuevo Usuario',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          /*Container(
            width: size.width * 0.85,
            margin: EdgeInsets.only(top: 30, right: size.height * 0.075),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                    //blurRadius: 3,
                    spreadRadius: 1
                  )
                ]
            ),
            child: StreamBuilder(
              stream: bloc.nameStream,
              builder: (context, snapshot) {
                return TextField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                      icon: Icon(Icons.person_outline),
                      labelText: 'Nombres',
                      errorText: snapshot.hasError? snapshot.error.toString() : null,
                    ),
                    onChanged: bloc.changeName,
                );
              }
            )
          ),
          Container(
              width: size.width * 0.85,
              margin: EdgeInsets.only(right: size.height * 0.075),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        //blurRadius: 3,
                        spreadRadius: 1
                    )
                  ]
              ),
              child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person_outline),
                    labelText: 'Apellidos',
                  )
              )
          ),
          Container(
              width: size.width * 0.85,
              margin: EdgeInsets.only(right: size.height * 0.075),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        //blurRadius: 3,
                        spreadRadius: 1
                    )
                  ]
              ),
              child: StreamBuilder(
                stream: bloc.emailStream,
                builder: (context, snapshot) {
                  return TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.alternate_email),
                          labelText: 'Correo Electrónico',
                          hintText:  'correo@mail.com',
                          errorText: snapshot.hasError?snapshot.error.toString():null
                      ),
                    onChanged: bloc.changeEmail,
                  );
                }
              )
          ),
          Container(
              width: size.width * 0.85,
              margin: EdgeInsets.only(right: size.height * 0.075),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),                      
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: Offset(0, 4)
                    )
                  ]
              ),
              child: StreamBuilder<Object>(
                stream: bloc.emailStream,
                builder: (context, snapshot) {
                  return TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.lock_outline),
                        labelText: 'Contraseña',
                      ),
                    onChanged: bloc.changePassword,
                  );
                }
              )
          ),
          StreamBuilder(
            stream: bloc.formValidStream,
            builder: (context, snapshot) {
              return InkWell(
                onTap: () {
                  print(bloc.email);
                  print(bloc.password);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen, Colors.lightGreenAccent]
                    )
                  ),
                  child: Text('Registrar',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                ),
              );
            }
          )*/
          Container(
              width: size.width * 0.85,
              margin: EdgeInsets.only(right: size.height * 0.075, top: 30),
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                  stream: bloc.nameStream,
                  builder: (context, snapshot) {
                    return TextField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.person_outline),
                          labelText: 'Nombres',
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null),
                      onChanged: bloc.changeName,
                    );
                  })),
          Container(
              width: size.width * 0.85,
              margin: EdgeInsets.only(right: size.height * 0.075),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    //blurRadius: 3,
                    spreadRadius: 1)
              ]),
              child: StreamBuilder(
                stream: bloc.lastnameStream,
                builder: (context, snapshot) {
                  return TextField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person_outline),
                        labelText: 'Apellidos',
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null),
                    onChanged: bloc.changeLastname,
                  );
                },
              )),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.only(right: size.height * 0.075),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  //blurRadius: 3,
                  //offset: Offset(0, 5),
                  spreadRadius: 1)
            ]),
            child: StreamBuilder(
                stream: bloc.emailStream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.email),
                      hintText: 'correo@mail.com',
                      labelText: 'Correo Electrónico',
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                    ),
                    onChanged: bloc.changeEmail,
                  );
                }),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.only(right: size.height * 0.075),
            //padding: EdgeInsets.symmetric(horizontal: 10),
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
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                    ),
                    onChanged: bloc.changePassword,
                  );
                }),
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () => _registro(bloc.email, bloc.password),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black26,
                  elevation: 20,
                ),
                child: Text('Registrar'),
              )),
        ],
      ),
    );
  }

  _registro(String email, String password) async {
    print(email);
    print(password);
    await usuarioProvider.registro(email, password);
  }
}
*/