import 'package:flutter/material.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_text_field.dart';
import 'package:recetario/core/estilos_texto.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/pantallas/inicio.dart';

class Loggin extends StatefulWidget {
  const Loggin({super.key});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  //clave para identificar el formulario
  final formkey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //instancias para los estilos
  final estilosEmail = EstilosTextField(
    hintText: "ejemplo@correo.com",
    labelText: "E-mail",
    prefixIcon: Icon(Icons.email),
  );

  final estilosContrasena = EstilosTextField(
    hintText: "Tu contraseña",
    labelText: "Contraseña",
    prefixIcon: Icon(Icons.password),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      body: Padding(
        padding: EdgeInsets.all(35),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Spacer(),
              Text("Inicio de sesión", style: EstiloTitulo.textoBody),
              SizedBox(height: 18),
              TextFormField(
                controller: emailController,
                decoration: estilosEmail.estilos,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu email';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 18),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: estilosContrasena.estilos,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  if (value.length < 4) {
                    return 'La contraseña debe tener al menos 4 caracteres';
                  }
                  return null;
                },
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // Pasamos la referencia sin ejecutar
                      onPressed: () => _enviarFormulario(),
                      child: Text("Iniciar sesión"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método correcto
  void _enviarFormulario() async {
    print("VALIDANDO FORM...");

    if (formkey.currentState!.validate()) {
      print("FORM OK, MOSTRANDO LOADING");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        print("VERIFICANDO CREDENCIALES...");

        final credencialesValidas = await HiveService.verificarCredenciales(
          emailController.text,
          passwordController.text,
        );

        print("RESULTADO CREDENCIALES: $credencialesValidas");

        if (!mounted) return;

        Navigator.pop(context);

        if (credencialesValidas) {
          print("CREDENCIALES CORRECTAS");

          final usuario = HiveService.obtenerUsuarioPorEmail(
            emailController.text,
          );

          print("USUARIO OBTENIDO: $usuario");

          if (usuario != null) {
            print("INICIANDO SESIÓN...");
            await HiveService.iniciarSesion(usuario);

            if (!mounted) return;

            print("NAVEGANDO A INICIO...");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Inicio()),
            );
          } else {
            print("ERROR: USUARIO NULL");
          }
        } else {
          print("CREDENCIALES INCORRECTAS");
        }
      } catch (e) {
        if (!mounted) return;

        Navigator.pop(context);
        print("ERROR EN LOGIN: $e");
      }
    }
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando el widget se destruya
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
