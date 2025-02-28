import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mi_app/widgets/custom_Dropdown_Field.dart';
import '../widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_utils.dart';
import '../services/sockets_services.dart';
import 'package:provider/provider.dart';
import '../services/api_incidencias.dart';
class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  String selectedValue = "";
  String selectedTurno="Mañana";
  final TextEditingController _bodycamController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();
  String? dni;
  String? nombre;
  String? apellido;
  String? funcio_cargo;
  // Variable para almacenar el DNI
  @override
  void initState() {
    super.initState();
    _loadJurisdicciones(); // Cargar las jurisdicciones al iniciar
  }
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);
      final response = await ImageUtils.processAndUploadImage(imageFile);

      print("📡 Tipo de response: ${response.runtimeType}");
      print("📡 Respuesta completa: $response");

      // Verificar que response sea un Map antes de acceder a 'data'
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];

        if (data is Map<String, dynamic>) {
          print("📦 Data recibida: $data");

          // Obtener los valores de nombres y apellidos si existen
           nombre = data['nombres']?.toString() ?? 'Nombre no disponible';
           apellido = data['apellidos']?.toString() ?? '';
          //este DNI PASAR CON POR EL SOCKET?
           dni=data['dni']?.toString() ; // Guardamos el DNI
           funcio_cargo=data['funcion']?.toString();

          print("👤 Nombre: $nombre, Apellido: $apellido, DNI: $dni");

          if (mounted) {
            setState(() {
              _responsableController.text = "$nombre $apellido";
              _cargoController.text="$funcio_cargo";
              print(_cargoController.text);
            });
          }
        } else {
          print("❌ Error: 'data' no es un mapa válido, es: ${data.runtimeType}");
        }
      } else {
        print("❌ Error: La respuesta no contiene datos válidos.");
      }
    }
  }
  List<String> turnos = ["Mañana", "Tarde", "Noche"];
  List<String> jurisdicciones = [];
  Future<void> _loadJurisdicciones() async {
    final apiService = ApiService2();
    final data = await apiService.getJurisdicciones();
    print("aquitoy:$data");
    setState(() {
      jurisdicciones = data.map((e) => e['nombre'].toString()).toList();
      if (jurisdicciones.isNotEmpty) {
        selectedValue = jurisdicciones.first;
      }
    });
  }


  Future<void> QRcan() async {
      String resultData;
      try {
        resultData = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "cancel", true, ScanMode.QR);
        print(resultData);
        setState(() {
          _bodycamController.text = resultData;
        });
      } on PlatformException {
        resultData = "falla p causa";
      }
    }

  void _sendMessage(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    String Bodycam = _bodycamController.text;
    String jurisdiccion = selectedValue;
    String turno=selectedTurno;
    int? unidad = int.tryParse(_unidadController.text);
    String fecha="2024-02-28";
    String hora="08:32";
    if (Bodycam.isNotEmpty && jurisdiccion.isNotEmpty && unidad != null && turno.isNotEmpty) {
      socketService.sendBodyCam(
        Bodycam,
        nombre ?? "Nombre no disponible",
        apellido ?? "Apellido no disponible",
        jurisdiccion,
        turno,
        funcio_cargo ?? "No se halló su función",
        unidad,
        dni ?? "DNI no disponible",
        fecha,
        hora,
        context, // Pasamos el contexto para mostrar el SnackBar
      );

      // Limpiar los campos después de enviar
      _cargoController.clear();
      _bodycamController.clear();
      _responsableController.clear();
      _unidadController.clear();
      dni = null;
      apellido = null;
      nombre = null;
      funcio_cargo = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Registre su bodyCam")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomTextField(
                    controller: _bodycamController,
                    labelText: "Bodycam",
                    icon: Icons.qr_code,
                    onPressed: QRcan,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _responsableController,
                    labelText: "Responsable",
                    icon: Icons.add_a_photo,
                    onPressed: _captureImage,
                  ),
                  SizedBox(height: 20),
                CustomDropdownField(
                  labelText: "Jurisdicción",
                  items: jurisdicciones,
                  selectedValue: selectedValue ?? '',
                  onChanged: (newValue) {
                    setState(() {

                      selectedValue = newValue!;
                    });
                  },
                ),
                  SizedBox(height: 20),
                  CustomDropdownField(
                    labelText: "Turno",
                    items: turnos,
                    selectedValue: selectedTurno ?? (turnos.isNotEmpty ? turnos.first : ''),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTurno = newValue!;
                      });
                    },
                  ),


                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _cargoController,
                          labelText: "Cargo",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: _unidadController,
                          labelText: "Unidad",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    socketService.isConnected ? "🟢 Conectado" : "🔴 Desconectado",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          child: Icon(Icons.add, size: 45, color: Colors.white),
        onPressed: () => _sendMessage(context),

      ),
    );
  }
}
