import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qowi/src/pages/cuy_page.dart';
import 'package:qowi/src/pages/detalle_contenedor_page.dart';
import 'package:qowi/src/pages/galpon_page.dart';
import 'package:qowi/src/pages/home_page.dart';
import 'package:qowi/src/pages/login_page.dart';
import 'package:qowi/src/pages/mover_cuys_page.dart';
import 'package:qowi/src/pages/nacimiento_contenedor_page.dart';
import 'package:qowi/src/pages/nacimiento_page.dart';
import 'package:qowi/src/pages/register_page.dart';
import 'package:qowi/src/pages/reporte_venta_page.dart';
import 'package:qowi/src/pages/splash_page.dart';
import 'package:qowi/src/pages/venta_info_page.dart';
import 'package:qowi/src/pages/venta_page.dart';

import 'package:qowi/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarritoProvider(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: AuthServices(
          child: MaterialApp(
              title: 'Qowi',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  appBarTheme: AppBarTheme(
                      color: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black),
                      foregroundColor: Colors.black)),
              initialRoute: '/',
              routes: {
                '/': (context) => SplashPage(),
                'login': (context) => LoginPage(),
                'register': (context) => RegisterPage(),
                'home': (context) => HomePage(),
                'galpon': (context) => GalponPage(),
                'detalleContenedor': (context) => DetalleContenedorPage(),
                'cuy': (context) => CuyPage(),
                'nacimiento': (context) => NacimientoPage(),
                'mover': (_) => MoverCuyPage(),
                'venta': (_) => VentaPage(),
                'nacimientoContenedor': (_) => NacimientoContenedorPage(),
                'reporteVentas': (_) => ReporteVentaPage(),
                'ventaInfo': (_) => VentaInfoPage()
              }),
        ),
      ),
    );
  }
}
