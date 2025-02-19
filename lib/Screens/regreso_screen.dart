import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart'; // Asegúrate de importar el archivo correcto

class RegresoScreen extends StatelessWidget {
  const RegresoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _observacionesController =
        TextEditingController();
    final TextEditingController _bodycamController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Regreso de Bodycam"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Observaciones del regreso:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: _bodycamController,
              labelText: "Bodycam",
              icon: Icons.qr_code,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _observacionesController,
              labelText: "Escribe aquí...",
              icon: Icons.comment,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("Observación: ${_observacionesController.text}");
                },
                child: Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
