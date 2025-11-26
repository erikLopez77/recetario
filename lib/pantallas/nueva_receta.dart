import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/clasesHive/usuario.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_texto.dart';
import 'package:recetario/core/estilos_text_field.dart';
import 'package:uuid/uuid.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/pantallas/wave_clipper.dart';

class NuevaReceta extends StatefulWidget {
  const NuevaReceta({super.key});

  @override
  State<NuevaReceta> createState() => _NuevaRecetaState();
}

class _NuevaRecetaState extends State<NuevaReceta> {
  //clave para identificar el formulario
  final formK = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();

  final estilosTitulo = EstilosTextField(
    hintText: "El nombre de tu platillo",
    labelText: "Titulo",
  );
  final estilosDescripcion = EstilosTextField(
    hintText: "Describe el platillo o haz un comentario",
    labelText: "Descripción",
  );
  final estilosIngredientes = EstilosTextField(
    hintText: "Ej. 1/4 de tomate, 2 dientes de ajos, 1 cebolla fileteada...",
    labelText: "Ingredientes",
    maxLines: 2,
  );
  final estilosPasos = EstilosTextField(
    hintText:
        "Ej. 1. En una licuadora muele el tomate, el ajo y la cebolla \n 2. Poner a freir la carne para después agregar la salsa ...",
    labelText: "Pasos",
    maxLines: 4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColoresApp.primario,
      appBar: AppBar(
        backgroundColor: ColoresApp.secundario,
        iconTheme: const IconThemeData(color: ColoresApp.primario),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formK,
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
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  spacing: 25,
                  children: [
                    Text("Nueva receta", style: EstiloTitulo.textoBody),
                    TextFormField(
                      controller: titleController,
                      decoration: estilosTitulo.estilos,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un titulo';
                        }
                        return null;
                      },
                    ),
                    //SizedBox(height: 18),
                    TextFormField(
                      controller: descriptionController,
                      decoration: estilosDescripcion.estilos,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripcion';
                        }
                        return null;
                      },
                    ),
                    //SizedBox(height: 18),
                    TextFormField(
                      controller: ingredientsController,
                      decoration: estilosIngredientes.estilos,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa los ingredientes';
                        }
                        return null;
                      },
                    ),
                    //SizedBox(height: 18),
                    TextFormField(
                      controller: stepsController,
                      decoration: estilosPasos.estilos,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa los ingredientes';
                        }
                        return null;
                      },
                    ),
                    //SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            // Pasamos la referencia sin ejecutar
                            onPressed: () => _crearReceta(),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            child: Text("Guardar receta"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _crearReceta() async {
    if (formK.currentState!.validate()) {
      try {
        Usuario? usuario = HiveService.obtenerUsuarioActual();
        if (usuario != null) {
          //crear receta
          Receta receta = Receta(
            id: Uuid().v4(),
            titulo: titleController.text,
            descripcion: descriptionController.text,
            ingredientes: ingredientsController.text,
            pasos: stepsController.text,
            fechaCreacion: DateTime.now(),
            idUsuario: usuario.id,
          );
          //guardar datos
          await HiveService.guardarReceta(receta);
        }
        if (!mounted) return;

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;

        Navigator.pop(context);
        print("ERROR EN LOGIN: $e");
      }
    }
  }
}
