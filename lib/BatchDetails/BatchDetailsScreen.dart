import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomDropdownMenuButton.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/StudentProfile/StudentDetails/StudentDetailscreen.dart';

class BatchDetailScreen extends StatefulWidget {
  static final String routeName = "/BatchDetailScreen";

  @override
  _BatchDetailScreenState createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen>
    with SingleTickerProviderStateMixin {
  final _batchformKey = GlobalKey<FormState>();
  var _batchContoller = TextEditingController();
  var _timeContoller = TextEditingController();
  String _alertMessage;
  bool nullCheck() {
    if (_batchContoller.text.isEmpty ||
        _timeContoller.text.isEmpty ||
        _batchContoller.text.startsWith("z") ||
        _timeContoller.text.startsWith("z")) {
      _alertMessage = 'Please enter your ';
      _alertMessage += _batchContoller.text.isEmpty ? ' Batch Name ,' : '';
      _alertMessage += _timeContoller.text.isEmpty ? ' Batch Time ,' : '';
      _alertMessage +=
          _batchContoller.text.startsWith("z") ? ' Batch Name ,' : '';
      _alertMessage +=
          _timeContoller.text.startsWith("z") ? ' Batch Time ,' : '';

      return false;
    }
    return true;
  }

  double _animatedHeight;
  double _animatedHeight2;

  @override
  void initState() {
    _animatedHeight = 0.0;
    _animatedHeight2 = 0.0;
    _batchContoller.text = "z";
    _timeContoller.text = "z";
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop()),
                      Expanded(
                        child: Text(
                          "Batch Details",
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
                  child: Column(
                    children: [
                      Form(
                          key: _batchformKey,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 0),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Find Student & Batch Details.",
                                    style: TextStyle(
                                        color:
                                            Color(0xFFFF4D4D).withOpacity(1.0),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
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
                                        hint: "Select Batch....",
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
                                        hint: "Select Time...",
                                        onChange: (str) => _timeContoller =
                                            str as TextEditingController,
                                        controller: _timeContoller,
                                        isExpanded: true,
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomButton.gradientBackground(
                                    onTap: () async {
                                      if (_batchformKey.currentState
                                              .validate() &&
                                          nullCheck()) {
                                        _batchformKey.currentState.save();
                                        setState(() {
                                          _animatedHeight =
                                              MediaQuery.of(context)
                                                  .size
                                                  .height;
                                          _animatedHeight2 = 100;
                                        });
                                      } else if (!nullCheck()) {
                                        DefaultErrorDialog.showErrorDialog(
                                          context: context,
                                          title: 'Alert !',
                                          message: _alertMessage,
                                        );
                                      }
                                    },
                                    text: "Check")
                              ]))),
                      SizedBox(height: 30.0),
                      AnimatedContainer(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(5, 5),
                              ),
                            ],
                            color: Colors.white,
                            border: Border.all(color: redColor(), width: 2)),
                        duration: const Duration(milliseconds: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'List of players in batch ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${_batchContoller.text}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextSpan(text: ' at timing '),
                                  TextSpan(
                                      text: '${_timeContoller.text}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextSpan(text: ' is below:'),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("Batch")
                                    .doc(_batchContoller.text)
                                    .collection(_timeContoller.text)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      !snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: pinkColor(),
                                      ),
                                    );
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done ||
                                      !snapshot.hasData) {
                                    return Text(
                                        "No Students registered yet in this batch",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            "Error fecthing data. Please try again later.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            )));
                                  } else {
                                    List<QueryDocumentSnapshot> allData = [];
                                    for (int i = 0;
                                        i < snapshot.data.docs.length;
                                        i++) {
                                      allData.add(snapshot.data.docs[i]);
                                    }

                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: allData.length,
                                        itemBuilder: (_, i) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                                backgroundColor: pinkColor(),
                                                backgroundImage: snapshot
                                                                .data.docs[i][
                                                            "profile_img_url"] ==
                                                        null
                                                    ? AssetImage(
                                                        "assets/images/avatar.jpg")
                                                    : CachedNetworkImageProvider(
                                                        snapshot.data.docs[i][
                                                            "profile_img_url"])),
                                            title: GestureDetector(
                                              child: Text(
                                                  snapshot.data.docs[i]['nm'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              onTap: () {
                                                setState(() {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => StudentDetailsScreen(
                                                            studentId: snapshot.data.docs[i]
                                                                ['student_id'],
                                                            name: snapshot.data
                                                                .docs[i]['nm'],
                                                            img: snapshot.data.docs[i][
                                                                "profile_img_url"],
                                                            email: snapshot.data.docs[i]
                                                                ["email_Id"],
                                                            age: snapshot.data
                                                                .docs[i]["age"],
                                                            phoneNo: snapshot.data.docs[i]
                                                                ["whats_app_no"],
                                                            batch: snapshot.data.docs[i]["batch"],
                                                            time: snapshot.data.docs[i]["timin"],
                                                            fees: snapshot.data.docs[i]["fees"],
                                                            dob: snapshot.data.docs[i]["dob"],
                                                            remarks: snapshot.data.docs[i]["remarks"])),
                                                  );
                                                });
                                              },
                                            ),
                                          );
                                        });
                                  }
                                })
                          ],
                        ),
                        height: _animatedHeight,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(height: 10.0),
                      AnimatedContainer(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(5, 5),
                              ),
                            ],
                            color: Colors.white,
                            border: Border.all(color: redColor(), width: 2)),
                        duration: const Duration(milliseconds: 120),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Batch")
                                .doc(_batchContoller.text)
                                .collection(_timeContoller.text)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: pinkColor(),
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                      ConnectionState.done ||
                                  !snapshot.hasData) {
                                return Text(
                                    "No Students registered yet in this batch",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        "Error fecthing data. Please try again later.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        )));
                              } else {
                                List<String> allData = [];
                                for (int i = 0;
                                    i < snapshot.data.docs.length;
                                    i++) {
                                  allData.add(
                                      snapshot.data.docs.length.toString());
                                }

                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Total no. of players: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data.docs.length
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                );
                              }
                            }),
                        height: _animatedHeight2,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
