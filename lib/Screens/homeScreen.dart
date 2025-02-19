import 'package:flutter/material.dart';
import 'registrar_screen.dart';
import 'historial_screen.dart';
import 'regreso_screen.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;

  // Lista de widgets que serán mostrados cuando se seleccione un ícono
  static final List<Widget> _widgetOptions = <Widget>[
    RegistrarScreen(),
    HistorialScreen(),
    RegresoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambiar el índice del ícono seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // Asegúrate de tener la ruta correcta
            width: 300,
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), // Mostrar la pantalla correspondiente
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.schedule_send,
              size: 30.0,
            ),
            label: 'Reguistrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.post_add,
              size: 30.0,
            ),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.keyboard_return,
              size: 30.0,
            ),
            label: 'Regreso',
          ),
        ],
        currentIndex: _selectedIndex, // Índice actual seleccionado
        selectedItemColor: Colors.green,
        unselectedItemColor:
            Colors.blueGrey, // Color cuando un ícono está seleccionado
        onTap: _onItemTapped, // Manejar el tap en los íconos
      ),
    );
  }
}
