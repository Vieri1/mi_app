import 'package:flutter/material.dart';
import 'detalles_screen.dart';

class HistorialScreen extends StatelessWidget {
  HistorialScreen({super.key});

  // Generamos 20 registros de bodycams para que haya desplazamiento
  final List<Map<String, String>> bodycams = List.generate(
      20, (index) => {"id": "BC-${(index + 1).toString().padLeft(3, '0')}"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Bodycams")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: bodycams.length,
        itemBuilder: (context, index) {
          final bodycam = bodycams[index];

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.phone_iphone, size: 40, color: Colors.grey),
              title: Text("ID: ${bodycam["id"]}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesScreen(bodycam: bodycam),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
