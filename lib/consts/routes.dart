import 'package:flutter/material.dart';
import 'package:project_disease_detector/screens/first_page.dart';
import 'package:project_disease_detector/screens/login_page.dart';
import 'package:project_disease_detector/screens/signup_page.dart';
import 'package:project_disease_detector/screens/updates.dart';

class Routes {
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String update = '/update';
  static const String firstPage = '/firstPage';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signUp: (BuildContext context) => SignupScreen(),
      login: (BuildContext context) => LoginScreen(),
      update: (BuildContext context) => UpdateScreen(),
      firstPage: (BuildContext context) => FirstPage(),
    };
  }
}
