import 'dart:convert';
import 'dart:typed_data';

class Disease {
  final String imageBase64;
  final String diseaseName;
  final String date;
  final String time;
  

  Disease({
    required this.imageBase64,
    required this.diseaseName,
    required this.date,
    required this.time,
  });

  Uint8List? getImageBytes() {
    if (imageBase64.isNotEmpty) {
      return base64Decode(imageBase64);
    }
    return null;
  }
}
