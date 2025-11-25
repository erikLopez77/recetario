import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_texto.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/pantallas/nueva_receta.dart';
import 'package:recetario/pantallas/wave_clipper.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Receta> recetasUsuario = [];

  @override
  void initState() {
    super.initState();
    cargarRecetas();
  }

  void cargarRecetas() {
    List<Receta> recetas = HiveService.obtenerRecetasUsuario();

    setState(() {
      recetasUsuario = recetas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      body: Column(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset("assets/logo1.png", fit: BoxFit.fill),
            ),
          ),

          SizedBox(height: 10),

          Text("Mis recetas", style: EstiloTitulo.textoBody),

          SizedBox(height: 10),

          Expanded(
            child: recetasUsuario.isEmpty
                ? Center(child: Text("No tienes recetas"))
                : ListView.builder(
                    itemCount: recetasUsuario.length,
                    itemBuilder: (context, index) {
                      final receta = recetasUsuario[index];
                      return ListTile(
                        title: Text(receta.titulo),
                        subtitle: Text(receta.descripcion),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevaReceta()),
          );
        },
        foregroundColor: ColoresApp.primario,
        backgroundColor: ColoresApp.secundario,
        child: Icon(Icons.add),
      ),
    );
  }
}
