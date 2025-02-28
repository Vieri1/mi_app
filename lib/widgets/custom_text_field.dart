import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'qr_scanner_screen.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final Function()? onPressed;
  final double fontSize;

  // Constructor
  const CustomTextField({super.key, 
    required this.controller,
    required this.labelText,
    this.icon,
    this.onPressed,
    this.fontSize = 16.0, // Tamaño de la fuente, por defecto 16.0
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: fontSize, // Cambiar tamaño de texto
                color: Colors.black, // Color del texto
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green, // Color del borde cuando tiene el foco
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            cursorColor: Colors.black,
          ),
        ),
        if (icon != null)
          IconButton(
            icon: Icon(icon, size: 30),
              onPressed:  onPressed

          ),
      ],
    );
  }
}
