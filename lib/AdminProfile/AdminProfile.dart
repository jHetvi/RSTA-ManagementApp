import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsta/AdminProfile/AdminEditProfile.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/LogInScreen.dart/logInScreen.dart';
import 'package:rsta/Services/authentication_functions.dart';

class AdminProfile extends StatefulWidget {
  static final String routeName = "/AdminProfile";
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
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
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0),
                  decoration: BoxDecoration(
                    gradient: customGradient(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Admin Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: IconButton(
                            tooltip: "Edit Profile",
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AdminEditProfile.routeName)),
                      )
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
                  child: SingleChildScrollView(
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Admin")
                                .doc(currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: snapshot.data[Admin
                                                  .PROFILE_THUMB_IMAGE_URL] ==
                                              null
                                          ? AssetImage(
                                              "assets/images/avatar.jpg")
                                          : CachedNetworkImageProvider(snapshot
                                                  .data[
                                              Admin.PROFILE_THUMB_IMAGE_URL]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Name: " + snapshot.data[Admin.NAME],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Email: " + snapshot.data[Admin.EMAIL_ID],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Mobile: " +
                                        snapshot.data[Admin.PHONE_NUMBER],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Password: " +
                                        snapshot.data[Admin.PASSWORD],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  CustomButton.gradientBackground(
                                      onTap: () => showConfirmationDialog(
                                            context,
                                            onConfirm: () {
                                              AuthenticationFunctions.logout(
                                                  context: context,
                                                  routeName:
                                                      LoginPage.routeName);
                                            },
                                          ),
                                      text: "Log Out"),
                                ],
                              );
                            })),
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
