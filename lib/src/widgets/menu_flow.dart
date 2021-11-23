import 'package:flutter/material.dart';

const double buttonSize = 70;
class FlowMenu extends StatefulWidget {
  final List<Widget> children;

  const FlowMenu({Key? key, required this.children}) : super(key: key);

  @override
  _FlowMenuState createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
        vsync: this
    );
    widget.children.insert(0, FloatingActionButton(
      elevation: 0,
      splashColor: Colors.black,
      child: Icon(Icons.menu, color: Colors.white, size: 40),
      onPressed: (){
        if(controller.status == AnimationStatus.completed) controller.reverse();
        else controller.forward();
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Flow(
   /*children: [
     Icons.menu,
     Icons.mail,
     Icons.call,
     Icons.notifications
   ].map<Widget>(buildItem).toList(),*/
      children: widget.children.map<Widget>(buildItem).toList(),
      delegate: FlowMenuDelegate(controller: controller),
    );
  }

  Widget buildItem(Widget widget) => SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: widget,
  );
}

class FlowMenuDelegate extends FlowDelegate{
  final Animation<double> controller;

  FlowMenuDelegate({required this.controller}) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - (buttonSize + 10);
    final yStart = size.height - (buttonSize + 10);
    for(int i = context.childCount - 1; i >= 0; i--){
      final childSize = context.getChildSize(i)!.width;
      final margin = 8;
      final dx = (childSize + margin) * i;
      final x = xStart;
      final y = yStart - dx * controller.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0)
      );
    }
  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
  return controller != oldDelegate.controller;
  }
  
}
