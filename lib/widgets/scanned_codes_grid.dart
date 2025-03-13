import 'package:flutter/material.dart';

class ScannedCodesGrid extends StatelessWidget {
  final List<String> scannedCodes;
  final Function(int) onRemove;

  ScannedCodesGrid({required this.scannedCodes, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return scannedCodes.isEmpty
        ? SizedBox.shrink() // 🔹 Oculta si no hay códigos
        : SizedBox(
      height: (scannedCodes.length / 4).ceil() * 60, // 🔹 Altura ajustada dinámicamente
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        shrinkWrap: true, // 🔹 Ajusta el tamaño según el contenido
        physics: NeverScrollableScrollPhysics(), // 🔹 Desactiva el scroll interno
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemCount: scannedCodes.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  scannedCodes[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => onRemove(index),
                    child: Icon(Icons.close, color: Colors.black, size: 15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
