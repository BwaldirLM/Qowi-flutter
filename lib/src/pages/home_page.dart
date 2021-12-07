import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:qowi/src/bloc/home_bloc.dart';

import 'package:qowi/src/pages/galpones_page.dart';
import 'package:qowi/src/pages/info_page.dart';
import 'package:qowi/src/pages/recursos_page.dart';

import 'package:qowi/src/providermodels/carrito_model.dart';
import 'package:qowi/src/services/auth_services.dart';

class HomePage extends StatelessWidget {

  final _homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    final auth = AuthServices.of(context).usuarioProvider;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
              color: Colors.blueAccent
          ),
          title: Text(
            'QOWI',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(icon: Icon(Icons.account_circle),
                onPressed: () {
                  auth.signOut();
                  Navigator.pushReplacementNamed(context, 'login');
                }
            )
          ],
          centerTitle: true,
        ),
        body: _callPage(_homeBloc),
        bottomNavigationBar: _bottomNavigationBar(_homeBloc),
      );

  }

  Widget _bottomNavigationBar(HomeBloc bloc) {
    return StreamBuilder(
      stream: bloc.homeStream,
      initialData: bloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot){
        return BottomNavigationBar(
          currentIndex: snapshot.data!.index,
          onTap: bloc.pickItem,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on_outlined),
                label: 'recursos'
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
            label: 'Inicio'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module),
            label: 'Galpon'
          )
        ]);
      },
    );
  }

  Widget _callPage(HomeBloc bloc) {
    return StreamBuilder<NavBarItem>(
        stream: bloc.homeStream,
        initialData: bloc.defaultItem,
        builder: (context, snapshot){
          switch(snapshot.data!){
            case NavBarItem.HOME:
              return InfoPage();
            case NavBarItem.RECURSOS:
              return RecursosPage();
            case NavBarItem.ADD:
              return GalponesPage();
          }
        }
    );
  }


}

