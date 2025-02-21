import 'package:dio/dio.dart'; // Para manejar solicitudes HTTP
import 'dart:convert'; // Para convertir imágenes a Base64
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ApiService {
  final Dio _dio = Dio();
  final String apiUrl = dotenv.env['APITAREAJE']?? ''; // Reemplaza con tu URL real
  final String apiKey = dotenv.env['APIKEY']?? ''; // Reemplaza con tu clave real

  Future<Map<String, dynamic>> uploadImage(String base64Image) async {
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey, // Si tu API no usa API Key, puedes quitar esto
        }),
        data: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {"success": false, "message": "Error en la API"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}