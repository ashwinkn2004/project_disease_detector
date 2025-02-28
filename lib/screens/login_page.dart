import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:google_fonts/google_fonts.dart';
import 'package:project_disease_detector/screens/signup_page.dart'; // For Google Fonts

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // Track the visibility of the password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = ''; // To show any error message

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'asset/logo.png', // Replace with the path to your logo image
              height: 30, // Set the height of the logo
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Center(
                child: Text(
                  "Login",
                  style: GoogleFonts.raleway(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.5),
                  ),
                ),
                style: GoogleFonts.raleway(),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: GoogleFonts.raleway(),
              ),
            ),
            // Error Message for invalid login
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  _errorMessage,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () async {
                  // Try to login using Firebase Authentication
                  await _loginWithFirebase(context);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'Log in',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text("Don't have an account? ",
                      style: GoogleFonts.raleway(
                          fontSize: 15, color: Colors.grey)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: TextButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, '/signup');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: Center(
                  child:
                      Text("Copyright © 2025", style: GoogleFonts.raleway())),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle login using Firebase Authentication
  Future<void> _loginWithFirebase(BuildContext context) async {
    try {
      // Retrieve email and password from the text controllers
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter both email and password';
        });
        return;
      }

      // Attempt login using Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If login is successful, navigate to the next screen (updates page in this case)
      Navigator.pushNamed(context, '/update'); // Navigate to updates screen
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Incorrect password';
        } else {
          _errorMessage = 'Something went wrong. Please try again later';
        }
      });
    }
  }
}
