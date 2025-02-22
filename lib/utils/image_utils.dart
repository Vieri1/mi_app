import 'dart:io';
import 'dart:convert';
import '../services/api_tareaje.dart';

class ImageUtils {
  /// Convierte una imagen en Base64 y la sube a la API
  static Future<Map<String, dynamic>> processAndUploadImage(File imageFile) async {
    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());
      print("esta es la iamgen:$base64Image");
      return await ApiService().uploadImage(base64Image);
    } catch (e) {
      return {"success": false, "message": "Error en el proceso: $e"};
    }
  }
}

