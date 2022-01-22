import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rsta/AdminProfile/AddNewAdmin.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomTextFields.dart';
import 'package:rsta/Services/authentication_functions.dart';

import 'Widget/LoginHeaderCustomClipper.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = "/LoginPage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword(String email) async {
    bool error = false;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      error = true;
      // print(e.code + ".................");
      if (e.code == "ERROR_INVALID_EMAIL") {
        Fluttertoast.showToast(msg: "Enter a proper email id");
      } else if (e.code == "ERROR_USER_NOT_FOUND") {
        Fluttertoast.showToast(msg: "No user exists with this email");
      } else {
        Fluttertoast.showToast(
            msg: "OOPS something went wrong. Please try again");
      }
    }
    if (!error) {
      Fluttertoast.showToast(msg: "Password reset link sent successfully");
    }
    error = false;
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
                  decoration: BoxDecoration(
                    gradient: customGradient(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "RSTA ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
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
              flex: 5,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                                endIndent: 12,
                              ),
                            ),
                            Text(
                              "Login with E-mail",
                              style: TextStyle(fontSize: 18),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                                indent: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        CustomTextField.email(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email!';
                            }
                            return null;
                          },
                          hint: "Email Id",
                          controller: _emailController,
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 24),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomTextField.password(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password!';
                            }
                            return null;
                          },
                          hint: "Password",
                          controller: _passwordController,
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 24),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomButton.gradientBackground(
                          text: "Log In",
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          fontSize: 16,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(16),
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              await AuthenticationFunctions
                                  .logInWithEmailAndPassword(
                                context: context,
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            }
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController _resetPassword =
                                        TextEditingController();
                                    return AlertDialog(
                                      content: TextField(
                                        controller: _resetPassword,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "Enter your email ID",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await resetPassword(
                                                  _resetPassword.text);
                                            },
                                            child: Text('Reset Password'))
                                      ],
                                    );
                                  });
                            },
                            child: Text('Forgot Password?')),
                        Text("OR"),
                        TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AddNewAdmin.routeName),
                            child: Text('Add New Admin')),
                      ],
                    ),
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
