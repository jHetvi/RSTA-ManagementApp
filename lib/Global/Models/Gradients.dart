import 'package:flutter/material.dart';

LinearGradient customGradient(
    {bool reverseColors = false,
    double opacity = 1.0,
    bool topBottomGradient = false}) {
  List<Color> colors = [
    Color(0xFFFF215D).withOpacity(opacity),
    Color(0xFFFF4D4D).withOpacity(opacity),
  ];
  if (reverseColors) colors = colors.reversed.toList();
  return LinearGradient(
    colors: colors,
    stops: [0.125, 1],
    end: topBottomGradient ? Alignment.topCenter : Alignment.topLeft,
    begin: topBottomGradient ? Alignment.bottomCenter : Alignment.bottomRight,
  );
}

LinearGradient whitecustomGradient(
    {bool reverseColors = false,
    double opacity = 1.0,
    bool topBottomGradient = false}) {
  List<Color> colors = [
    Colors.white70.withOpacity(opacity),
    Colors.white54.withOpacity(opacity),
  ];
  if (reverseColors) colors = colors.reversed.toList();
  return LinearGradient(
    colors: colors,
    stops: [0.125, 1],
    end: topBottomGradient ? Alignment.topCenter : Alignment.topLeft,
    begin: topBottomGradient ? Alignment.bottomCenter : Alignment.bottomRight,
  );
}
