/*import 'package:flutter/material.dart';
import 'Screens/homeScreen.dart';
import 'services/sockets_services.dart'; // Asegúrate de importar tu servicio de sockets

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SocketService socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.connect(); // Conectar al iniciar la app
  }

  @override
  void dispose() {
    socketService.disconnect(); // Desconectar cuando la app se cierre
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/homeScreen.dart';
import 'services/sockets_services.dart'; // Importar el servicio

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(),
    );
  }
}
