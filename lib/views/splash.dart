import 'package:flutter/material.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/views/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3, milliseconds: 500), () {
      print("kjkjkjkjkjkjkkjkjkj");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      // Navigator.popAndPushNamed(context, '/');
      // Navigator.pushReplacementNamed(context, '/');
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPrimaryBlueColor,
      body: Center(
          child: Image(
        image: AssetImage('assets/images/logo.png'),
        width: 200,
      )),
    );
  }

  @override
  void dispose() {
    print("#6666666666666666666666666666666#");
    super.dispose();
  }
}
