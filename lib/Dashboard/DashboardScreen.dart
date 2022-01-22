import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsta/AdminProfile/AdminProfile.dart';
import 'package:rsta/BatchDetails/BatchDetailsScreen.dart';
import 'package:rsta/FeesStructure/FeesDetailsScreen.dart';
import 'package:rsta/FeesStructure/VeiwFeesDetails.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/Custom_Dialog_box.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/StudentProfile/RegisterNewStudent.dart';

class DashboardScreen extends StatefulWidget {
  static final String routeName = "/DashboardScreen";
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Admin")
                              .doc(currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                backgroundImage: snapshot.data[
                                            Admin.PROFILE_THUMB_IMAGE_URL] ==
                                        null
                                    ? AssetImage("assets/images/avatar.jpg")
                                    : CachedNetworkImageProvider(snapshot
                                        .data[Admin.PROFILE_THUMB_IMAGE_URL]),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AdminProfile.routeName);
                              },
                            );
                          }),
                      Text(
                        "RSTA ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: () {
                            setState(() {});
                          })
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Admin")
                              .doc(currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Container(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Welcome to RSTA, " +
                                      snapshot.data[Admin.NAME] +
                                      " !",
                                  style: TextStyle(
                                      color: Color(0xFFFF4D4D).withOpacity(1.0),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ));
                          }),
                      GestureDetector(
                        child: Card(
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
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.of(context)
                                .pushNamed(RegisterNewStudent.routeName);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        child: Card(
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
                                "Batch Details",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.of(context)
                                .pushNamed(BatchDetailScreen.routeName);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                          child: Card(
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
                                  "Fees Structure",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, _, __) =>
                                        CustomDialogBox(
                                          title: "Choose fees details:",
                                          button1:
                                              CustomButton.gradientBackground(
                                                  onTap: () {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              FeesDetailScreen
                                                                  .routeName);
                                                    });
                                                  },
                                                  text: "Vew Fees Details"),
                                          button2:
                                              CustomButton.gradientBackground(
                                                  onTap: () {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              FeesStructureScreen
                                                                  .routeName);
                                                    });
                                                  },
                                                  text: "Add New Fees Details"),
                                        )),
                              );
                            });
                          })
                    ],
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
