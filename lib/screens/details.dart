import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_disease_detector/model/model.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  _DiseaseDetailScreenState createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  String treatmentInfo = "Fetching treatment details..."; // Placeholder text

  @override
  void initState() {
    super.initState();
    fetchTreatmentInfo();
  }

  Uint8List? _decodeImage() {
    try {
      return base64Decode(widget.disease.imageBase64);
    } catch (e) {
      print("Error decoding Base64 image: $e");
      return null;
    }
  }

  Future<void> fetchTreatmentInfo() async {
    try {
      String diseaseName = widget.disease.diseaseName.trim(); // Removes extra spaces

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('diseases') // 🔥 Use correct collection name
          .where("diseaseName", isEqualTo: diseaseName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        print("🔥 Found document: ${doc.data()}");

        setState(() {
          treatmentInfo = doc['additionalInfo'] ?? "No additional details available.";
        });
      } else {
        print("❌ No document found for: '$diseaseName'");
        setState(() {
          treatmentInfo = "No treatment details found.";
        });
      }
    } catch (e) {
      print("🚨 Firestore Error: $e");
      setState(() {
        treatmentInfo = "Error fetching treatment details.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes = _decodeImage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.disease.diseaseName,
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display decoded image or placeholder
              Center(
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(imageBytes,
                            width: 200, height: 200, fit: BoxFit.cover),
                      )
                    : Icon(Icons.image_not_supported,
                        size: 100, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Strawberry",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Disease: ${widget.disease.diseaseName}",
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Date: ${widget.disease.date}",
                style: GoogleFonts.raleway(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                "Time: ${widget.disease.time}",
                style: GoogleFonts.raleway(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              // Treatment Section
              Text(
                "Treatments",
                style: GoogleFonts.raleway(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12), // Adds padding inside the container
                margin: EdgeInsets.symmetric(vertical: 8), // Adds space around the container
                decoration: BoxDecoration(
                  color: Colors.green.shade50, // Light green background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(color: Colors.green, width: 1), // Green border
                ),
                child: Text(
                  treatmentInfo,
                  style: GoogleFonts.raleway(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
