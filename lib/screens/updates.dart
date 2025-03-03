import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_disease_detector/model/model.dart';
import 'package:project_disease_detector/screens/details.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  List<Disease> diseases = [];

  @override
  void initState() {
    super.initState();
    _listenToFirestoreUpdates();
  }

  // Listen for real-time Firestore updates
  void _listenToFirestoreUpdates() {
    print("🔍 Setting up Firestore listener...");
    FirebaseFirestore.instance
        .collection('diseases')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      print(
          "📡 Firestore snapshot received: ${snapshot.docs.length} documents");
      setState(() {
        diseases = snapshot.docs.map((doc) {
          print("Document data: ${doc.data()}");
          return Disease(
            imageBase64: doc['imageBase64'] ?? '',
            diseaseName: doc['diseaseName'] ?? 'Unknown',
            date: doc['date'] ?? '',
            time: doc['time'] ?? '',
          );
        }).toList();
      });
    }, onError: (e) {
      print("❌ Firestore listener error: $e");
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
                            Uint8List? imageBytes =
                                diseases[index].getImageBytes();

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
                                padding: EdgeInsets.all(10),
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
                                    imageBytes != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.memory(
                                              imageBytes,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(Icons.image,
                                            size: 50, color: Colors.grey),
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
      ),
    );
  }
}
