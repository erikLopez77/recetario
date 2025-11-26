import 'package:flutter/material.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/core/estilos_texto.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:recetario/pantallas/nueva_receta.dart';
import 'package:recetario/pantallas/wave_clipper.dart';
import 'package:recetario/pantallas/login.dart';

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

  void _cerrarSesion() async {
    await HiveService.cerrarSesion();

    // salimos de la funcion si navegamos hacia atrás o si se cerro el widget antes de terminar la promesa.
    if (!mounted) return;

    // context es seguro despues de la verificacion anterior
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }

  Drawer menuLateral(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado del menú (Opcional)
          const DrawerHeader(
            decoration: BoxDecoration(color: ColoresApp.secundario),
            child: Text(
              'Menú Principal',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // Opciones del menú
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi perfil'),
            onTap: () {
              // Acción al presionar y cerrar el menú
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _cerrarSesion();
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_outlined),
            title: const Text('Ayuda y preguntas frecuentes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.primario,
      appBar: AppBar(
        backgroundColor: ColoresApp.secundario,
        iconTheme: const IconThemeData(color: ColoresApp.primario),
      ),
      drawer: menuLateral(context),
      body: Column(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset("assets/fondoR.jpg", fit: BoxFit.fill),
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
                      return Card(
                        elevation: 2, //sombra
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            receta.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            receta.descripcion,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            print("Ver receta: ${receta.titulo}");
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevaReceta()),
          );
          cargarRecetas();
        },
        foregroundColor: ColoresApp.primario,
        backgroundColor: ColoresApp.secundario,
        child: Icon(Icons.add),
      ),
    );
  }
}
