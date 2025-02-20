import 'package:flutter/material.dart';
import '../Screens/detalles_screen.dart';

class BodycamCard extends StatelessWidget {
  final Map<String, String> bodycam;

  const BodycamCard({super.key, required this.bodycam});

  @override
  Widget build(BuildContext context) {
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
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
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
  }
}
