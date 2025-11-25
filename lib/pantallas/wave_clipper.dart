//extiende de clase abstracta CustomClipper que define el area de recorte de un widget hijo
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  //esquina superior izqda. 0,0, esquina superior derecha 1,0
  //esquina inferior izqda. 1,0, esquina inferior derecha 1,1
  //sobreescribimos para definir el objeto Path que define la forma deseada
  @override
  Path getClip(Size size) {
    //la clase path se usa para describir una secuencia de curvas conectadas
    var path = Path();

    // Iniciar en la esquina superior izquierda
    path.lineTo(0, size.height * 0.8);

    // primer ola
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.9);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    //segunda ola
    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.7);
    var secondEndPoint = Offset(size.width, size.height * 0.85);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Completar el rectángulo
    path.lineTo(size.width, 0); //esquina superior derecha
    path.lineTo(0, 0); //esquina superior izqda
    path.close();

    return path;
  }

  @override
  //es false porque no se vuelve a calcular las propiedades
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
