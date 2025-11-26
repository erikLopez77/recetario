import 'package:flutter/material.dart';

class ShowSnack {
  static void mostrar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: Duration(seconds: 2)),
    );
  }
}
