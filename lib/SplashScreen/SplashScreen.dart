import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rsta/Dashboard/DashboardScreen.dart';
import 'package:rsta/Global/Functions/DatabaseFunction.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Gradients.dart';
import 'package:rsta/Global/Variables/GlobalVariables.dart';
import 'package:rsta/LogInScreen.dart/logInScreen.dart';
import 'package:rsta/wave/config.dart';
import 'package:rsta/wave/wave.dart';

class SplashScreen extends StatefulWidget {
  static final String routeName = "/SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Size size;
  Animation animate;
  AnimationController animatecontrol;

  @override
  void initState() {
    super.initState();
    animatecontrol =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animate = Tween<double>(begin: 0.0, end: 1).animate(animatecontrol);
    animatecontrol.forward();
    loginPageScreen();
  }

  Future<void> loginPageScreen() async {
    currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser != null) await currentUser.reload();
    } on FirebaseAuthException catch (e) {
      print("AuthException Code = " + e.code.toString());
      print("AuthException Message = " + e.message);
    } on FirebaseException catch (e) {
      print("showOnboardingScreen => PlatformException => e = " + e.toString());
    }
    return Future.delayed(Duration(seconds: 3), () {
      if (currentUser != null && mounted) {
        initUserDataStream();
        final data = currentUser.providerData;
        print(data);
        if (mounted) {
          initUserDataStream();
          Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
        }
      } else if (mounted)
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: whitecustomGradient(),
      ),
      height: double.maxFinite,
      width: double.maxFinite,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WaveWidget(
            config: CustomConfig(
              durations: [35000, 19440, 10800, 6000],
              heightPercentages: [0.63, 0.60, 0.62, 0.59],
              blur: MaskFilter.blur(BlurStyle.solid, 1),
              colors: [
                Colors.blueAccent.withOpacity(0.7),
                Colors.blueAccent.withOpacity(0.6),
                redColor().withOpacity(0.6),
                Colors.red.withOpacity(0.8),
              ],
            ),
            backgroundColor: Colors.transparent,
            size: Size(
              double.infinity,
              double.infinity,
            ),
          ),
          SafeArea(
              child: Column(
            children: [
              Expanded(
                flex: 7,
                child: AnimatedBuilder(
                  animation: animatecontrol,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, animate.value * size.height / 8),
                    child: Opacity(
                      opacity: animate.value,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "assets/images/rsta_logo.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    backgroundColor: Colors.blueAccent..withOpacity(0.125),
                    valueColor: AlwaysStoppedAnimation<Color>(redColor()),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    animatecontrol.dispose();
    super.dispose();
  }
}
