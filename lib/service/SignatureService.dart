import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SignatureService {
  final String baseUrl = "http://0.0.0.0:8080/api/Order";

  Future<bool> uploadSignature(Uint8List signatureData, int orderId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$orderId/signature'),
      );

      request.files.add(await http.MultipartFile.fromBytes(
        'signature',
        signatureData,
        filename: 'signature.png',
        contentType: MediaType('image', 'png'),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Signature uploaded successfully');
        return true;
      } else {
        print('Failed to upload signature: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}
