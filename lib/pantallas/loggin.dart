import 'package:flutter/material.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_text_field.dart';
import 'package:recetario/core/estilos_texto.dart';

//instancias para los estilos
EstilosTextField estilosEmail = EstilosTextField(
  hintText: "ejemplo@correo.com",
  labelText: "E-mail",
  prefixIcon: Icon(Icons.email),
);
EstilosTextField estilosContrasena = EstilosTextField(
  hintText: "Tu contraseña",
  labelText: "Contraseña",
  prefixIcon: Icon(Icons.password),
);

class Loggin extends StatefulWidget {
  const Loggin({super.key});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      body: bodyResultado(),
    );
  }
}

Padding bodyResultado() {
  return Padding(
    padding: EdgeInsets.all(35),
    child: Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Text("Inicio de sesión", style: EstiloTitulo.textoBody),
        TextField(decoration: estilosEmail.estilos),
        TextField(obscureText: true, decoration: estilosContrasena.estilos),
        Spacer(),
      ],
    ),
  );
}
