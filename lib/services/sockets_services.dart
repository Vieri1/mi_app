import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  SocketService() {
    _connect();
  }

  void _connect() {
    _socket = IO.io('http://192.168.30.56:3006', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,  // Asegurar que se conecte automáticamente
    });

    _socket.onConnect((_) {
      print("✅ Conectado al servidor Socket.IO");
      _isConnected = true;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print("❌ Desconectado del servidor");
      _isConnected = false;
      notifyListeners();
    });

    _socket.on("mensaje", (data) {
      print("📩 Mensaje recibido: $data");
    });
  }

  void sendBodyCam(
      String Bodycam,
      String nombre,
      String apellido,
      String jurisdiccion,
      String turno,
      String funcio_cargo,
      int unidad,
      String dni,
      fecha,
      hora,
      BuildContext context,
      ) {
    if (_isConnected) {
      _socket.emitWithAck("createControlBody", {
        "numero": Bodycam,
        "nombres": nombre,
        "apellidos": apellido,
        "jurisdiccion": jurisdiccion,
        "turno":turno,
        "funcion": funcio_cargo,
        "unidad": unidad,
        "dni": dni,
        "fecha_entrega":fecha,
        "hora_entrega":hora
      }, ack: (response) {
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("📡 Respuesta del servidor: ${response['message']}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("⚠️ No hubo respuesta del servidor")),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No conectado al servidor, mensaje no enviado.")),
      );
    }
  }

  void disconnect() {
    _socket.disconnect();
  }
}

