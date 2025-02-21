import 'package:flutter/material.dart';
import 'detalles_screen.dart';
import '../widgets/card_bodycams.dart';

class HistorialScreen extends StatelessWidget {
  HistorialScreen({super.key});

  // Generamos 20 registros de bodycams para que haya desplazamiento
  final List<Map<String, String>> bodycams = List.generate(
      2, (index) => {"id": "BC-${(index + 1).toString().padLeft(3, '0')}"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Bodycams")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: bodycams.length,
        itemBuilder: (context, index) {
          final bodycam = bodycams[index];
          return BodycamCard(bodycam: bodycam);
        },
      ),
    );
  }
}
