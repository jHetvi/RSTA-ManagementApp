import 'package:flutter/material.dart';

class LoginHeaderCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
          ..moveTo(0, 0)
          ..lineTo(0, size.height)
          ..quadraticBezierTo(
              size.width * .5, size.height * .75, size.width, size.height)
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
        // ..lineTo(0, size.height*0.6)
        ;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
