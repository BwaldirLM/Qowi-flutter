import 'package:rxdart/rxdart.dart';

enum NavBarItem { REPORTES, HOME, ADD }

class HomeBloc {
  final _navBarController = BehaviorSubject<NavBarItem>();

  //Recuperar el stream
  Stream<NavBarItem> get homeStream => _navBarController.stream;

  NavBarItem defaultItem = NavBarItem.HOME;

  dispose() {
    _navBarController.close();
  }

  void pickItem(int value) {
    switch (value) {
      case 0:
        _navBarController.sink.add(NavBarItem.REPORTES);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.ADD);
    }
  }
}
