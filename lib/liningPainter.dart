import 'package:flutter/material.dart';

class LiningPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final Size(:width,:height)=size;
    canvas.drawLine(Offset(width*0.1,height*0.1),Offset(width*0.9,height*0.8), Paint()..color=Colors.amber..strokeWidth=height*0.4..strokeCap=StrokeCap.round);
    canvas.drawLine(Offset(width*0.05,height*0.1),Offset(width*0.05,height*0.8),Paint()..color=Colors.amber..strokeWidth=height*0.4..strokeCap=StrokeCap.round);
    canvas.drawLine(Offset(width*0.9,height*0.8),Offset(width*0.9,height*0.15),Paint()..color=Colors.amber..strokeWidth=height*0.4..strokeCap=StrokeCap.round);
    canvas.drawLine(Offset(width*0.1,height*0.8),Offset(width*0.85,height*0.15),Paint()..color=Colors.amber..strokeWidth=height*0.4..strokeCap=StrokeCap.round);
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}  