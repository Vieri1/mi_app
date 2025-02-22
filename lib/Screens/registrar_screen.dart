import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_utils.dart';
import '../services/sockets_services.dart';

class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  final SocketService socketService = SocketService();
  final TextEditingController _bodycamController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _jurisdiccionController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);
      final response = await ImageUtils.processAndUploadImage(imageFile);

      print("📡 Tipo de response: ${response.runtimeType}");
      print("📡 Respuesta completa: $response");

      // Verificar que response sea un Map antes de acceder a 'data'
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];

        if (data is Map<String, dynamic>) {
          print("📦 Data recibida: $data");

          // Obtener los valores de nombres y apellidos si existen
          String nombre = data['nombres']?.toString() ?? 'Nombre no disponible';
          String apellido = data['apellidos']?.toString() ?? '';

          print("👤 Nombre: $nombre, Apellido: $apellido");

          if (mounted) {
            setState(() {
              _responsableController.text = "$nombre $apellido";
            });
          }
        } else {
          print("❌ Error: 'data' no es un mapa válido, es: ${data.runtimeType}");
        }
      } else {
        print("❌ Error: La respuesta no contiene datos válidos.");
      }
    }
  }



  Future<void> QRcan() async {
      String resultData;
      try {
        resultData = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "cancel", true, ScanMode.QR);
        print(resultData);
        setState(() {
          _bodycamController.text = resultData;
        });
      } on PlatformException {
        resultData = "falla p causa";
      }
    }
  void _sendMessage() {
    String bodycam = _bodycamController.text;
    String responsable=_responsableController.text;
    String jurisdiccion = _jurisdiccionController.text;
    String cargo=_cargoController.text;
    int? unidad = int.tryParse(_unidadController.text);
    if (bodycam.isNotEmpty && responsable.isNotEmpty && jurisdiccion.isNotEmpty && cargo.isNotEmpty && unidad!=null) {
      socketService.sendBodyCam(bodycam,responsable,jurisdiccion,cargo,unidad);
      _cargoController.clear();
      _bodycamController.clear();
      _responsableController.clear();
      _unidadController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("📩 Datos enviados correctamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registre su bodyCam")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _bodycamController,
              labelText: "Bodycam",
              icon: Icons.qr_code,
              onPressed: QRcan,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _responsableController,
              labelText: "Responsable",
              icon: Icons.add_a_photo,
              onPressed: _captureImage,
            ),
            SizedBox(height: 20),
            CustomTextField(
                controller: _jurisdiccionController, labelText: "Jurisdicción"),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _cargoController,
                    labelText: "Cargo",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _unidadController,
                    labelText: "Unidad",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          child: Icon(Icons.add, size: 45, color: Colors.white),
          onPressed: _sendMessage,

      ),
    );
  }
}
