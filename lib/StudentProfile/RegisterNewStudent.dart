import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as Im;
import 'package:intl/intl.dart';
import 'package:rsta/AdminProfile/Widgets/AddProfilePictureWidget.dart';
import 'package:rsta/Dashboard/DashboardScreen.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Functions/DatabaseFunction.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Models/Student.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomDropdownMenuButton.dart';
import 'package:rsta/Global/Widgets/CustomTextFields.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterNewStudent extends StatefulWidget {
  static final String routeName = "/RegisterNewStudent";
  @override
  _RegisterNewStudentState createState() => _RegisterNewStudentState();
}

class _RegisterNewStudentState extends State<RegisterNewStudent> {
  final _studentformKey = GlobalKey<FormState>();
  final _nameContoller = TextEditingController();
  final _ageController = TextEditingController();
  final _whatsAppNumberContoller = TextEditingController();
  final _emailContoller = TextEditingController();
  var _batchContoller = TextEditingController();
  var _timeContoller = TextEditingController();
  final _feesController = TextEditingController();
  String _alertMessage;
  Timestamp _dobController;

  bool nullCheck() {
    if (_nameContoller.text.isEmpty ||
        _whatsAppNumberContoller.text.isEmpty ||
        _ageController.text.isEmpty ||
        _batchContoller.text.isEmpty ||
        _timeContoller.text.isEmpty ||
        _dobController.toString().isEmpty ||
        _feesController.text.isEmpty) {
      _alertMessage = 'Please enter your ';
      _alertMessage += _nameContoller.text.isEmpty ? 'Name ,' : '';
      _alertMessage += _dobController.toString().isEmpty ? 'DOB ,' : '';
      _alertMessage +=
          _whatsAppNumberContoller.text.isEmpty ? ' Phone number ,' : '';
      _alertMessage += _ageController.text.isEmpty ? ' Age ,' : '';
      _alertMessage += _batchContoller.text.isEmpty ? ' Batch Name ,' : '';
      _alertMessage += _timeContoller.text.isEmpty ? ' Batch Time ,' : '';
      _alertMessage += _feesController.text.isEmpty ? ' Fees(Amount) ,' : '';

      return false;
    }
    return true;
  }

  @override
  void initState() {
    _dobController = Timestamp.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0),
                  decoration: BoxDecoration(
                    gradient: customGradient(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop()),
                      Expanded(
                        child: Text(
                          "Register New Student",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
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
                      key: _studentformKey,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          child: Column(
                            children: [
                              AddProfilePictureWidget(),
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
                                  hint: "Eg: Hetvy Jani",
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
                                  child: DateFormat("dd/MM/yyyy")
                                      .format(_dobController.toDate())
                                      .text
                                      .size(16)
                                      .make(),
                                ).click(() async {
                                  var dt = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now().subtract(
                                          Duration(
                                              days: 365 * 120 + (120 ~/ 4),
                                              minutes: 1)),
                                      lastDate: DateTime.now());
                                  if (dt != null)
                                    setState(() => _dobController =
                                        Timestamp.fromDate(dt));
                                }).make(),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Age",
                                value: CustomTextField.number(
                                  validator: (value) {
                                    if (value == "") return 'Please enter age!';
                                    return null;
                                  },
                                  controller: _ageController,
                                  hint: "Eg: 20",
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Email",
                                value: CustomTextField.email(
                                  validator: (value) {
                                    return null;
                                  },
                                  controller: _emailContoller,
                                  hint: "Eg: jhetvy0308@gmail.com",
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              TextKeyDynamicValueWidget(
                                label: "Mobile (Whats App)",
                                value: CustomTextField.phoneNumber(
                                  validator: (value) {
                                    if (value == "")
                                      return 'Please enter mobile number!';
                                    return null;
                                  },
                                  controller: _whatsAppNumberContoller,
                                  hint: "Eg: 9429300200",
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
                                      hint: "Eg : Red Dot",
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
                                      hint: "Eg : 06:00 - 07:00",
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
                                label: "Fees",
                                value: CustomTextField.decimalNumber(
                                  validator: (value) {
                                    if (value == "")
                                      return 'Please enter Fees amount!';
                                    return null;
                                  },
                                  controller: _feesController,
                                  hint: "Eg: 1000",
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              CustomButton.gradientBackground(
                                  onTap: () async {
                                    if (_studentformKey.currentState
                                            .validate() &&
                                        nullCheck()) {
                                      _studentformKey.currentState.save();

                                      studentData = Student(
                                        name: _nameContoller.text,
                                        dob: _dobController,
                                        age: _ageController.text,
                                        whatsAppNumber: '+ 91 ' +
                                            _whatsAppNumberContoller.text,
                                        batch: _batchContoller.text,
                                        time: _timeContoller.text,
                                        fees: _feesController.text,
                                      );
                                      var docRef = FirebaseFirestore.instance
                                          .collection('Student')
                                          .doc();
                                      await docRef.set(studentData.toJson()
                                        ..[Student.STUDENT_ID] = docRef.id
                                        ..[Student.EMAIL_ID] =
                                            _emailContoller.text.trim()
                                        ..[Student.CREATE_TIMESTAMP] =
                                            FieldValue.serverTimestamp()
                                        ..[Student.LAST_UPDATE_DATETIME] =
                                            FieldValue.serverTimestamp());

                                      String proImage;
                                      String proImageThumb;

                                      if (profileImage != null)
                                        try {
                                          final _storageRef = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child('student_profileImages');
                                          final _storageRefThumb = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child(
                                                  'student_ProfileImagesThumb');
                                          showLoadingDialog(context);

                                          await _storageRef
                                              .child(docRef.id)
                                              .child('studentProfileImage.png')
                                              .putFile(profileImage);
                                          proImage = await _storageRef
                                              .child(docRef.id)
                                              .child('studentProfileImage.png')
                                              .getDownloadURL();
                                          try {
                                            Im.Image tempImg = Im.decodeImage(
                                                profileImage.readAsBytesSync());
                                            Im.Image smallerImage =
                                                Im.copyResize(tempImg,
                                                    width: 300, height: 300);
                                            profileImage
                                              ..writeAsBytesSync(Im.encodePng(
                                                  smallerImage,
                                                  level: 7));
                                            await _storageRefThumb
                                                .child(docRef.id)
                                                .child(
                                                    'studentProfileImage.png')
                                                .putFile(profileImage);
                                            proImageThumb = await _storageRefThumb
                                                .child(docRef.id)
                                                .child(
                                                    'studentProfileImage.png')
                                                .getDownloadURL();

                                            await docRef.update({
                                              Student.PROFILE_IMAGE_URL:
                                                  proImage,
                                              Student.PROFILE_THUMB_IMAGE_URL:
                                                  proImageThumb,
                                            });
                                          } catch (e) {
                                            studentData.profileThumbImgUrl =
                                                studentData.profileImgUrl;
                                            print(e.toString());
                                          }
                                        } catch (error) {
                                          print(
                                              "................................." +
                                                  error.toString());
                                          Navigator.pop(context);
                                          print(
                                              "................................." +
                                                  error.toString());
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Profile pricture upload failed!')));
                                          print(
                                              "................................." +
                                                  error.toString());
                                        }
                                      initUserDataStream();

                                      FirebaseFirestore.instance
                                          .collection('Batch')
                                          .doc(_batchContoller.text)
                                          .collection(_timeContoller.text)
                                          .doc(docRef.id)
                                          .set(
                                            studentData.toJson()
                                              ..[Student.STUDENT_ID] = docRef.id
                                              ..[Student.EMAIL_ID] =
                                                  _emailContoller.text.trim()
                                              ..[Student.CREATE_TIMESTAMP] =
                                                  FieldValue.serverTimestamp()
                                              ..[Student.LAST_UPDATE_DATETIME] =
                                                  FieldValue.serverTimestamp()
                                              ..[Student.PROFILE_IMAGE_URL] =
                                                  proImage
                                              ..[Student
                                                      .PROFILE_THUMB_IMAGE_URL] =
                                                  proImageThumb,
                                          );

                                      Fluttertoast.showToast(
                                        msg:
                                            "New Student ${_nameContoller.text} Registered Sucessfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        webBgColor: "#e74c3c",
                                        textColor: Colors.black,
                                        timeInSecForIosWeb: 5,
                                      );

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              DashboardScreen.routeName,
                                              (route) => false);

                                      initUserDataStream();
                                    } else if (!nullCheck()) {
                                      DefaultErrorDialog.showErrorDialog(
                                        context: context,
                                        title: 'Alert !',
                                        message: _alertMessage,
                                      );
                                    }
                                  },
                                  text: "Create"),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
