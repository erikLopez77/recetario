import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_texto.dart';
import 'package:recetario/pantallas/wave_clipper.dart';

class EditarReceta extends StatefulWidget {
  final Receta receta;

  const EditarReceta({super.key, required this.receta});

  @override
  State<EditarReceta> createState() => _EditarRecetaState();
}

class _EditarRecetaState extends State<EditarReceta> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController ingCtrl;
  late TextEditingController pasosCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.receta.titulo);
    descCtrl = TextEditingController(text: widget.receta.descripcion);
    ingCtrl = TextEditingController(text: widget.receta.ingredientes);
    pasosCtrl = TextEditingController(text: widget.receta.pasos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      appBar: AppBar(
        backgroundColor: ColoresApp.secundario,
        iconTheme: const IconThemeData(color: ColoresApp.primario),
        title: const Text("Editar receta", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                  spacing: 25,
                  children: [
                    Text("Editar receta", style: EstiloTitulo.textoBody),

                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Título"),
                      validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                    ),

                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: "Descripción"),
                      validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                    ),

                    TextFormField(
                      controller: ingCtrl,
                      decoration: const InputDecoration(labelText: "Ingredientes"),
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                    ),

                    TextFormField(
                      controller: pasosCtrl,
                      decoration: const InputDecoration(labelText: "Pasos"),
                      maxLines: 5,
                      validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
                    ),

                    Row(
                      children: [
                        // BOTÓN DESCARTAR
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Descartar cambios"),
                                  content: const Text(
                                    "¿Deseas descartar los cambios y dejar la receta como estaba?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Cancelar",
                                          style: TextStyle(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Sí, descartar",
                                          style: TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmar == true) {
                                Navigator.pop(context, false); // vuelve sin guardar
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Descartar"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // BOTÓN GUARDAR
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _guardarCambios,
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.black),
                              foregroundColor: MaterialStatePropertyAll(Colors.white),
                            ),
                            child: const Text("Guardar"),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardarCambios() async {
    if (!formKey.currentState!.validate()) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar cambios"),
        content: const Text("¿Deseas guardar los cambios en esta receta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí, guardar", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final recetaEditada = widget.receta.copyWith(
      titulo: titleCtrl.text,
      descripcion: descCtrl.text,
      ingredientes: ingCtrl.text,
      pasos: pasosCtrl.text,
    );

    final ok = await HiveService.actualizarReceta(recetaEditada);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar la receta")),
      );
    }
  }
}
