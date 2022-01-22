import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';

void initUserDataStream() {
  userDataStreamSub = FirebaseFirestore.instance
      .collection("Student")
      .doc(currentUser.uid)
      .snapshots()
      .listen((event) {
    if (event.exists) {
      adminData = Admin.fromDocSnap(event);

      print("New Student Data => " + adminData.toJson().toString());
    }
  });
}
