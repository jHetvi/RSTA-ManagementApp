import 'package:flutter/material.dart';
import 'package:rsta/AdminProfile/Widgets/AddProfilePictureWidget.dart';
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

class AddNewAdmin extends StatefulWidget {
  static final String routeName = "/AddNewAdmin";
  @override
  _AddNewAdminState createState() => _AddNewAdminState();
}

class _AddNewAdminState extends State<AddNewAdmin> {
  final _formKey = GlobalKey<FormState>();
  final _nameContoller = TextEditingController();
  final _emailContoller = TextEditingController();
  final _phoneContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _alertMessage;

  bool nullCheck() {
    if (_nameContoller.text.isEmpty ||
        _emailContoller.text.isEmpty ||
        _phoneContoller.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _alertMessage = 'Please enter your ';
      _alertMessage += _nameContoller.text.isEmpty ? 'name ,' : '';
      _alertMessage += _nameContoller.text.isEmpty ? ' email ,' : '';
      _alertMessage += _phoneContoller.text.isEmpty ? ' phone number ,' : '';
      _alertMessage += _passwordController.text.isEmpty ? ' password ,' : '';
      _alertMessage +=
          _confirmPasswordController.text.isEmpty ? ' confirm password ,' : '';

      return false;
    }
    return true;
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
              flex: 15,
              child: ClipPath(
                clipper: LoginHeaderCustomClipper(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0),
                  decoration: BoxDecoration(
                    gradient: customGradient(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
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
                                  label: "Email",
                                  value: CustomTextField.email(
                                    validator: (value) {
                                      if (value == "")
                                        return 'Please enter email!';
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
                                  label: "Mobile",
                                  value: CustomTextField.phoneNumber(
                                    validator: (value) {
                                      if (value == "")
                                        return 'Please enter mobile number!';
                                      return null;
                                    },
                                    controller: _phoneContoller,
                                    hint: "Eg: 9429300200",
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                TextKeyDynamicValueWidget(
                                  label: "Password",
                                  value: Column(
                                    children: [
                                      CustomTextField.password(
                                        validator: (value) {
                                          if (value == "")
                                            return 'Please enter password!';
                                          if (value.length < 10)
                                            return 'Password is too short!';
                                          if (!passwordRegex.hasMatch(value))
                                            return "Password must be more than 10  charcaters \nand  must contain 1 uppercase, 1 lowercase \n1 number, and special character";

                                          return null;
                                        },
                                        controller: _passwordController,
                                        hint: "Enter Password",
                                      ),
                                      SizedBox(height: 4),
                                      CustomTextField.password(
                                        controller: _confirmPasswordController,
                                        validator: (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Password doesn\'t match';
                                          }
                                          return null;
                                        },
                                        hint: "Re-enter Password",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomButton.gradientBackground(
                                    onTap: () async {
                                      if (_formKey.currentState.validate() &&
                                          nullCheck()) {
                                        _formKey.currentState.save();

                                        adminData = Admin(
                                          name: _nameContoller.text,
                                          emailId: _emailContoller.text.trim(),
                                          phoneNumber:
                                              '+ 91 ' + _phoneContoller.text,
                                          password: _passwordController.text,
                                        );
                                        await AuthenticationFunctions
                                            .signUpWithEmail(
                                                context: context,
                                                password: adminData.password);
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
                            )),
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
