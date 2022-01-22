import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CustomDropdownMenuButton extends StatefulWidget {
  final InputBorder border;
  final String hint;
  final bool readOnly;
  double fontSize = 16;
  final IconData iconData;
  final EdgeInsets padding;
  final Map<String, dynamic> options;
  final String initialSelection;
  final Function(String) onChange;
  TextEditingController controller;
  final RegExp regex;
  final Widget prefixWidget;
  final Widget suffixWidget;
  final String prefixText;
  final String Function(String) validator;
  final bool enabled;
  final bool isExpanded;
  // final DropdownMenuItem Function(MapEntry<String,dynamic>) itemBuilder;

  CustomDropdownMenuButton(
      {Key key,
      @required this.options,
      this.initialSelection,
      @required this.onChange,
      this.fontSize,
      this.border,
      this.hint,
      this.iconData,
      this.padding,
      this.controller,
      this.prefixWidget,
      this.readOnly,
      this.regex,
      this.validator,
      this.prefixText,
      this.suffixWidget,
      this.enabled = true,
      this.isExpanded = false})
      : super(key: key) {
    if (controller == null) controller = TextEditingController();
  }

  @override
  _CustomDropdownMenuButtonState createState() =>
      _CustomDropdownMenuButtonState();
}

class _CustomDropdownMenuButtonState extends State<CustomDropdownMenuButton> {
  FocusNode focusNode;
  double borderRadius;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: DropdownButtonFormField<String>(
        isExpanded: widget.isExpanded,
        onChanged: !widget.enabled
            ? null
            : (val) {
                widget.controller.text = widget.options[val];
                widget.onChange(val);
                setState(() {});
              },
        items: widget.options.entries
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.value.toString(),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: e.key,
                ))
            .toList(),
        value: widget.initialSelection,
        validator: widget.validator == null
            ? widget.regex == null
                ? null
                : (str) {
                    if (widget.regex.hasMatch(str))
                      return null;
                    else
                      return "Invalid Input";
                  }
            : (str) => widget.validator(str),
        // ignore: deprecated_member_use
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
          counter: Offstage(
              child: SizedBox(
            height: 0,
            width: 0,
          )),
          contentPadding: widget.padding ??
              EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 6),
          isDense: true,
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade200, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
          ),
          fillColor: Colors.black.withOpacity(0.08),
          prefixText: widget.prefixText ?? "",
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            color: Colors.black38,
          ),
          suffixIcon: Padding(
            child: widget.suffixWidget,
            padding: const EdgeInsets.only(right: 0),
          ),
          suffixIconConstraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   borderRadius = 36;
  //   return TextFormField(
  //     autovalidate: widget.autoValidate,
  //     controller: widget.controller,
  //     focusNode: focusNode,
  //     onChanged: widget.onChangedFunction,
  //     minLines: widget.minLines,
  //     maxLines: widget.maxLines,
  //     maxLength: widget.maxLength,
  //     maxLengthEnforced: true,
  //     textAlign: widget.textAlign??TextAlign.start,
  //     keyboardType: widget.keyboardType,
  //     readOnly: widget.readOnly,
  //     enabled: !widget.readOnly && !widget.disabled,
  //     textInputAction: widget.textInputAction,
  //     textCapitalization: widget.textCapitalization,
  //     inputFormatters: widget.inputFormatters,
  //     style: TextStyle(fontSize: widget.fontSize),
  //     obscureText: widget.fieldType==CTFType.Password,
  //     validator: widget.validator==null
  //       ? widget.regex==null
  //         ? null
  //         : (str) {
  //           if(widget.regex.hasMatch(str)) return null;
  //           else return "Invalid Input";
  //         }
  //       : (str) => widget.validator(str),
  //     decoration: InputDecoration(
  //       hintStyle: TextStyle(fontSize: widget.fontSize, color: Colors.black54,),
  //       counter: SizedBox(height: 0, width: 0,),
  //       contentPadding: widget.padding??EdgeInsets.symmetric(vertical: 18, horizontal: 24),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide.none),
  //       errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: Colors.red.shade200, width: 1.0),),
  //       focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),),
  //       fillColor: Colors.black.withOpacity(0.08),
  //       filled: true,
  //       prefixText: widget.prefixText,
  //       hintText: widget.hint??"",
  //       suffixIcon: Padding(
  //         padding: const EdgeInsets.only(right: 8),
  //         child: widget.suffixWidget,
  //       ),
  //       suffixIconConstraints: BoxConstraints(maxHeight: 40,maxWidth: 40),
  //     ),
  //   );
  // }

}
