import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  bool _isConnected = false;
  List<dynamic> _controlBodys = []; // 🔹 Lista para almacenar los datos en tiempo real
  bool get isConnected => _isConnected;
  List<dynamic> get controlBodys => _controlBodys;
  int _currentPage = 1;
  final int _limit = 20; // Cantidad de elementos por página
  bool _isFetching = false; // Para evitar múltiples llamadas simultáneas
  bool _isRefreshing = false; // Para diferenciar entre actualización y carga de más datos

  SocketService() {
    _connect();
    listenForControlBodys(); // Asegura que el listener se configure en el constructor
  }

  void _connect() {
    _socket = IO.io('http://192.168.30.58:3003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,  // 🔹 Asegura que se conecte automáticamente
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

    // 🔥 Escuchar cuando el servidor envíe datos actualizados
    _socket.on("ControlBodys", (data) {
      print("📩 Datos recibidos del socket: $data"); // Ver si realmente llega

      if (data == null || !data.containsKey('status')) {
        print("❌ Error: Respuesta inesperada del servidor");
        return;
      }

      if (data['status'] == 200) {
        print("✅ Operación completada con éxito");

        // Verificar que los datos existen
        if (data.containsKey('data') && data['data'] != null) {
          final nuevoRegistro = data['data']; // Extrae el nuevo bodycam

          // Importante: Verifica si el registro ya existe en la lista
          bool existeEnLista = false;
          if (nuevoRegistro is Map<String, dynamic> && nuevoRegistro.containsKey('id')) {
            final int nuevoId = nuevoRegistro['id'];
            existeEnLista = _controlBodys.any((item) => item['id'] == nuevoId);
          }

          // Si no existe, añádelo
          if (!existeEnLista && nuevoRegistro is Map<String, dynamic>) {
            _controlBodys.insert(0, nuevoRegistro);
            notifyListeners();
            print("🆕 Registro agregado correctamente. Total: ${_controlBodys.length}");
          }
        } else {
          print("⚠️ No hay datos en la respuesta.");
        }

        // Añade un nuevo registro solo, no recargues toda la lista
        // Esto evita que el scroll vuelva al principio
      } else {
        print("⚠️ Error en la operación: ${data['message'] ?? 'Mensaje desconocido'}");
      }
    });
  }

  // Método para cargar los datos iniciales
  void getAllControlBodys() {
    if (_isConnected && !_isFetching) {
      _isFetching = true; // Evita múltiples llamadas
      _isRefreshing = true; // Marcamos que estamos refrescando

      // Solo resetea la lista si estamos refrescando
      if (_isRefreshing) {
        _controlBodys = [];
        _currentPage = 1;
        notifyListeners(); // Notifica que la lista se ha limpiado
      }

      _socket.emit("getAllControlBodys", {"page": _currentPage, "limit": _limit});
    }
  }

  // Método para cargar más datos (paginación)
  void loadMoreControlBodys() {
    if (_isConnected && !_isFetching) {
      _isFetching = true;
      _isRefreshing = false; // Marcamos que NO estamos refrescando, solo cargando más
      _socket.emit("getAllControlBodys", {"page": _currentPage, "limit": _limit});
    }
  }

  void listenForControlBodys() {
    _socket.on("getAllControlBodysResponse", (response) {
      print("📩 Respuesta recibida: $response");
      _isFetching = false; // Permite nuevas llamadas

      if (response != null && response['status'] == 200) {
        final List<dynamic> controlBodysList = response['data']['data'];

        if (controlBodysList is List && controlBodysList.isNotEmpty) {
          print("📩 Datos recibidos: ${controlBodysList.length}"); // Ver cuántos llega

          // Aquí está el cambio clave: solo agrega los nuevos datos, no reemplaza toda la lista
          _controlBodys.addAll(List<Map<String, dynamic>>.from(controlBodysList)); // Agrega los nuevos datos
          _currentPage++; // Incrementa la página para la próxima llamada
          print("📃 Nuevos elementos añadidos. Total: ${_controlBodys.length}");

          _isRefreshing = false; // Terminamos de refrescar
        } else {
          print("⚠️ Error: 'data.data' no es una lista, sino ${controlBodysList.runtimeType}");
        }

        notifyListeners();

      } else {
        print("⚠️ Error en la respuesta: ${response?['message'] ?? 'Desconocido'}");
      }
    });
  }

  // 🔹 Función para enviar un nuevo registro
  void sendBodyCam(
      List<String> Bodycam,
      String nombre,
      String apellido,
      String jurisdiccion,
      String turno,
      String funcio_cargo,
      int unidad,
      String dni,
      String fecha,
      String hora,
      BuildContext context) {
    if (_isConnected) {
      _socket.emit("createControlBody", {
        "numeros": Bodycam,
        "nombres": nombre,
        "apellidos": apellido,
        "jurisdiccion": jurisdiccion,
        "turno": turno,
        "funcion": funcio_cargo,
        "unidad": unidad,
        "dni": dni,
        "fecha_entrega": fecha,
        "hora_entrega": hora
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("📡 Datos enviados al servidor...")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No conectado al servidor, mensaje no enviado.")),
      );
    }
  }

  void updateReguistro(
      String Bodycam,
      String fecha_entrega,
      String hora_entrega,
      String detalles,
      BuildContext context
      ){
    if(_isConnected){
      _socket.emitWithAck("ActualizarControlBodys", {
        "numero": Bodycam,
        "fecha_devolucion": fecha_entrega,
        "hora_devolucion": hora_entrega,
        "detalles": detalles
      }, ack: (response){
        if(response != null){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("📡 Respuesta del servidor: ${response['message']}")),
          );

          // No recargamos la lista completa, solo actualizamos el registro específico
          _updateSpecificRecord(Bodycam, response['data']);
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

  // Método para actualizar un registro específico en la lista sin recargar todo
  void _updateSpecificRecord(String bodycamNumber, dynamic updatedData) {
    if (updatedData != null) {
      final index = _controlBodys.indexWhere((item) =>
      item['BodyCam'] != null && item['BodyCam']['numero'] == bodycamNumber);

      if (index != -1) {
        _controlBodys[index] = updatedData;
        notifyListeners();
      }
    }
  }

  // Método para refrescar manualmente la lista
  void refreshControlBodys() {
    _controlBodys = [];
    _currentPage = 1;
    _isFetching = false;
    _isRefreshing = true;
    getAllControlBodys();
  }

  void disconnect() {
    _socket.disconnect();
  }
}