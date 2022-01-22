import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rsta/Global/Models/Admin.dart';
import 'package:rsta/Global/Models/Student.dart';

File profileImage;
User currentUser;
Admin adminData;
Student studentData;
StreamSubscription<DocumentSnapshot> userDataStreamSub;
