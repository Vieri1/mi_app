
import 'package:flutter/material.dart';

class PopupDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> bodycamData; // Recibe el mapa de datos

  const PopupDetailsDialog({super.key, required this.bodycamData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Detalles de la Bodycam",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 250, // Ajusta la altura
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            shrinkWrap: true,
            children: _buildDetails(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetails() {
    return [
      _popupItem("Bodycam", bodycamData["bodyCams"]?["numero"]),
      _popupItem("Responsable", "${bodycamData["Personas"]?["nombres"]} ${bodycamData["Personas"]?["apellidos"]}"),
      _popupItem("Jurisdicción", bodycamData["Jurisdiccions"]?["jurisdiccion"]),
      _popupItem("Turno", bodycamData["horarios"]?["turno"]),
      _popupItem("Unidad", bodycamData["Unidads"]?["numero"]),
      _popupItem("Función", bodycamData["funcions"]?["funcion"]),
      _popupItem("Fecha salida", bodycamData["fecha_entrega"]),
      _popupItem("Hora salida", bodycamData["hora_entrega"]),
      _popupItem("Fecha entrega", bodycamData["fecha_devolucion"] ?? "PENDIENTE"),
      _popupItem("Hora entrega", bodycamData["hora_devolucion"] ?? "PENDIENTE"),
    ];
  }

  Widget _popupItem(String label, dynamic value) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          title: Text(
            "$label: ${value ?? 'No disponible'}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
