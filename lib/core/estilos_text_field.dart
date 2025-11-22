import 'package:flutter/material.dart';

class EstilosTextField {
  String? hintText, labelText;
  final Widget? prefixIcon;
  //{} opcionales por defecto, no importa el orden para instanciar
  EstilosTextField({this.hintText, this.labelText, this.prefixIcon});

  InputDecoration get estilos {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,

      //COLORES Y ESTILOS DE TEXTO
      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      prefixIcon: prefixIcon,
      //BORDER BÁSICO
      border: OutlineInputBorder(), // Borde rectangular estándar
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black, // Color cuando está habilitado
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black, // Color cuando tiene focus
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
