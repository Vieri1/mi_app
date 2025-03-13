import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_text_field.dart'; // Asegúrate de importar el archivo correcto
import '../services/sockets_services.dart';
import 'package:provider/provider.dart';

class RegresoScreen extends StatefulWidget {
  const RegresoScreen({super.key});

  @override
  _RegresoScreenState createState() => _RegresoScreenState();
}

class _RegresoScreenState extends State<RegresoScreen> {
  String? fecha_entrega;
  String? hora_entrega;
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _bodycamController = TextEditingController();
  void _sendmodificacion(BuildContext context){
    final socketService = Provider.of<SocketService>(context, listen: false);
    String  bodycam=_bodycamController.text ;
    String detalles=_observacionesController.text;
    if(bodycam.isNotEmpty){
      socketService.updateReguistro(bodycam, fecha_entrega?? "Fecha no disponible", hora_entrega?? "Hora no disponible", detalles, context);
      _bodycamController.clear();
      _observacionesController.clear();
    }
  }
  Future<void> qrScan() async {
    String resultData;
    try {
      resultData = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.QR);

      if (resultData == "-1") {
        // Si el usuario cancela el escaneo
        return;
      }

      // Capturar fecha y hora actuales
      DateTime now = DateTime.now();
      setState(() {
        fecha_entrega = DateFormat('yyyy-MM-dd').format(now);
        hora_entrega = DateFormat('HH:mm:ss').format(now);
        _bodycamController.text = resultData;
      });

      print("📷 Escaneado: $resultData");
      print("📅 Fecha: $fecha_entrega, ⏰ Hora: $hora_entrega");
    } on PlatformException {
      print("⚠️ Error al escanear código QR");
    }
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Regreso de Bodycam"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Observaciones del regreso:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _bodycamController,
              labelText: "Bodycam",
              icon: Icons.qr_code,
              onPressed: qrScan, // Llamamos a la función QRScan
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _observacionesController,
              labelText: "Escribe aquí...",
              icon: Icons.comment,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("Observación: ${_observacionesController.text}");
                  print("📅 Fecha de entrega: $fecha_entrega");
                  print("⏰ Hora de entrega: $hora_entrega");
                  _sendmodificacion(context);
                },
                child: const Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
