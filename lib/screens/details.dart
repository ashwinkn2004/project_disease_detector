import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
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
    fetchTreatmentInfo(); // Fetch treatment details when the screen loads
  }

  // Function to decode Base64 image
  Uint8List? _decodeImage() {
    try {
      return base64Decode(widget.disease.imageBase64);
    } catch (e) {
      print("Error decoding Base64 image: $e");
      return null;
    }
  }

  // Function to fetch treatment info from Firebase
  Future<void> fetchTreatmentInfo() async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('diseases')
        .doc(widget.disease.diseaseName)
        .get();

    if (doc.exists) {
      print("🔥 Document Data: ${doc.data()}"); // Debugging line

      setState(() {
        treatmentInfo = doc['additionalInfo'] ?? "No treatment information available.";
      });
    } else {
      print("❌ No document found for: ${widget.disease.diseaseName}");
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
              'asset/logo.png', // Ensure this path is correct
              height: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            // Disease Name
            Text(
              "Disease: ${widget.disease.diseaseName}",
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Date and Time
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
            Text(
              treatmentInfo, // Display fetched treatment information
              style: GoogleFonts.raleway(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
