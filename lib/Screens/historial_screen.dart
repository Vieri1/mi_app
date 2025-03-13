import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sockets_services.dart';
import '../widgets/card_bodycams.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  _HistorialScreenState createState( ) => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final ScrollController _scrollController = ScrollController(); // Controlador del Scroll

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);

    Future.microtask(() {
      socketService.getAllControlBodys();  // Primera carga de datos
    });

    // Agregar listener para detectar el final del scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        // Usar loadMoreControlBodys en lugar de getAllControlBodys
        socketService.loadMoreControlBodys();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Historial de Bodycams")),
      body: socketService.controlBodys.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController, // Agregar el controlador al ListView
        padding: EdgeInsets.all(10),
        itemCount: socketService.controlBodys.length + 1, // +1 para el loader
        itemBuilder: (context, index) {
          if (index == socketService.controlBodys.length) {
            return Center(child: CircularProgressIndicator()); // Loader al final
          }

          final bodycam = socketService.controlBodys[index];
          return BodycamCard(bodycam: bodycam);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Liberar recursos del ScrollController
    super.dispose();
  }
}

