import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/StudentProfile/StudentDetails/StudentEditProfile.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String studentId,
      img,
      name,
      email,
      age,
      phoneNo,
      batch,
      time,
      fees,
      remarks;
  final Timestamp dob;

  StudentDetailsScreen({
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
    this.remarks,
  });
  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
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
                          "Student Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PopupMenuButton(
                          onSelected: null,
                          tooltip: 'Menu',
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                            pageBuilder: (context, _, __) =>
                                                StudentEditProfile(
                                                  studentId: widget.studentId,
                                                  name: widget.name,
                                                  img: widget.img,
                                                  email: widget.email,
                                                  age: widget.age,
                                                  phoneNo: widget.phoneNo,
                                                  batch: widget.batch,
                                                  time: widget.time,
                                                  fees: widget.fees,
                                                  dob: widget.dob,
                                                )),
                                      );
                                    },
                                    onPanCancel: () =>
                                        Navigator.of(context).pop(),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(child: Text("Edit Profile"))
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: GestureDetector(
                                    onTap: () => addRemarks(),
                                    onPanCancel: () =>
                                        Navigator.of(context).pop(),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(child: Text("Add Remarks")),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
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
                    child: SingleChildScrollView(
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CircleAvatar(
                                    radius: 80,
                                    backgroundColor: pinkColor(),
                                    backgroundImage: widget.img == ""
                                        ? AssetImage("assets/images/avatar.jpg")
                                        : CachedNetworkImageProvider(
                                            widget.img)),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.name == null
                                    ? "Name: --"
                                    : "Name: ${widget.name}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.email == null
                                    ? "Email: --"
                                    : "Email: ${widget.email}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.dob.toString() == null
                                    ? "DOB: --"
                                    : "DOB: ${widget.dob.toDate().toString().substring(0, 10)}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.age == null
                                    ? "Age: --"
                                    : "Age: ${widget.age}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.phoneNo == null
                                    ? "Conatct No: --"
                                    : "Conatct No: ${widget.phoneNo}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.batch == null
                                    ? "Batch: --"
                                    : "Batch: ${widget.batch}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.time == null
                                    ? "Time: --"
                                    : "Time: ${widget.time}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.fees == null
                                    ? "Fees: --"
                                    : "Fees: ${widget.fees}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                widget.remarks == null
                                    ? "Remarks: --"
                                    : "Remarks: ${widget.remarks}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                          // })),
                          ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  addRemarks() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController con = TextEditingController();
          return AlertDialog(
            content: TextField(
              controller: con,
              decoration: InputDecoration(
                hintText: "Add Remarks",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (con.text != null) {
                      await FirebaseFirestore.instance
                          .collection('Student')
                          .doc(widget.studentId)
                          .update({'remarks': con.text}).whenComplete(() async {
                        await FirebaseFirestore.instance
                            .collection('Batch')
                            .doc(widget.batch)
                            .collection(widget.time)
                            .doc(widget.studentId)
                            .update({'remarks': con.text}).whenComplete(() {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        });
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Enter a valid text");
                    }
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}
