import 'package:flutter/cupertino.dart';
import 'package:qowi/src/data/data.dart';
import 'package:qowi/src/providers/usuario_provider.dart';
import 'package:supabase/supabase.dart';

class AuthServices extends InheritedWidget{
  final UsuarioProvider usuarioProvider;

  AuthServices._({
    required this.usuarioProvider,
    required Widget child,
  }):super(child:child);

  factory AuthServices({required Widget child}){
    final client = SupabaseClient(supabaseUrl, supabaseKey);
    final usuarioProvider = UsuarioProvider(client.auth);
    return AuthServices._(usuarioProvider: usuarioProvider, child: child);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static AuthServices of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AuthServices>()!;
  }

}
