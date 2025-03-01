import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project_disease_detector/model/model.dart';
import 'package:project_disease_detector/screens/details.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  List<Disease> diseases = [];
  final String apiUrl = 'http://34.31.80.242:5000/predict';
  final String pingUrl = 'http://34.31.80.242:5000/ping';

  @override
  void initState() {
    super.initState();
    _listenToFirestoreUpdates();
    // Initial fetch for debugging
    _fetchAndStorePrediction();
  }

  // Check server status
  Future<bool> _checkServerStatus() async {
    try {
      final response = await http.get(Uri.parse(pingUrl));
      print("Ping Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Server check failed: $e");
      return false;
    }
  }

  // Fetch prediction from API and store in Firestore
  Future<void> _fetchAndStorePrediction() async {
    try {
      if (!await _checkServerStatus()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server is not responding')),
        );
        return;
      }

      print("🔄 Sending request to API...");
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}), // Empty body - might be causing 400
      );

      print("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Decoded Data: $data");

        String diseaseName = data['predicted_disease'] ?? 'Unknown';
        double confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;

        DateTime now = DateTime.now();
        String date = "${now.year}-${now.month}-${now.day}";
        String time = "${now.hour}:${now.minute}:${now.second}";

        print("✅ Disease Detected: $diseaseName ($confidence)");

        // Store in Firestore
        await FirebaseFirestore.instance.collection('diseases').add({
          'diseaseName': diseaseName,
          'confidence': confidence,
          'date': date,
          'time': time,
          'processedFrom': 'Flutter App',
        });

        print("🔥 Successfully stored in Firestore!");
      } else {
        print("⚠ API Error: ${response.statusCode}, ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prediction failed: ${response.statusCode} - ${response.body}')),
        );
        // Temporary workaround: Add dummy data if API fails
        await _addDummyData();
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing prediction: $e')),
      );
    }
  }

  // Temporary workaround to add dummy data
  Future<void> _addDummyData() async {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    String time = "${now.hour}:${now.minute}:${now.second}";

    await FirebaseFirestore.instance.collection('diseases').add({
      'diseaseName': 'Test Disease (from trial.py)',
      'confidence': 0.85,
      'date': date,
      'time': time,
      'processedFrom': 'Flutter Fallback',
    });
    print("🔥 Added dummy data to Firestore!");
  }

  // Listen for real-time Firestore updates
  void _listenToFirestoreUpdates() {
    print("🔍 Setting up Firestore listener...");
    FirebaseFirestore.instance
        .collection('diseases')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      print("📡 Firestore snapshot received: ${snapshot.docs.length} documents");
      setState(() {
        diseases = snapshot.docs.map((doc) {
          print("Document data: ${doc.data()}");
          return Disease(
            imagePath: "img",
            diseaseName: doc['diseaseName'] ?? 'Unknown',
            date: doc['date'] ?? '',
            time: doc['time'] ?? '',
          );
        }).toList();
      });
    }, onError: (error) {
      print("❌ Firestore listener error: $error");
    });
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
                          physics: NeverScrollableScrollPhysics(),
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
                                      "img",
                                      style: GoogleFonts.raleway(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Date: ${diseases[index].date}",
                                                style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _fetchAndStorePrediction,
          child: Icon(Icons.refresh),
          tooltip: 'Refresh Prediction',
        ),
      ),
    );
  }
}