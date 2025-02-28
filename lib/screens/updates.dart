import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_disease_detector/model/model.dart';
import 'package:project_disease_detector/screens/details.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  List<Disease> diseases = [
    Disease(
      imagePath: 'img', // Text placeholder for image
      diseaseName: 'Disease Name 1',
      date: '2025-02-10',
      time: '10:00 AM',
    ),
    Disease(
      imagePath: 'img', // Text placeholder for image
      diseaseName: 'Disease Name 2',
      date: '2025-02-12',
      time: '2:30 PM',
    ),
    Disease(
      imagePath: 'img', // Text placeholder for image
      diseaseName: 'Disease Name 3',
      date: '2025-02-14',
      time: '5:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back button press from signing out
        return Future.value(false); // Return false to prevent the back button action
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.black), // Logout icon
            onPressed: () async {
              // Sign out the user from Firebase
              await FirebaseAuth.instance.signOut();
              // Navigate to the login screen
              Navigator.pushReplacementNamed(
                  context, '/login'); // Route to Login
            },
          ),
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
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Center(
                  child: Text(
                    "UPDATES",
                    style: GoogleFonts.raleway(
                        fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Large container for displaying the diseases or the no diseases message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: diseases.isEmpty
                      ? Center(
                          child: Text(
                            "No disease detected",
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: diseases.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the DiseaseDetailScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseaseDetailScreen(
                                      disease: diseases[
                                          index], // Pass the selected disease
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Image placeholder
                                    Text(
                                      diseases[index]
                                          .imagePath, // Displaying text "img"
                                      style: GoogleFonts.raleway(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    // Disease details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            diseases[index].diseaseName,
                                            style: GoogleFonts.raleway(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Date: ${diseases[index].date}",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                "Time: ${diseases[index].time}",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
