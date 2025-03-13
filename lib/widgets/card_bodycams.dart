


import 'package:flutter/material.dart';
import '../widgets/pop_up.dart';

class BodycamCard extends StatelessWidget {
  final Map<String, dynamic> bodycam; // Cambio de tipo a dynamic

  const BodycamCard({super.key, required this.bodycam});

  void _showPopupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDetailsDialog(bodycamData: bodycam);
      },
    );
  }

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
          title: Text("Body: ${bodycam["bodyCams"]["numero"]}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          _showPopupDialog(context);
        },
      ),
    );
  }
}
