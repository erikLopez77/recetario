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

  bool mostrarCambioPass = false;

  final TextEditingController nuevaPassCtrl = TextEditingController();
  final TextEditingController confirmarPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  void cargarUsuario() {
    usuario = HiveService.obtenerUsuarioActual();
    setState(() {});
  }

  Future<void> guardarNuevaContrasena() async {
    final nueva = nuevaPassCtrl.text.trim();
    final confirmar = confirmarPassCtrl.text.trim();

    if (nueva.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos los campos son obligatorios")),
      );
      return;
    }

    if (nueva != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    // ACTUALIZA CONTRASEÑA EN HIVE
    final ok = await HiveService.actualizarContrasena(usuario!.id, nueva);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contraseña actualizada correctamente")),
      );

      setState(() {
        mostrarCambioPass = false;
        nuevaPassCtrl.clear();
        confirmarPassCtrl.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar la contraseña")),
      );
    }
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

            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mostrarCambioPass = !mostrarCambioPass;
                  });
                },
                child: Text(mostrarCambioPass
                    ? "Cancelar"
                    : "Cambiar contraseña"),
              ),
            ),

            const SizedBox(height: 20),

            if (mostrarCambioPass) ...[
              TextField(
                controller: nuevaPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Nueva contraseña",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 15),

              TextField(
                controller: confirmarPassCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirmar contraseña",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: guardarNuevaContrasena,
                child: Text("Guardar contraseña"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
