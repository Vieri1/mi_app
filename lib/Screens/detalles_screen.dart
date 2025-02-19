import 'package:flutter/material.dart';

class DetallesScreen extends StatelessWidget {
  final Map<String, String> bodycam;

  const DetallesScreen({super.key, required this.bodycam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalles de la Bodycam")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${bodycam["id"]}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Responsable: ${bodycam["responsable"]}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Fecha de registro: ${bodycam["fecha"]}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
