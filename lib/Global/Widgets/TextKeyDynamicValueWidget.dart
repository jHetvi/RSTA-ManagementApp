import 'package:flutter/material.dart';

class TextKeyDynamicValueWidget extends StatelessWidget {
  final String label;
  final dynamic value;
  final EdgeInsets margin;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle labelStyle;
  final EdgeInsets labelPadding;
  // final bool clipValue;
  // final bool boldKey = false;

  const TextKeyDynamicValueWidget(
      {Key key,
      this.label,
      this.value,
      this.margin,
      this.crossAxisAlignment,
      this.labelStyle,
      this.labelPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:
                labelPadding ?? EdgeInsets.only(bottom: 2, left: 20, right: 20),
            child: Text(label,
                style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.4,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)
                    .merge(labelStyle ?? TextStyle())),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            child: (value is String)
                ? Text(value.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4))
                : value,
          ),
        ],
      ),
    );
  }
}

class TextKeyDynamicValueWidget2 extends StatelessWidget {
  final String label;
  final dynamic value;
  final EdgeInsets margin;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle labelStyle;
  final EdgeInsets labelPadding;
  // final bool clipValue;
  // final bool boldKey = false;

  const TextKeyDynamicValueWidget2(
      {Key key,
      this.label,
      this.value,
      this.margin,
      this.crossAxisAlignment,
      this.labelStyle,
      this.labelPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:
                labelPadding ?? EdgeInsets.only(bottom: 2, left: 20, right: 20),
            child: Text(label,
                style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)
                    .merge(labelStyle ?? TextStyle())),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            child: (value is String)
                ? Text(value.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4))
                : value,
          ),
        ],
      ),
    );
  }
}
