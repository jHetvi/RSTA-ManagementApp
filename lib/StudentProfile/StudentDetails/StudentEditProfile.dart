import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as Im;
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Functions/DatabaseFunction.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Models/Student.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomDropdownMenuButton.dart';
import 'package:rsta/Global/Widgets/CustomTextFields.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';

class StudentEditProfile extends StatefulWidget {
  final String studentId, img, name, email, age, phoneNo, batch, time, fees;
  final Timestamp dob;
  StudentEditProfile({
    Key key,
    this.studentId,
    this.img,
    this.name,
    this.email,
    this.age,
    this.phoneNo,
    this.batch,
    this.time,
    this.fees,
    this.dob,
  }) : super(key: key);
  @override
  _StudentEditProfileState createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  final _studentEditformKey = GlobalKey<FormState>();
  final _nameContoller = TextEditingController();
  final _ageController = TextEditingController();
  final _whatsAppNumberContoller = TextEditingController();
  final _emailContoller = TextEditingController();
  var _batchContoller = TextEditingController();
  var _timeContoller = TextEditingController();
  final _feesController = TextEditingController();
  Timestamp _dobController;
  String _alertMessage;
  bool hasError = false;

  bool nullCheck() {
    if (_whatsAppNumberContoller.text.isEmpty ||
        _batchContoller.text.isEmpty ||
        _timeContoller.text.isEmpty ||
        _feesController.text.isEmpty) {
      _alertMessage = 'Please enter your ';
      _alertMessage +=
          _whatsAppNumberContoller.text.isEmpty ? ' Phone Number ,' : '';
      _alertMessage += _batchContoller.text.isEmpty ? ' Batch Name ,' : '';
      _alertMessage += _timeContoller.text.isEmpty ? ' Batch Time ,' : '';
      _alertMessage += _feesController.text.isEmpty ? ' Fees(Amount) ,' : '';

      return false;
    }
    return true;
  }

  File _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameContoller.text = widget.name;
    _emailContoller.text = widget.email;
    _ageController.text = widget.age;
    _whatsAppNumberContoller.text = widget.phoneNo;
    _batchContoller.text = widget.batch;
    _timeContoller.text = widget.time;
    _feesController.text = widget.fees;
    _dobController = widget.dob;
  }

  void updateData() async {
    FocusScope.of(context).unfocus();
    showLoadingDialog(context);
    Map<String, dynamic> updatedData = {};

    if (!nullCheck()) {
      DefaultErrorDialog.showErrorDialog(
        context: context,
        title: 'Alert !',
        message: _alertMessage,
      );
    }
    if (_emailContoller.text.isNotEmpty &&
        _emailContoller.text != Student.EMAIL_ID)
      updatedData
          .addAll({Student.WHATS_APP_NUMBER: _whatsAppNumberContoller.text});
    if (_whatsAppNumberContoller.text.isNotEmpty &&
        '+ 91 ' + _whatsAppNumberContoller.text != Student.WHATS_APP_NUMBER)
      updatedData
          .addAll({Student.WHATS_APP_NUMBER: _whatsAppNumberContoller.text});
    if (_batchContoller.text.isNotEmpty &&
        _batchContoller.text != Student.BATCH)
      updatedData.addAll({Student.BATCH: _batchContoller.text});
    if (_timeContoller.text.isNotEmpty && _timeContoller.text != Student.TIME)
      updatedData.addAll({Student.TIME: _timeContoller.text});
    if (_feesController.text.isNotEmpty && _feesController.text != Student.FEES)
      updatedData.addAll({Student.FEES: _feesController.text});

    if (updatedData.isNotEmpty)
      updatedData
          .addAll({Admin.LAST_UPDATE_DATETIME: FieldValue.serverTimestamp()});
    try {
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(widget.studentId)
          .update(updatedData);
      FirebaseFirestore.instance
          .collection('Batch')
          .doc(widget.batch)
          .collection(widget.time)
          .doc(widget.studentId)
          .update(updatedData)
          .whenComplete(() {
        Fluttertoast.showToast(
          msg: "Data Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          webBgColor: "#e74c3c",
          textColor: Colors.black,
          timeInSecForIosWeb: 5,
        );
        Navigator.of(context).pop();
      });
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
        .child('student_profileImages')
        .child(widget.studentId)
        .child('studentProfileImage.png');
    final _storageRefThumb = FirebaseStorage.instance
        .ref()
        .child('student_ProfileImagesThumb')
        .child(widget.studentId)
        .child('studentProfileImage.png');
    //await showTakePictureDialog(context);
    if (_pickedImage != null) {
      showLoadingDialog(context);
      try {
        await _storageRef.putFile(_pickedImage);
        final newUrl = await _storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Student')
            .doc(widget.studentId)
            .update({'profile_img_url': newUrl});
        await FirebaseFirestore.instance
            .collection('Batch')
            .doc(widget.batch)
            .collection(widget.time)
            .doc(widget.studentId)
            .update({'profile_img_url': newUrl});
        try {
          Im.Image tempImg = Im.decodeImage(_pickedImage.readAsBytesSync());
          Im.Image smallerImage =
              Im.copyResize(tempImg, width: 300, height: 300);
          _pickedImage..writeAsBytesSync(Im.encodePng(smallerImage, level: 7));
          await _storageRefThumb.putFile(_pickedImage);
          final newUrlThumb = await _storageRefThumb.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('Student')
              .doc(widget.studentId)
              .update({'profile_thumb_img_url': newUrlThumb});
          await FirebaseFirestore.instance
              .collection('Batch')
              .doc(widget.batch)
              .collection(widget.time)
              .doc(widget.studentId)
              .update({'profile_img_url': newUrlThumb});
        } catch (e) {
          print(e.toString());
          final newUrlThumb = newUrl;
          await FirebaseFirestore.instance
              .collection('Student')
              .doc(widget.studentId)
              .update({'profile_thumb_img_url': newUrlThumb});
          await FirebaseFirestore.instance
              .collection('Batch')
              .doc(widget.batch)
              .collection(widget.time)
              .doc(widget.studentId)
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
            message: 'Some unknown error occurred.');
        print(e.toString());
      }
      Navigator.pop(context);
      setState(() {});
    }
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
              flex: (MediaQuery.of(context).orientation == Orientation.portrait)
                  ? 1
                  : 2,
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
              flex: 5,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Form(
                      key: _studentEditformKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          child: Column(
                            children: [
                              InkWell(
                                  child: Container(
                                    height: size.width * .3,
                                    width: size.width * .3,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          size.width * .15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: widget.img == null
                                            ? AssetImage(
                                                'assets/images/profile_icon.png')
                                            : (_pickedImage == null)
                                                ? CachedNetworkImageProvider(
                                                    widget.img)
                                                : FileImage(_pickedImage),
                                      ),
                                      border: Border.all(
                                          color: Colors.grey, width: 3),
                                    ),
                                  ),
                                  onTap: () async {
                                    try {
                                      // ignore: deprecated_member_use
                                      await showTakePictureDialog(context)
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
                                  hint: widget.name,
                                  disabled: true,
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
                                  hint: widget.email,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                  label: "Date of Birth",
                                  value: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 8),
                                    child: Text(
                                        "${DateFormat("dd/MM/yyyy").format(_dobController.toDate()).toString()}"),
                                  )),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Age",
                                value: CustomTextField.phoneNumber(
                                  validator: (value) {
                                    if (value == "") return 'Please enter age!';
                                    return null;
                                  },
                                  controller: _ageController,
                                  hint: widget.age,
                                  readOnly: true,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Contact No.(Whats App)",
                                value: CustomTextField.phoneNumber(
                                  validator: (value) {
                                    if (value == "")
                                      return 'Please enter whats app no.!';
                                    return null;
                                  },
                                  controller: _whatsAppNumberContoller,
                                  hint: widget.phoneNo,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                  label: "Batch",
                                  value: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    // padding: EdgeInsets.symmetric(
                                    //     vertical: 3, horizontal: ),
                                    // ignore: missing_required_param
                                    child: CustomDropdownMenuButton(
                                      options: Map.fromEntries([
                                        'Red Dot',
                                        'Orange',
                                        'Green',
                                        'Intermediate',
                                        'Advance',
                                        'Adult (Beginner) ',
                                        'Adult (Pro)',
                                      ].map((e) => MapEntry(e, e))),
                                      hint: widget.batch,
                                      onChange: (str) => _batchContoller =
                                          str as TextEditingController,
                                      controller: _batchContoller,
                                      isExpanded: true,
                                    ),
                                  )),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                  label: "Time",
                                  value: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    // padding: EdgeInsets.symmetric(
                                    //     vertical: 3, horizontal: ),
                                    // ignore: missing_required_param
                                    child: CustomDropdownMenuButton(
                                      options: Map.fromEntries([
                                        '06:00 - 07:00',
                                        '07:00 - 08:00',
                                        '08:00 - 09:00',
                                        '16:00 - 17:00',
                                        '17:00 - 18:00',
                                        '18:00 - 19:00',
                                        '19:00 - 20:00',
                                        '20:00 - 21:00',
                                        '21:00 - 22:00',
                                        '----------------------',
                                        '16:00 - 19:00',
                                        '17:00 - 19-00',
                                        '18:00 - 20:00',
                                        '19:00 - 21:00'
                                      ].map((e) => MapEntry(e, e))),
                                      hint: widget.time,
                                      onChange: (str) => _timeContoller =
                                          str as TextEditingController,
                                      controller: _timeContoller,
                                      isExpanded: true,
                                    ),
                                  )),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Fees(Amount)",
                                value: CustomTextField.phoneNumber(
                                  validator: (value) {
                                    if (value == "")
                                      return 'Please enter whats app no.!';
                                    return null;
                                  },
                                  controller: _feesController,
                                  hint: widget.fees,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              CustomButton.gradientBackground(
                                  onTap: updateData, text: "Save Changes"),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
