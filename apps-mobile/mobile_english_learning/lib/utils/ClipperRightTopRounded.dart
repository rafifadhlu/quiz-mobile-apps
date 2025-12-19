


import 'package:flutter/material.dart';

class RightTopRounded extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path = Path();
    final double radius = size.width * 0.5;

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(
      size.width, 0,        // control point
      size.width, radius,   // end point
    );

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}