import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_disease_detector/model/model.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          disease.diseaseName,
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder (can be replaced with an actual image later)
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 150,
                width: 150,
                child: Text(
                  disease.imagePath, // Text placeholder for image
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Center(child: Text("<PLANT_NAME>")),
            SizedBox(height: 20),
            // Disease Name
            Text(
              "Disease: ${disease.diseaseName}",
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Date and Time
            Text(
              "Date: ${disease.date}",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Time: ${disease.time}",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // Any other details you want to display
            Text(
              "Additional information can go here.",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
