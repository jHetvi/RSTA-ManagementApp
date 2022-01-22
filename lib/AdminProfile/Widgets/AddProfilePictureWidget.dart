import 'package:flutter/material.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';

class AddProfilePictureWidget extends StatefulWidget {
  @override
  _AddProfilePictureWidgetState createState() =>
      _AddProfilePictureWidgetState();
}

class _AddProfilePictureWidgetState extends State<AddProfilePictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.2,
        backgroundColor: Colors.black.withOpacity(0.075),
        child: profileImage == null
            ? Container(
                width: MediaQuery.of(context).size.width * 0.375,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => showTakePictureDialog(context).then((value) {
                        setState(() {});
                      }),
                      child: SizedBox(
                        height: 65,
                        child: Image.asset(
                          'assets/icons/plus.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          right: 16,
                        ),
                        child: Text(
                          'Click here to select Profile Picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: redColor(),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () => showTakePictureDialog(context).then((value) {
                  setState(() {});
                }),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: FileImage(profileImage),
                ),
              ),
      ),
    );
  }
}
