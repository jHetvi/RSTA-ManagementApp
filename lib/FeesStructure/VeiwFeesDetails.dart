import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Models/Student.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/Services/authentication_functions.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class FeesDetailScreen extends StatefulWidget {
  static final String routeName = "/FeesDetailScreen";

  @override
  _FeesDetailScreenState createState() => _FeesDetailScreenState();
}

class _FeesDetailScreenState extends State<FeesDetailScreen>
    with SingleTickerProviderStateMixin {
  final _viewFeesformKey = GlobalKey<FormState>();
  String _viewFeesDocId;
  String _alertMessage;
  bool nullCheck() {
    if (_viewFeesDocId == null || _viewFeesDocId.isEmpty) {
      _alertMessage = 'Please select any Student';
      return false;
    }
    return true;
  }

  double _animatedHeight;

  @override
  void initState() {
    _animatedHeight = 0.0;
    super.initState();
  }

  List<Student> userList;
  String query = "";
  Map<String, String> selectedValueMap = Map();
  final AuthenticationFunctions _authMethods = AuthenticationFunctions();

  searchAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(36),
      ),
      child: FutureBuilder(
        future: _authMethods.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return getSearchableDropdown(snapshot.data, "Students");
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container();
        },
      ),
    );
  }

  Widget getSearchableDropdown(List<Student> otherUsersList, mapKey) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < otherUsersList.length; i++) {
      items.add(new DropdownMenuItem(
        child: new Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: pinkColor(),
                      backgroundImage: otherUsersList[i].profileImgUrl == ""
                          ? AssetImage("assets/images/avatar.jpg")
                          : NetworkImage(otherUsersList[i].profileImgUrl),
                      minRadius: 30.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          otherUsersList[i].name,
                          style: TextStyle(
                              fontSize: 23.0,
                              color: Colors.black,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          otherUsersList[i].batch,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          otherUsersList[i].time,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
        value: otherUsersList[i].studentId,
      ));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: new SearchableDropdown(
        items: items,
        value: selectedValueMap[mapKey],
        isCaseSensitiveSearch: false,
        hint: new Text('Search...',
            style: TextStyle(color: Colors.grey, fontSize: 18.0)),
        searchFn: (String keyword, items) {
          // ignore: deprecated_member_use
          List<int> ret = List<int>();
          if (keyword != null && items != null && keyword.isNotEmpty) {
            keyword.split(" ").forEach((k) {
              int i = 0;
              items.forEach((item) {
                if (k.isNotEmpty &&
                    (item.value
                        .toString()
                        .toLowerCase()
                        .startsWith(k.toLowerCase()))) {
                  ret.add(i);
                }
                i++;
              });
            });
          }
          if (keyword.isEmpty) {
            ret = Iterable<int>.generate(items.length).toList();
          }
          return (ret);
        },
        icon: Icon(
          Icons.person_search,
          color: Colors.white,
          size: 24.0,
        ),
        underline: Padding(
          padding: EdgeInsets.all(5),
        ),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            selectedValueMap[mapKey] = value;
            _viewFeesDocId = value.toString();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var studRef =
        FirebaseFirestore.instance.collection("Student").doc(_viewFeesDocId);
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
                          "Fees Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
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
                          key: _viewFeesformKey,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 0),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Find Student's fees Details'.",
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
                                  label: "Name",
                                  value: searchAppBar(context),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomButton.gradientBackground(
                                    onTap: () async {
                                      if (_viewFeesformKey.currentState
                                              .validate() &&
                                          nullCheck()) {
                                        _viewFeesformKey.currentState.save();
                                        setState(() {
                                          _animatedHeight =
                                              MediaQuery.of(context)
                                                  .size
                                                  .height;
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
                        child: _viewFeesDocId == null || _viewFeesDocId.isEmpty
                            ? Container()
                            : StreamBuilder<DocumentSnapshot>(
                                stream: studRef.snapshots(),
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
                                      !snapshot.hasData ||
                                      snapshot.data.get("Last Received fees") ==
                                          null) {
                                    return Text("No fees details updated yet",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            "Error fetching data. Please try again later.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            )));
                                  } else
                                    return SingleChildScrollView(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: CircleAvatar(
                                                    radius: 80,
                                                    backgroundColor:
                                                        pinkColor(),
                                                    backgroundImage: snapshot
                                                                    .data[
                                                                Student
                                                                    .PROFILE_IMAGE_URL] ==
                                                            ""
                                                        ? AssetImage(
                                                            "assets/images/avatar.jpg")
                                                        : CachedNetworkImageProvider(
                                                            snapshot.data[Student
                                                                .PROFILE_IMAGE_URL])),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data[Student.NAME] ==
                                                        null
                                                    ? "Name: --"
                                                    : "Name: ${snapshot.data[Student.NAME]}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data[Student.BATCH] ==
                                                        null
                                                    ? "Batch: --"
                                                    : "Batch: ${snapshot.data[Student.BATCH]}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data[Student.TIME] ==
                                                        null
                                                    ? "Time: --"
                                                    : "Time: ${snapshot.data[Student.TIME]}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data[
                                                            'Last Received fees'] ==
                                                        null
                                                    ? "Fees: --"
                                                    : "Fees: ${snapshot.data['Last Received fees']}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data['Date(from)']
                                                            .toString() ==
                                                        null
                                                    ? "Date(From): --"
                                                    : "Date(From): ${DateFormat("dd/MM/yyyy").format(snapshot.data['Date(from)'].toDate())}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data['Date(To)']
                                                            .toString() ==
                                                        null
                                                    ? "Date(To): --"
                                                    : "Date(To): ${DateFormat("dd/MM/yyyy").format(snapshot.data['Date(To)'].toDate())}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data[
                                                            'Mode of Payment'] ==
                                                        null
                                                    ? "Mode of Payment: --"
                                                    : "Mode of Payment: ${snapshot.data['Mode of Payment']}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                snapshot.data['Received By'] ==
                                                        null
                                                    ? "Received By: --"
                                                    : "Received By: ${snapshot.data['Received By']}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          )
                                          // })),
                                          ),
                                    );
                                }),
                        height: _animatedHeight,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
