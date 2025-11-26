import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/usuario.dart';
import 'package:recetario/clasesHive/hive_service.dart';

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  Usuario? usuario;

    @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  void cargarUsuario() {
    usuario = HiveService.obtenerUsuarioActual();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Mi Perfil")),
        body: const Center(child: Text("Usuario no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),

            const SizedBox(height: 20),

            Text("Nombre:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!.nombre),

            SizedBox(height: 20),

            Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!.email),

            SizedBox(height: 20),

            Text("ID Usuario:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!.id.toString()),

          ],
        ),
      ),
    );
  }
}
