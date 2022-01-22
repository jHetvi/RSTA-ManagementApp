import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsta/AdminProfile/AddNewAdmin.dart';
import 'package:rsta/AdminProfile/AdminEditProfile.dart';
import 'package:rsta/AdminProfile/AdminProfile.dart';
import 'package:rsta/BatchDetails/BatchDetailsScreen.dart';
import 'package:rsta/Dashboard/DashboardScreen.dart';
import 'package:rsta/FeesStructure/FeesDetailsScreen.dart';
import 'package:rsta/FeesStructure/VeiwFeesDetails.dart';
import 'package:rsta/LogInScreen.dart/logInScreen.dart';
import 'package:rsta/SplashScreen/SplashScreen.dart';
import 'package:rsta/StudentProfile/RegisterNewStudent.dart';

const debug = true;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Timer _timerLink;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 1000), () {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rising Star Tennis Accademy",
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: SplashScreen(),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          AdminEditProfile.routeName: (ctx) => AdminEditProfile(),
          AddNewAdmin.routeName: (ctx) => AddNewAdmin(),
          AdminProfile.routeName: (ctx) => AdminProfile(),
          RegisterNewStudent.routeName: (ctx) => RegisterNewStudent(),
          BatchDetailScreen.routeName: (ctx) => BatchDetailScreen(),
          FeesStructureScreen.routeName: (ctx) => FeesStructureScreen(),
          FeesDetailScreen.routeName: (ctx) => FeesDetailScreen(),
        });
  }
}
