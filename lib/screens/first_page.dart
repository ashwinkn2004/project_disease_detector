import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_disease_detector/screens/login_page.dart';
import 'package:project_disease_detector/screens/signup_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  void _onGetStartedTap(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  void _onLoginTap(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Center(
              child: SizedBox(
                height: 250,
                width: 300,
                child: Image.asset('asset/logo.png'),
              ),
            ),
          ),
          Center(
            child: Text(
              'Disease \nDetector',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () => _onGetStartedTap(context),
            child: Container(
              width: 250,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(
                child: Text(
                  'Get Started',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _onLoginTap(context),
            child: Container(
              width: 250,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Text("Copyright © 2025", style: GoogleFonts.raleway()),
          ),
        ],
      ),
    );
  }
}
