import 'package:flutter/material.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';

class CustomButton extends StatelessWidget {
  final bool whiteBg;
  final VoidCallback onTap;
  final String text;
  final double width;
  final double fontSize;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final Color bgColor;
  final BoxBorder border;
  final double elevation;
  final Widget prefix;
  final FontWeight fontWeight;
  CustomButton.whiteBackground({
    this.text,
    this.width,
    this.onTap,
    this.fontSize,
    this.padding = const EdgeInsets.all(12),
    this.textStyle,
    this.bgColor = Colors.white,
    this.border,
    this.elevation = 5,
    this.prefix,
    this.fontWeight = FontWeight.bold,
  }) : whiteBg = true;
  CustomButton.gradientBackground({
    this.text,
    this.width,
    this.onTap,
    this.fontSize,
    this.padding = const EdgeInsets.all(12),
    this.textStyle,
    this.bgColor = Colors.white,
    this.border,
    this.elevation = 5,
    this.prefix,
    this.fontWeight = FontWeight.bold,
  }) : whiteBg = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(150),
      child: Container(
        width: width,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Text(
                text,
                style: textStyle ??
                    TextStyle(
                      color: whiteBg ? redColor() : Colors.white,
                      fontSize: fontSize ?? 24,
                      fontWeight: fontWeight,
                    ),
              ),
            ),
            if (prefix != null)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: prefix,
                ),
              ),
          ],
        ),
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(
          color: whiteBg ? bgColor : null,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: elevation,
              offset: Offset(elevation, elevation),
            ),
          ],
          gradient: whiteBg ? null : customGradient(),
          border: whiteBg
              ? border ?? Border.all(color: redColor(), width: 2)
              : null,
        ),
      ),
    );
  }
}
