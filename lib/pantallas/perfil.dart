import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/usuario.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/pantallas/wave_clipper.dart';

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  Usuario? usuario;

  bool mostrarCambioPass = false;
  bool editarNombre = false;

  final TextEditingController nuevaPassCtrl = TextEditingController();
  final TextEditingController confirmarPassCtrl = TextEditingController();
  final TextEditingController nombreCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  void cargarUsuario() {
    usuario = HiveService.obtenerUsuarioActual();
    if (usuario != null) {
      nombreCtrl.text = usuario!.nombre;
    }
    setState(() {});
  }

  Future<void> actualizarNombre() async {
    final nuevoNombre = nombreCtrl.text.trim();

    if (nuevoNombre.isEmpty || nuevoNombre.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El nombre debe tener mínimo 5 caracteres")),
      );
      return;
    }

    final ok = await HiveService.actualizarNombre(usuario!.id, nuevoNombre);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nombre actualizado correctamente")),
      );

      setState(() {
        editarNombre = false;
        cargarUsuario();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar el nombre")),
      );
    }
  }

  Future<void> guardarNuevaContrasena() async {
    final nueva = nuevaPassCtrl.text.trim();

    final ok = await HiveService.actualizarContrasena(usuario!.id, nueva);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña actualizada correctamente")),
      );

      setState(() {
        mostrarCambioPass = false;
        nuevaPassCtrl.clear();
        confirmarPassCtrl.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar la contraseña")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Mi Perfil"),
      backgroundColor: ColoresApp.secundario,
      foregroundColor: ColoresApp.primario,
    );

    if (usuario == null) {
      return Scaffold(
        appBar: appBar,
        body: const Center(child: Text("Usuario no encontrado")),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset("assets/fondoR.jpg", fit: BoxFit.fill),
              ),
            ),
            Padding(
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

                  // Nombre
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Nombre:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          editarNombre ? Icons.close : Icons.edit,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            editarNombre = !editarNombre;
                          });
                        },
                      ),
                    ],
                  ),
                  if (!editarNombre)
                    Text(usuario!.nombre)
                  else
                    Column(
                      children: [
                        TextField(
                          controller: nombreCtrl,
                          decoration: const InputDecoration(
                            labelText: "Editar nombre",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (nombreCtrl.text.trim().length < 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("El nombre debe tener mínimo 5 caracteres")),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirmar cambio"),
                                content: const Text("¿Actualizar el nombre?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancelar"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("Sí, actualizar"),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await actualizarNombre();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Actualizar"),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),

                  // Email
                  const Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(usuario!.email),
                  const SizedBox(height: 30),

                  // Cambiar contraseña
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          mostrarCambioPass = !mostrarCambioPass;
                        });
                      },
                      child: Text(
                        mostrarCambioPass ? "Cancelar" : "Cambiar contraseña",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (mostrarCambioPass)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nuevaPassCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Nueva contraseña",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                              if (value.length < 8) {
                                return "La contraseña debe tener mínimo 8 caracteres";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: confirmarPassCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Confirmar contraseña",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                              if (value != nuevaPassCtrl.text) {
                                return "Las contraseñas no coinciden";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirmar cambio"),
                                  content: const Text("¿Deseas actualizar tu contraseña?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await guardarNuevaContrasena();
                                      },
                                      child: const Text(
                                        "Sí, actualizar",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text("Guardar contraseña"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
