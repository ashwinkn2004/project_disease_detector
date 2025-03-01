import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_disease_detector/model/model.dart';
import 'package:project_disease_detector/screens/details.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  List<Disease> diseases = [];
  final String apiUrl = 'http://34.31.80.242:5000/predict';  // Your Flask API endpoint

  @override
  void initState() {
    super.initState();
    _listenToFirestoreUpdates();
    _fetchNewPrediction();
  }

  // Listen for real-time updates in Firestore
  void _listenToFirestoreUpdates() {
    FirebaseFirestore.instance
        .collection('diseases')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        diseases = snapshot.docs.map((doc) {
          return Disease(
            imagePath: "img", // Update image path as needed
            diseaseName: doc['diseaseName'],
            date: doc['date'],
            time: doc['time'],
          );
        }).toList();
      });
    });
  }

  // Fetch prediction from Flask API and update Firebase
  Future<void> _fetchNewPrediction() async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("🔍 API Response: $data");

        String predictedDisease = data['predicted_disease'];
        double confidence = data['confidence'];

        // Get the current timestamp
        DateTime now = DateTime.now();
        String date = "${now.year}-${now.month}-${now.day}";
        String time = "${now.hour}:${now.minute}:${now.second}";

        // Add to Firebase Firestore
        await FirebaseFirestore.instance.collection('diseases').add({
          'diseaseName': predictedDisease,
          'confidence': confidence,
          'date': date,
          'time': time,
        });

        print("✅ Disease added to Firestore: $predictedDisease ($confidence%)");
      } else {
        print("⚠ API Error: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'asset/logo.png',
                height: 30,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
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
                                color: Colors.black),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: diseases.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseaseDetailScreen(
                                      disease: diseases[index],
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
                                    Text(
                                      "img", // Text placeholder for the image
                                      style: GoogleFonts.raleway(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            diseases[index].diseaseName,
                                            style: GoogleFonts.raleway(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "Date: ${diseases[index].date}",
                                                style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                "Time: ${diseases[index].time}",
                                                style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Colors.grey),
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
