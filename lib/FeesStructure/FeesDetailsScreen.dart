import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rsta/Dashboard/DashboardScreen.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Models/Student.dart';
import 'package:rsta/Global/Widgets/CustomButton.dart';
import 'package:rsta/Global/Widgets/CustomDropdownMenuButton.dart';
import 'package:rsta/Global/Widgets/CustomTextFields.dart';
import 'package:rsta/Global/Widgets/TextKeyDynamicValueWidget.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/LogInScreen.dart/Widget/LoginHeaderCustomClipper.dart';
import 'package:rsta/Services/authentication_functions.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

class FeesStructureScreen extends StatefulWidget {
  static final String routeName = "/FeesStructureScreen";
  @override
  _FeesStructureScreenState createState() => _FeesStructureScreenState();
}

class _FeesStructureScreenState extends State<FeesStructureScreen> {
  final _feesformKey = GlobalKey<FormState>();
  String _docController;
  final _feesContoller = TextEditingController();
  var _modeOfPaymentContoller = TextEditingController();
  var _receivedByContoller = TextEditingController();
  String _alertMessage;
  Timestamp _fromDateContoller, _toDateContoller;

  bool nullCheck() {
    if (_docController.isEmpty ||
        _modeOfPaymentContoller.text.isEmpty ||
        _receivedByContoller.text.isEmpty ||
        _fromDateContoller.toString().isEmpty ||
        _toDateContoller.toString().isEmpty ||
        _feesContoller.text.isEmpty) {
      _alertMessage = 'Please enter your ';
      _alertMessage += _docController.isEmpty ? 'Name ,' : '';
      _alertMessage += _feesContoller.text.isEmpty ? ' Fees(Amount) ,' : '';
      _alertMessage +=
          _modeOfPaymentContoller.text.isEmpty ? 'Mode of payment ,' : '';
      _alertMessage += _receivedByContoller.text.isEmpty ? 'received by ,' : '';
      _alertMessage +=
          _fromDateContoller.toString().isEmpty ? 'date from,' : '';
      _alertMessage += _toDateContoller.toString().isEmpty ? 'date to ,' : '';

      return false;
    }
    return true;
  }

  @override
  void initState() {
    _fromDateContoller = Timestamp.now();
    _toDateContoller = Timestamp.now();
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
            _docController = value.toString();
          });
        },
      ),
    );
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
                          "Fees Details",
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
                          key: _feesformKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 20),
                            child: Column(
                              children: [
                                TextKeyDynamicValueWidget(
                                  label: "Name",
                                  value: searchAppBar(context),
                                ),
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
                                    controller: _feesContoller,
                                    hint: "Eg: 1000",
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                TextKeyDynamicValueWidget(
                                  label: "Date(from)",
                                  value: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 8),
                                    child: DateFormat("dd/MM/yyyy")
                                        .format(_fromDateContoller.toDate())
                                        .text
                                        .size(16)
                                        .make(),
                                  ).click(() async {
                                    var df = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            Duration(
                                                days: 365 * 120 + (120 ~/ 4),
                                                minutes: 1)),
                                        lastDate: DateTime.now());
                                    if (df != null)
                                      setState(() => _fromDateContoller =
                                          Timestamp.fromDate(df));
                                  }).make(),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                TextKeyDynamicValueWidget(
                                  label: "Date(to)",
                                  value: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 8),
                                    child: DateFormat("dd/MM/yyyy")
                                        .format(_toDateContoller.toDate())
                                        .text
                                        .size(16)
                                        .make(),
                                  ).click(() async {
                                    var dto = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            Duration(
                                                days: 365 * 120 + (120 ~/ 4),
                                                minutes: 1)),
                                        lastDate: DateTime.now());
                                    if (dto != null)
                                      setState(() => _toDateContoller =
                                          Timestamp.fromDate(dto));
                                  }).make(),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                TextKeyDynamicValueWidget(
                                    label: "Mode Of Payment",
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
                                          'Cash',
                                          'Cheque',
                                          'Online',
                                          'NetBanking'
                                        ].map((e) => MapEntry(e, e))),
                                        hint: "Eg : Cash",
                                        onChange: (str) =>
                                            _modeOfPaymentContoller =
                                                str as TextEditingController,
                                        controller: _modeOfPaymentContoller,
                                        isExpanded: true,
                                      ),
                                    )),
                                SizedBox(
                                  height: 24,
                                ),
                                TextKeyDynamicValueWidget(
                                    label: "Received by",
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
                                          'Yashad Ganatra',
                                          'Ronak Sanaldiya',
                                        ].map((e) => MapEntry(e, e))),
                                        hint: "Eg : Yashad Ganatra",
                                        onChange: (str) =>
                                            _receivedByContoller =
                                                str as TextEditingController,
                                        controller: _receivedByContoller,
                                        isExpanded: true,
                                      ),
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomButton.gradientBackground(
                                    onTap: () async {
                                      if (_feesformKey.currentState
                                              .validate() &&
                                          nullCheck()) {
                                        _feesformKey.currentState.save();

                                        var docRef = FirebaseFirestore.instance
                                            .collection('Student')
                                            .doc(_docController);
                                        docRef.update({
                                          'Last Received fees':
                                              _feesContoller.text,
                                          'Date(from)': _fromDateContoller,
                                          'Date(To)': _toDateContoller,
                                          'Mode of Payment':
                                              _modeOfPaymentContoller.text,
                                          'Received By':
                                              _receivedByContoller.text
                                        });
                                        Fluttertoast.showToast(
                                          msg:
                                              "Fees Details updated Successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          webBgColor: "#e74c3c",
                                          textColor: Colors.black,
                                          timeInSecForIosWeb: 5,
                                        );

                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                DashboardScreen.routeName,
                                                (route) => false);
                                      } else if (!nullCheck()) {
                                        DefaultErrorDialog.showErrorDialog(
                                          context: context,
                                          title: 'Alert !',
                                          message: _alertMessage,
                                        );
                                      }
                                    },
                                    text: "Save"),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),
                    )))
          ],
        ),
      ),
    );
  }
}
