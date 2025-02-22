import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io('http://192.168.30.56:3006', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Conectado al servidor Socket.IO");
      socket.emit("register", "UsuarioFlutter");
    });

    socket.onDisconnect((_) => print("❌ Desconectado del servidor"));

    socket.on("mensaje", (data) {
      print("📩 Mensaje recibido: $data");
    });
  }

  void sendBodyCam(String bodycam, String responsable, String jurisdiccion, String cargo, int unidad) {
    socket.emit("Regristrobody", {
      "bodycam": bodycam,
      "responsable": responsable,
      "jurisdiccion": jurisdiccion,
      "cargo": cargo,
      "unidad": unidad
    });
  }
  void disconnect() {
    socket.disconnect();
  }
}
