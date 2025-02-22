import 'package:dio/dio.dart'; // Para manejar solicitudes HTTP
import 'dart:convert'; // Para convertir imágenes a Base64
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ApiService {
  final Dio _dio = Dio();
  final String apiUrl ="https://backendtareaje.munisjl.gob.pe/axxon/face" ; // Reemplaza con tu URL real
  final String apiKey = "972cbc17838710f8179133d624ed3c4646034b2bcbbea6dfe5da154fd4f046a6"; // Reemplaza con tu clave real

  /*Future<Map<String, dynamic>> uploadImage(String base64Image) async {
    try {
      print("🚀 Enviando petición a la API...");
      print("📡 API URL: $apiUrl");
      print("🔑 API KEY: $apiKey");

      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
        ),
        data: jsonEncode({"foto": base64Image}),
      );

      print("✅ Respuesta completa de la API: ${response.data}");
      print("📡 Código de estado HTTP: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // Verificar si el campo "data" existe y contiene información útil
          if (response.data.containsKey("data") && response.data["data"] != null) {
            print("📦 Datos válidos recibidos: ${response.data['data']}");
            return response.data;
          } else {
            print("⚠️ Advertencia: La API respondió correctamente pero sin datos útiles.");
            return {
              "success": false,
              "message": "La API no devolvió información válida.",
            };
          }
        } else {
          return {
            "success": false,
            "message": "Formato de respuesta incorrecto.",
          };
        }
      } else {
        print("❌ Error en la API. Código HTTP: ${response.statusCode}");
        return {
          "success": false,
          "message": "Error en la API. Código: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      print("❌ DioException atrapada: ${e.message}");
      print("📡 Código de estado: ${e.response?.statusCode}");
      print("📜 Respuesta de la API: ${e.response?.data}");

      return {
        "success": false,
        "message": "Error en la petición HTTP: ${e.message}",
        "status_code": e.response?.statusCode,
        "api_response": e.response?.data,
      };
    } catch (e) {
      print("⚠️ Error inesperado: $e");

      return {
        "success": false,
        "message": "Error inesperado: $e",
      };
    }
  }*/
  Future<Map<String, dynamic>> uploadImage(String base64Image) async {
    try {
      print("🚀 Enviando petición a la API...");
      print("📡 API URL: $apiUrl");

      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
        ),
        data: jsonEncode({"foto": base64Image}),
      );

      print("✅ Respuesta completa de la API: ${response.data}");
      print("📡 Código de estado HTTP: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // Verificar si el campo "data" existe y contiene información útil
          if (response.data.containsKey("data") && response.data["data"] != null) {
            print("📦 Datos válidos recibidos: ${response.data['data']}");
            return response.data;
          } else {
            print("⚠️ Advertencia: La API respondió correctamente pero sin datos útiles.");
            return {
              "success": false,
              "message": "La API no devolvió información válida.",
            };
          }
        } else {
          return {
            "success": false,
            "message": "Formato de respuesta incorrecto.",
          };
        }
      } else {
        return {
          "success": false,
          "message": "Error en la API. Código: ${response.statusCode}",
          "api_response": response.data,
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "message": "Error en la petición HTTP: ${e.message}",
        "status_code": e.response?.statusCode,
        "api_response": e.response?.data,
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Error inesperado: $e",
      };
    }
  }

}