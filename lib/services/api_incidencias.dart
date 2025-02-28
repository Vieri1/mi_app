import 'package:dio/dio.dart';

class ApiService2 {
  final Dio _dio = Dio();
  final String apiUrl = "http://incidencias.munisjl.gob.pe/api/serenos/jurisdicciones";

  Future<List<Map<String, dynamic>>> getJurisdicciones() async {
    try {
      print("📡 API URL: $apiUrl");

      final response = await _dio.get(apiUrl);

      print("✅ Respuesta completa de la API: ${response.data}");
      print("📡 Código de estado HTTP: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        if (response.data.containsKey("data") && response.data["data"] is List) {
          List<Map<String, dynamic>> jurisdicciones = List<Map<String, dynamic>>.from(response.data["data"]);
          print("📦 Jurisdicciones recibidas: $jurisdicciones");
          return jurisdicciones;
        }
      }

      print("⚠️ Advertencia: La API respondió correctamente pero sin datos útiles.");
      return [];

    } on DioException catch (e) {
      print("❌ Error en la petición HTTP: ${e.message}");
      return [];
    } catch (e) {
      print("❌ Error inesperado: $e");
      return [];
    }
  }
}
