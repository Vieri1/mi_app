import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mi_app/widgets/custom_Dropdown_Field.dart';
import '../widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_utils.dart';
import '../services/sockets_services.dart';
import 'package:provider/provider.dart';
import '../services/api_incidencias.dart';
import 'package:intl/intl.dart';
import '../widgets/scanned_codes_grid.dart';
class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  List<String> scannedCodes = [];
  String selectedValue = "";
  String selectedTurno="MAÑANA";
  final TextEditingController _bodycamController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();
  String? dni;
  String? nombre;
  String? apellido;
  String? funcio_cargo;
  String? fecha_entrega;
  String? hora_entrega;
  final ScrollController _scrollController = ScrollController(); // 🔹 Controlador para hacer scroll

  // Variable para almacenar el DNI
  @override
  void initState() {
    super.initState();
    _loadJurisdicciones(); // Cargar las jurisdicciones al iniciar
  }
  //capta una imagen y la pone en base 64
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
  List<String> turnos = ["MAÑANA", "TARDE", "NOCHE"];
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



  void _sendMessage(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    String jurisdiccion = selectedValue;
    String turno=selectedTurno;
    int? unidad = int.tryParse(_unidadController.text);

    if (scannedCodes.isNotEmpty && jurisdiccion.isNotEmpty && unidad != null && turno.isNotEmpty) {
      socketService.sendBodyCam(
        scannedCodes,
        nombre ?? "Nombre no disponible",
        apellido ?? "Apellido no disponible",
        jurisdiccion,
        turno,
        funcio_cargo ?? "No se halló su función",
        unidad,
        dni ?? "DNI no disponible",
        fecha_entrega ?? "Fecha no disponible",
        hora_entrega ?? "Hora no disponible",
        context, // Pasamos el contexto para mostrar el SnackBar
      );

      // Limpiar los campos después de enviar
      setState(() {
        scannedCodes.clear();
        _cargoController.clear();
        _bodycamController.clear();
        _responsableController.clear();
        _unidadController.clear();
        dni = null;
        apellido = null;
        nombre = null;
        funcio_cargo = null;
      });
    }
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancelar",
      true,
      ScanMode.QR,
    );
    DateTime now = DateTime.now();
    fecha_entrega = DateFormat('yyyy-MM-dd').format(now);
    hora_entrega = DateFormat('HH:mm:ss').format(now);

    print("Escaneados: $scannedCodes");
    print("Fecha: $fecha_entrega, Hora: $hora_entrega");
    if (barcodeScanRes != "-1") {
      setState(() {
        if (!scannedCodes.contains(barcodeScanRes)) {
          scannedCodes.add(barcodeScanRes);
        }
      });

      // 🔹 Desplazar hacia abajo después de agregar un nuevo código
      Future.delayed(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

    }
  }
  void removeCode(int index) {
    setState(() {
      scannedCodes.removeAt(index);
      print('SE ELIMINIMO ESTE ES EL NUMERO ARRAY$scannedCodes');
    });
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
                  IconButton(
                    icon: Icon(Icons.qr_code, color: Colors.green, size: 30), // 🔹 Ícono de información
                    onPressed:scanBarcode, // 🔹 Función que se ejecutará al presionar el ícono
                  ),
                  ScannedCodesGrid(scannedCodes: scannedCodes, onRemove: removeCode),

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
