import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
import 'package:project_disease_detector/consts/routes.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized before running the app

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // If not logged in, show firstPage else show update screen
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? Routes.firstPage
          : Routes.update,
      routes: Routes.getRoutes(),
    );
  }
}
