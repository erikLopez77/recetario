import 'package:flutter/material.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/pantallas/inicio.dart';
import 'package:recetario/pantallas/splash.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  //MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Scaffold(backgroundColor: ColoresApp.primario, body: Splash()),
      home: Inicio(),
    );
  }
}
