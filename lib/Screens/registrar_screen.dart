import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_utils.dart';


class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  final TextEditingController _bodycamController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _jurisdiccionController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();

  File? _imageFile; // Para almacenar la imagen seleccionada
  String? _base64Image; // Para almacenar la imagen en Base64

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);
      List<int> imageBytes = await imageFile.readAsBytes(); // Leer bytes de la imagen
      String base64Image = base64Encode(imageBytes); // Convertir a Base64
      await saveBase64ToFile(base64Image);
    }

  }
  Future<void> saveBase64ToFile(String base64Image) async {
    final file = File('/storage/emulated/0/Download/base64.txt'); // Carpeta de Descargas
    await file.writeAsString(base64Image);
    print("✅ Base64 guardado en: ${file.path}");
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

  void _capturarDatos() {
    final Map<String, String> datos = {
      "bodycam": _bodycamController.text,
      "responsable": _responsableController.text,
      "jurisdiccion": _jurisdiccionController.text,
      "jurisdiccion": _jurisdiccionController.text,
      "cargo": _cargoController.text,
      "unidad": _unidadController.text,
    };

    print("Datos capturados: $datos");
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
          onPressed: _capturarDatos,

      ),
    );
  }
}
