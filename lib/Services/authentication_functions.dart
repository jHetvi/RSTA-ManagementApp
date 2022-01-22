import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;
import 'package:rsta/Dashboard/DashboardScreen.dart';
import 'package:rsta/Global/Functions/CustomDialogs.dart';
import 'package:rsta/Global/Functions/DatabaseFunction.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Student.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/Global/Widgets/error_dialog.dart';
import 'package:rsta/SplashScreen/SplashScreen.dart';

UserCredential _authResult;
AuthCredential _phoneCredential;

class AuthenticationFunctions {
  static Future<void> logInWithEmailAndPassword(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    try {
      _authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      currentUser = _authResult.user;
      initUserDataStream();
      Navigator.pop(context);
      if (currentUser != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (route) => false);
      }
    } on PlatformException catch (error) {
      Navigator.pop(context);
      DefaultErrorDialog.showErrorDialog(
          context: context, message: error.message);
    } catch (error) {
      print(error);
      DefaultErrorDialog.showErrorDialog(context: context);
    }
  }

  static Future<void> signupWithEmailAndPassword(
      {@required BuildContext context, @required String password}) async {
    try {
      _authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: adminData.emailId, password: password);
      currentUser = _authResult.user;
    } on PlatformException catch (error) {
      DefaultErrorDialog.showErrorDialog(
          context: context, message: error.message);
    } catch (error) {
      DefaultErrorDialog.showErrorDialog(context: context);
    }
  }

  static Future<void> signUpWithEmail(
      {@required BuildContext context, @required String password}) async {
    try {
      final _storageRef = FirebaseStorage.instance.ref().child('profileImages');
      final _storageRefThumb =
          FirebaseStorage.instance.ref().child('ProfileImagesThumb');
      showLoadingDialog(context);

      await signupWithEmailAndPassword(context: context, password: password);
      adminData.adminId = _authResult.user.uid;
      if (profileImage != null)
        try {
          await _storageRef
              .child(_authResult.user.uid)
              .child('profileImage.png')
              .putFile(profileImage);
          adminData.profileImgUrl = await _storageRef
              .child(_authResult.user.uid)
              .child('profileImage.png')
              .getDownloadURL();

          try {
            Im.Image tempImg = Im.decodeImage(profileImage.readAsBytesSync());
            Im.Image smallerImage =
                Im.copyResize(tempImg, width: 300, height: 300);
            profileImage
              ..writeAsBytesSync(Im.encodePng(smallerImage, level: 7));
            await _storageRefThumb
                .child(_authResult.user.uid)
                .child('profileImage.png')
                .putFile(profileImage);
            adminData.profileThumbImgUrl = await _storageRefThumb
                .child(_authResult.user.uid)
                .child('profileImage.png')
                .getDownloadURL();
          } catch (e) {
            adminData.profileThumbImgUrl = adminData.profileImgUrl;
            print(e.toString());
          }
        } catch (error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile pricture upload failed!')));
        }
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(currentUser.uid)
          .set(adminData.toJson()
            ..[Admin.CREATE_TIMESTAMP] = FieldValue.serverTimestamp()
            ..[Admin.LAST_UPDATE_DATETIME] = FieldValue.serverTimestamp())
          .whenComplete(() {
        FirebaseFirestore.instance
            .collection('Admin')
            .doc('--Total Memebers--')
            .update({'count': FieldValue.increment(1)});
      });

      initUserDataStream();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
    } on PlatformException catch (error) {
      Navigator.pop(context);
      DefaultErrorDialog.showErrorDialog(
          context: context, message: error.message);
      try {
        await _authResult.user.delete();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
      } catch (error) {}
    } catch (error) {
      print(error);
      Navigator.pop(context);
      DefaultErrorDialog.showErrorDialog(context: context);
      try {
        await _authResult.user.delete();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
      } catch (error) {}
    }
  }

  Future<List<Student>> fetchAllUsers() async {
    List<Student> userList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("Student").get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      userList.add(Student.fromMap(querySnapshot.docs[i].data()));
    }
    return userList;
  }

  static Future<void> logout(
      {@required BuildContext context, @required String routeName}) async {
    try {
      await FirebaseAuth.instance.signOut();
      currentUser = null;
      profileImage = null;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    } on PlatformException catch (error) {
      DefaultErrorDialog.showErrorDialog(
          context: context, message: error.message);
    } catch (_) {
      DefaultErrorDialog.showErrorDialog(context: context);
    }
  }

/*   static Future<void> onNewToken({@required BuildContext context}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Donors')
          .doc(currentUser.uid)
          .set(donorData.toJson()
            ..['device_tokens'] =
                FieldValue.arrayUnion(["$Widget.post.token"]));
    } on PlatformException catch (error) {
      DefaultErrorDialog.showErrorDialog(
          context: context, message: error.message);
    } catch (_) {
      DefaultErrorDialog.showErrorDialog(context: context);
    }
  } */
}
