import 'dart:convert';
import 'dart:io';

class ImageUtils {
  static Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes(); // Leer los bytes de la imagen
    return base64Encode(imageBytes); // Convertir a Base64
  }
}
