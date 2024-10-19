import 'package:flutter/material.dart';

class SwipableUIElement extends PageRouteBuilder {
  final Widget page;

  SwipableUIElement({required this.page})
    : super(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset start = Offset(0, 1);
        Offset end = Offset.zero;
        Curve curve = Curves.ease;

        var tween = Tween(begin: start, end: end).chain(CurveTween(curve: curve));

        var offsetAnim = animation.drive(tween);

        return SlideTransition(
          position: offsetAnim,
          child: child,
        );
      }
    );
}