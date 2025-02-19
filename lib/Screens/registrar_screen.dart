import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';



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


  void _captureImage() async {
    final ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera);
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
        onPressed: () {
          print("Agregar nuevo registro");
        },
      ),
    );
  }
}
