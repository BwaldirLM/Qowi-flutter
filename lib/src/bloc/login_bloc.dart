
import 'dart:async';

import 'package:qowi/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _lastnameController = BehaviorSubject<String>();
  final _cargandoController = BehaviorSubject<bool>();

  //Recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get nameStream =>
      _nameController.stream.transform(validarNombre);
  Stream<String> get lastnameStream =>
      _lastnameController.stream.transform(validarNombre);
  Stream<bool>get cargandoStream => _cargandoController.stream;

  Stream<bool> get formValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);
  Stream<bool> get registerValidStream => CombineLatestStream.combine4(
      nameStream,
      passwordStream,
      nameStream,
      lastnameStream,
          (a, b, c, d) => true);

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastname => _lastnameController.sink.add;

  //Obtner los valores de email y password
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get name => _nameController.value;
  String get lastname => _lastnameController.value;

  void cargando(bool carga){
    _cargandoController.sink.add(carga);
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _lastnameController.close();
    _cargandoController.close();
  }
}