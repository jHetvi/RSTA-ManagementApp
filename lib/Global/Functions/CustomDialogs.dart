import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:velocity_x/velocity_x.dart';

Future<void> showLoadingDialog(BuildContext context,
    {String title = "Loading",
    String message,
    bool isError = false,
    bool onWillPop = false}) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      // useSafeArea: true,
      // barrierColor: Colors.black26,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => Future.value(onWillPop),
          child: AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ).centered(),
            titlePadding: EdgeInsets.only(left: 12, right: 12, top: 24),
            backgroundColor: Vx.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: !isError
                ? EdgeInsets.all(0)
                : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            content: (!isError)
                ? ((message == null)
                    ? Container(
                        height: 120,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/loaders/loader.gif'))),
                      )
                    : Container(child: Text(message)))
                : Container(child: Text(message ?? "Some Error Occured...")),
          ),
        );
      });
}

void showConfirmationDialog(BuildContext context,
    {String title = "Confirm",
    dynamic message = "Are you sure you want to proceed with this action?",
    @required Function onConfirm,
    bool onWillPop = true}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      // useSafeArea: true,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => Future.value(onWillPop),
          child: AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ).centered(),
            titlePadding: EdgeInsets.only(left: 12, right: 12, top: 24),
            backgroundColor: Vx.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            content: Container(
                child: message.runtimeType == String ? Text(message) : message),
            actions: [
              dialogButton(
                "Cancel",
                () => Navigator.of(context).pop(),
              ),
              dialogButton(
                "Confirm",
                () async => await onConfirm(),
              ),
            ],
          ),
        );
      });
}

Widget dialogButton(String label, Function onPressed) {
  return RaisedButton(
    child: Text(label, style: TextStyle(color: Vx.white)),
    onPressed: onPressed,
    color: Vx.gray700,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

Future<File> showTakePictureDialog(BuildContext context) async {
  Future<File> _cropImage(PickedFile image) async {
    return await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            hideBottomControls: true,
            toolbarTitle: ' Edit',
            toolbarColor: Color(0xFFFF215D),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Edit',
        ));
  }

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.camera);

                try {
                  final croppedImage = await _cropImage(pickedImage);
                  profileImage = File(croppedImage.path);
                  Navigator.pop(context);
                } catch (_) {
                  print(" ................................... " + _.toString());
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Take Picture'),
              textColor: redColor()),
          FlatButton.icon(
              onPressed: () async {
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                final croppedImage = await _cropImage(pickedImage);
                try {
                  profileImage = File(croppedImage.path);
                  Navigator.pop(context);
                } catch (_) {
                  print(_.toString());
                }
              },
              icon: Icon(Icons.image),
              label: Text('Select Picture'),
              textColor: redColor()),
        ]),
  );
  return profileImage;
}

Future<File> showTakePictureDialog2(BuildContext context) async {
  File selectedImage;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.camera);

                try {
                  selectedImage = File(pickedImage.path);
                  Navigator.pop(context);
                } catch (_) {
                  print(_.toString());
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Take Picture'),
              textColor: redColor()),
          FlatButton.icon(
              onPressed: () async {
                final pickedImage =
                    await ImagePicker().getImage(source: ImageSource.gallery);

                try {
                  selectedImage = File(pickedImage.path);
                  Navigator.pop(context);
                } catch (_) {
                  print(_.toString());
                }
              },
              icon: Icon(Icons.image),
              label: Text('Select Picture'),
              textColor: redColor()),
        ]),
  );
  return selectedImage;
}
