import 'package:flutter/material.dart';

class EsquinaSuperior extends StatelessWidget {
  const EsquinaSuperior({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EsquinaSuperiorPainter(),

      ) ,
    );
  }
}
 class _EsquinaSuperiorPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = new Rect.fromCircle(center: Offset(0,55), radius: 180);

    final Gradient gradiente = new LinearGradient(
        colors: [
          Colors.lightBlueAccent, Colors.lightBlue, Colors.cyan
        ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [
        0.1,0.5,1
      ]
    );
    final paint = new Paint()..shader = gradiente.createShader(rect);

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;

    final path = new Path();

    path.lineTo(0, size.height * 0.3);
    //path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.25, size.width * 0.17, size.height * 0.25);
    path.quadraticBezierTo(size.width*0.5, size.width*0.2, size.width*0.8, size.height * 0.1);
    path.quadraticBezierTo(size.width, size.height*0.1, size.width, 0);
    //path.quadraticBezierTo(0, 0, size.width, 0);

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

 }

class EsquinaSuperiorSombra extends StatelessWidget {
  const EsquinaSuperiorSombra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EsquinaSuperiorSombraPainter(),

      ) ,
    );
  }
}
class _EsquinaSuperiorSombraPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {


    final paint = new Paint();

    paint.color = Colors.lightBlueAccent.withOpacity(0.7);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;

    final path = new Path();

    path.lineTo(0, size.height * 0.32);
    //path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width * 0.18, size.height * 0.25, size.width * 0.19, size.height * 0.25);
    path.quadraticBezierTo(size.width*0.5, size.width*0.2, size.width*0.82, size.height * 0.12);
    path.quadraticBezierTo(size.width, size.height*0.1, size.width, 0);
    //path.quadraticBezierTo(0, 0, size.width, 0);

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}


class EsquinaInferior extends StatelessWidget {
  const EsquinaInferior({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EsquinaInferiorPainter(),

      ) ,
    );
  }
}
class _EsquinaInferiorPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = new Rect.fromCircle(center: Offset(0,55), radius: 180);

    final Gradient gradiente = new LinearGradient(
        colors: [
          Colors.amberAccent, Colors.orange, Colors.deepOrange
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [
          0.1,0.7,1
        ]
    );
    final paint = new Paint()..shader=gradiente.createShader(rect);

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 5;

    final path = new Path();

    path.moveTo(size.width*0.06, size.height);
    path.quadraticBezierTo(size.width*0.13, size.height*0.97, size.width*0.2, size.height*0.95);
    path.quadraticBezierTo(size.width*0.8, size.height*0.9, size.width*0.90, size.height*0.8);
    path.quadraticBezierTo(size.width*0.97, size.height*0.7, size.width, size.height*0.7);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
class EsquinaInferiorSombra extends StatelessWidget {
  const EsquinaInferiorSombra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _EsquinaInferiorSombraPainter(),

      ) ,
    );
  }
}
class _EsquinaInferiorSombraPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    final paint = new Paint();

    paint.color = Colors.orange.withOpacity(0.3);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 5;

    final path = new Path();

    path.moveTo(size.width*0.03, size.height);
    path.quadraticBezierTo(size.width*0.13, size.height*0.95, size.width*0.2, size.height*0.94);
    path.quadraticBezierTo(size.width*0.8, size.height*0.9, size.width*0.90, size.height*0.77);
    path.quadraticBezierTo(size.width*0.97, size.height*0.7, size.width, size.height*0.7);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}