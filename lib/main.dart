import 'package:flutter/material.dart';
import 'package:tboxapp/views/data_main.dart';
import 'package:tboxapp/views/faq.dart';
import 'package:tboxapp/views/faq_answer.dart';
import 'package:tboxapp/views/newsfeed.dart';
import 'package:tboxapp/views/newsfeed_body.dart';
import 'package:tboxapp/views/profile_my.dart';
import 'package:tboxapp/views/qna.dart';
import 'package:tboxapp/views/store.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/views/ble_devices.dart';
import 'package:tboxapp/views/find_id.dart';
import 'package:tboxapp/views/find_pw.dart';
import 'package:tboxapp/views/home.dart';
import 'package:tboxapp/views/login.dart';
import 'package:tboxapp/views/signup.dart';
import 'package:tboxapp/views/splash.dart';
import 'package:tboxapp/views/update_address.dart';
import 'package:tboxapp/views/update_password.dart';
import 'package:tboxapp/views/coach.dart';
import 'package:tboxapp/views/vod_fav.dart';
import 'package:tboxapp/views/vod_selected.dart';

void main() {
  runApp(MyAppNavigator());
}

class MyAppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(title: myTitle, theme: myThemeData, initialRoute: '/', routes: {
        '/': (context) => HomeScreen(),
        '/ble_devices': (context) => BleDevicesScreen(),
        '/splash': (context) => SplashScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/find_id': (context) => FindIdScreen(),
        '/find_pw': (context) => FindPwScreen(),
        '/store': (context) => StoreScreen(),
        '/faq': (context) => FaqScreen(),
        '/faq_answer': (context) => FaqAnswerScreen(),
        '/newsfeed': (context) => NewsfeedScreen(),
        '/newsfeed_body': (context) => NewsfeedBodyScreen(),
        '/qna': (context) => QnaScreen(),
        '/profile_my': (context) => ProfileMyScreen(),
        '/update_password': (context) => UpdatePasswordScreen(),
        '/update_address': (context) => UpdateAddressScreen(),
        // '/update_cellphone': (context) => UpdateCellphoneScreen(),
        '/coach': (context) => CoachScreen(),
        '/vod_fav': (context) => VodFavScreen(),
        // '/vod_selected': (context) => VodSelectedScreen(),
        '/data_main': (context) => DataMainScreen(),
      });
}
