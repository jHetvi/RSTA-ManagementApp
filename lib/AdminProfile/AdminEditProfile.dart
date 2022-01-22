import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rsta/AdminProfile/AddNewAdmin.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Functions/DatabaseFunction.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/Global/Variables/regex.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomTextFields.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/Services/authentication_functions.dart';
import 'package:image/image.dart' as Im;

class AdminEditProfile extends StatefulWidget {
  static final String routeName = "/AdminEditProfile";
  AdminEditProfile({Key key}) : super(key: key);
  @override
  _AdminEditProfileState createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameContoller = TextEditingController();
  final _emailContoller = TextEditingController();
  final _phoneContoller = TextEditingController();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _reEnterPassController = TextEditingController();
  String _alertMessage;
  bool hasError = false;

  void updateData() async {
    FocusScope.of(context).unfocus();
    showLoadingDialog(context);
    Map<String, dynamic> updatedData = {};

    if (_nameContoller.text.isNotEmpty && _nameContoller.text != Admin.NAME)
      updatedData.addAll({Admin.NAME: _nameContoller.text});

    if (_phoneContoller.text.isNotEmpty &&
        '+ 91 ' + _phoneContoller.text != Admin.PHONE_NUMBER)
      updatedData.addAll({Admin.PHONE_NUMBER: _phoneContoller.text});

    if (_oldPassController.text != _newPassController.text) {
      try {
        await currentUser.updatePassword(_newPassController.text);
        updatedData.addAll({Admin.PASSWORD: _newPassController.text});
      } on PlatformException catch (error) {
        hasError = true;
        Navigator.pop(context);
        if (error.code == 'ERROR_REQUIRES_RECENT_LOGIN')
          showConfirmationDialog(context,
              title: 'Require recent login !',
              onConfirm: () => AuthenticationFunctions.logout(
                  context: context, routeName: AddNewAdmin.routeName));
        else
          DefaultErrorDialog.showErrorDialog(
              context: context, title: 'Failed !', message: error.message);
      } catch (_) {
        Navigator.pop(context);
      }
    }
    if (updatedData.isNotEmpty)
      updatedData
          .addAll({Admin.LAST_UPDATE_DATETIME: FieldValue.serverTimestamp()});
    try {
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(currentUser.uid)
          .update(updatedData);
    } on PlatformException catch (error) {
      Navigator.pop(context);
      DefaultErrorDialog.showErrorDialog(
          context: context,
          title: 'Data update failed !',
          message: error.message);
    } catch (error) {
      Navigator.pop(context);
      DefaultErrorDialog.showErrorDialog(
          context: context, title: 'Data update failed !');
    }
    initUserDataStream();
    // ignore: unnecessary_statements
    hasError ? null : Navigator.pop(context);
  }

  Future<void> updateProfileImage() async {
    final _storageRef = FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child(currentUser.uid)
        .child('profileImage.png');
    final _storageRefThumb = FirebaseStorage.instance
        .ref()
        .child('ProfileImagesThumb')
        .child(currentUser.uid)
        .child('ProfileImage.png');
    //await showTakePictureDialog(context);
    if (_pickedImage != null) {
      showLoadingDialog(context);
      try {
        await _storageRef.putFile(_pickedImage);
        final newUrl = await _storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Admin')
            .doc(currentUser.uid)
            .update({'profile_img_url': newUrl});
        try {
          Im.Image tempImg = Im.decodeImage(_pickedImage.readAsBytesSync());
          Im.Image smallerImage =
              Im.copyResize(tempImg, width: 300, height: 300);
          _pickedImage..writeAsBytesSync(Im.encodePng(smallerImage, level: 7));
          await _storageRefThumb.putFile(_pickedImage);
          final newUrlThumb = await _storageRefThumb.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('Admin')
              .doc(currentUser.uid)
              .update({'profile_thumb_img_url': newUrlThumb});
        } catch (e) {
          print(e.toString());
          final newUrlThumb = newUrl;
          await FirebaseFirestore.instance
              .collection('Admin')
              .doc(currentUser.uid)
              .update({'profile_thumb_img_url': newUrlThumb});
        }
      } on PlatformException catch (error) {
        Navigator.pop(context);
        DefaultErrorDialog.showErrorDialog(
            context: context,
            title: 'Image upload failed !',
            message: error.message);
      } catch (e) {
        Navigator.pop(context);
        DefaultErrorDialog.showErrorDialog(
            context: context,
            title: 'Image upload failed !',
            message: 'Some unknow error occoured.');
        print(e.toString());
      }
      Navigator.pop(context);
      setState(() {});
    }
  }

  bool nullCheck() {
    if (_nameContoller.text.isEmpty ||
        _emailContoller.text.isEmpty ||
        _phoneContoller.text.isEmpty) {
      _alertMessage = 'Please enter your ';
      _alertMessage += _nameContoller.text.isEmpty ? 'name ,' : '';
      _alertMessage += _nameContoller.text.isEmpty ? ' email ,' : '';
      _alertMessage += _phoneContoller.text.isEmpty ? ' phone number ,' : '';

      return false;
    }
    return true;
  }

  File _pickedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 15,
              child: ClipPath(
                clipper: LoginHeaderCustomClipper(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0),
                  decoration: BoxDecoration(
                    gradient: customGradient(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 0,
                        child: IconButton(
                            tooltip: "Back",
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.of(context).pop()),
                      ),
                      Expanded(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 85,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 0),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc(currentUser.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      InkWell(
                                          child: Container(
                                            height: size.width * .3,
                                            width: size.width * .3,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * .15),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: snapshot.data[Admin
                                                            .PROFILE_IMAGE_URL] ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/images/profile_icon.png')
                                                    : (_pickedImage == null)
                                                        ? CachedNetworkImageProvider(
                                                            snapshot.data[Admin
                                                                .PROFILE_IMAGE_URL])
                                                        : FileImage(
                                                            _pickedImage),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey, width: 3),
                                            ),
                                          ),
                                          onTap: () async {
                                            try {
                                              // ignore: deprecated_member_use
                                              await showTakePictureDialog(
                                                      context)
                                                  .then((value) {
                                                setState(() {
                                                  _pickedImage = value;
                                                  updateProfileImage();
                                                });
                                              });
                                            } on NoImagesSelectedException catch (e) {
                                              print(
                                                  "NoImagesSelectedException When Picking Profile Image. E = " +
                                                      e.toString());
                                            } on PlatformException catch (e) {
                                              print(
                                                  "PlatformException When Picking Profile Image. E = " +
                                                      e.toString());
                                            } catch (e) {
                                              print(
                                                  "UnknownException When Picking Profile Image. E = " +
                                                      e.toString());
                                            }
                                          }),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      TextKeyDynamicValueWidget(
                                        label: "Name",
                                        value: CustomTextField.text(
                                          validator: (value) {
                                            if (value == "")
                                              return 'Please enter name!';
                                            return null;
                                          },
                                          controller: _nameContoller,
                                          hint: snapshot.data[Admin.NAME],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      TextKeyDynamicValueWidget(
                                        label: "Email",
                                        value: CustomTextField.email(
                                          validator: (value) {
                                            if (value == "")
                                              return 'Please enter email!';
                                            return null;
                                          },
                                          controller: _emailContoller,
                                          hint: snapshot.data[Admin.EMAIL_ID],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      TextKeyDynamicValueWidget(
                                        label: "Mobile",
                                        value: CustomTextField.phoneNumber(
                                          validator: (value) {
                                            if (value == "")
                                              return 'Please enter mobile number!';
                                            return null;
                                          },
                                          controller: _phoneContoller,
                                          hint:
                                              snapshot.data[Admin.PHONE_NUMBER],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      TextKeyDynamicValueWidget(
                                        label: "Change Password",
                                        value: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: CustomTextField
                                                        .password(
                                                      validator: (value) {
                                                        if (value !=
                                                            Admin.PHONE_NUMBER)
                                                          return 'password didnot match!';
                                                        return null;
                                                      },
                                                      onChangedFunction:
                                                          (value) {
                                                        setState(() {});
                                                      },
                                                      controller:
                                                          _oldPassController,
                                                      hint:
                                                          "Enter Current Password",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(1),
                                                  margin: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _oldPassController
                                                                .text ==
                                                            snapshot.data[
                                                                Admin.PASSWORD]
                                                        ? Colors.green
                                                        : Colors.black26,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: CustomTextField
                                                        .password(
                                                      validator: (value) {
                                                        if (value.isEmpty)
                                                          return 'Please enter password!';
                                                        if (value.length < 10)
                                                          return 'Password is too short!';
                                                        if (!passwordRegex
                                                            .hasMatch(value))
                                                          return "Password must contain 1 \n uppercase, 1 lowecase ,1 no,\n and special character";
                                                        return null;
                                                      },
                                                      onChangedFunction:
                                                          (value) {
                                                        setState(() {});
                                                      },
                                                      controller:
                                                          _newPassController,
                                                      hint:
                                                          "Enter New Password",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(1),
                                                  margin: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Icon(Icons.check,
                                                      size: 18,
                                                      color: Colors.white),
                                                  decoration: BoxDecoration(
                                                    color: (_newPassController
                                                                    .text
                                                                    .length <
                                                                10 ||
                                                            !passwordRegex.hasMatch(
                                                                _newPassController
                                                                    .text))
                                                        ? Colors.black26
                                                        : Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: CustomTextField
                                                        .password(
                                                      validator: (value) {
                                                        if (value !=
                                                            _newPassController
                                                                .text) {
                                                          return 'Password doesn\'t match';
                                                        }
                                                        return null;
                                                      },
                                                      onChangedFunction:
                                                          (value) {
                                                        setState(() {});
                                                      },
                                                      controller:
                                                          _reEnterPassController,
                                                      hint:
                                                          "Re-Enter New Password",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(1),
                                                  margin: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Icon(Icons.check,
                                                      size: 18,
                                                      color: Colors.white),
                                                  decoration: BoxDecoration(
                                                    color: (_newPassController
                                                                    .text ==
                                                                _reEnterPassController
                                                                    .text &&
                                                            _newPassController
                                                                .text
                                                                .isNotEmpty)
                                                        ? Colors.green
                                                        : Colors.black26,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      CustomButton.gradientBackground(
                                          onTap: updateData,
                                          text: "Save Changes"),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  );
                                })),
                      )

                      /*  Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        elevation: 20,
                        shadowColor: Colors.black,
                        child: Container(
                            height: 140.0,
                            width: size.width,
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                                child: Text(
                              "Register New Student",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ), */

                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
