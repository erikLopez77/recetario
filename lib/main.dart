import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/clasesHive/usuario.dart';
import 'package:recetario/core/colores_app.dart';
import 'package:recetario/pantallas/splash.dart';
import 'package:recetario/clasesHive/hive_service.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init(); // Solo esta línea
  await MainApp.iniciarSemilla();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor: ColoresApp.primario, body: Splash()),
      //home: Inicio(),
    );
  }

  static Future<void> iniciarSemilla() async {
    final Uuid uuid = Uuid();

    final userBox = Hive.box<Usuario>('usuarios');
    final recipeBox = Hive.box<Receta>('recetas');
    if (userBox.isEmpty) {
      final usuariosSemilla = [
        Usuario(
          id: '1',
          nombre: 'Erik Lopez',
          email: "correo@gmail.com",
          password: "1234",
        ),
        Usuario(
          id: '2',
          nombre: 'Montse Cirne',
          email: "montse123@correo.com",
          password: "contraseña",
        ),
      ];

      for (final usuario in usuariosSemilla) {
        await userBox.put(usuario.id, usuario);
      }
    }

    if (recipeBox.isEmpty) {
      final recetasSemillas = [
        Receta(
          id: uuid.v4(),
          titulo: "Bistec a la mexicana",
          descripcion:
              "Un platillo que en algún momento nos puede salvar la vida, gracias a su facilidad y rapidez.",
          ingredientes:
              "Aceite vegetal, 1/2 cebolla fileteada, 500gr de bistec cortado en fajitas, 4 jitomates cortados en cubos, 2 chiles cortados en cubos, 1/2 taza de agua, 1 1/2 cubos desmoronados de caldo de pollo con tomate.",
          pasos:
              "1. Calienta dos cucharadas de aceite en una sartén, fríe la cebolla hasta que esté transparente. Añadir el bistec, los jitomates, los chiles y cocina hasta que cambien de color.\n2. Agregar el agua, los cubos de caldo desmoronados, y mezclar hasta disolver por completo.\n3. Cocinar hasta hervir y servir en el momento.",
          fechaCreacion: DateTime.now(),
          idUsuario: '1',
        ),
        Receta(
          id: uuid.v4(),
          titulo: "Sopa de fideo cambray",
          descripcion:
              "Esa sopa casera que te reinicia la vida, perfecta para días fríos o si llegas a estar delicado de salud.",
          ingredientes:
              "1 paquete de fideo cambray, 3 jitomates, 1/4 de cebolla, 1 diente de ajo, 2 litros de caldo de pollo (o agua), aceite vegetal, sal al gusto.",
          pasos:
              "1. Licúa los jitomates, la cebolla y el ajo con un chorrito de agua hasta tener una salsa.\n2. En una olla caliente con aceite, fríe el fideo moviendo constantemente hasta que tome un color dorado uniforme (¡cuidado que no se queme!).\n3. Vierte la salsa colada sobre el fideo, deja sazonar unos minutos y agrega el caldo. Cocina a fuego medio hasta que la pasta esté suave.",
          fechaCreacion: DateTime.now(),
          idUsuario: '1',
        ),
        Receta(
          id: uuid.v4(),
          titulo: "Huevos divorciados",
          descripcion:
              "El desayuno de campeones, todos alguna vez tenemos que cocinarlo para iniciar bien uestro día.",
          ingredientes:
              "2 huevos, 2 tortillas de maíz, salsa roja caliente, salsa verde caliente, frijoles refritos negros, aceite, queso fresco desmoronado.",
          pasos:
              "1. Pasa ligeramente las tortillas por aceite caliente para suavizarlas sin que se pongan duras.\n2. Fríe los huevos estrellados al término que más te guste.\n3. Coloca cada huevo sobre una tortilla. Baña la tortilla con salsa verde y el otro con  salsa roja. Sirve los frijoles en medio para 'separarlos' y decora con queso.",
          fechaCreacion: DateTime.now(),
          idUsuario: '1',
        ),
        Receta(
          id: uuid.v4(),
          titulo: "Espaguetti con jamón",
          descripcion:
              "Un platillo al que nadie se puede negar, visto muy a menudo como guarnición.",
          ingredientes:
              "200g de espagueti, 200ml de media crema, 150g de jamón de pavo en cuadros, 1 cucharada de mantequilla, sal, pimienta y perejil picado.",
          pasos:
              "1. Cuece la pasta en agua hirviendo con sal hasta que esté 'al dente' y escúrrela.\n2. En una sartén amplia, derrite la mantequilla y sofríe el jamón un par de minutos para que suelte sabor.\n3. Baja el fuego, agrega la media crema y salpimienta. Cuando empiece a burbujear suavemente, integra la pasta y mezcla bien. Sirve con perejil encima.",
          fechaCreacion: DateTime.now(),
          idUsuario: '1',
        ),
        Receta(
          id: uuid.v4(),
          titulo: "Guacamole",
          descripcion:
              "El rey de las botanas. Ideal para ver el fútbol o alguna reunión familiar.",
          ingredientes:
              "3 aguacates maduros, 1/2 cebolla blanca picada fina, 1 jitomate picado, cilantro fresco, jugo de 1 limón, sal y totopos.",
          pasos:
              "1. Parte los aguacates, retira el hueso y saca la pulpa en un tazón. Machácalos con un tenedor de preferencia para lograr una buena textura.\n2. Agrega la cebolla, el jitomate y el cilantro picados.\n3. Exprime el limón, pon sal al gusto y mezcla todo suavemente. Acompaña con totopos recién hechos.",
          fechaCreacion: DateTime.now(),
          idUsuario: '2',
        ),
        Receta(
          id: uuid.v4(),
          titulo: "Ensalada César con pollo",
          descripcion:
              "Una opción fresca y ligera cuando quieres comer sano pero sin quedarte con hambre.",
          ingredientes:
              "1 pechuga de pollo aplanada, 1 lechuga orejona lavada y desinfectada, crotones de pan, queso parmesano rallado, aderezo césar, aceite de oliva.",
          pasos:
              "1. Sazona la pechuga de pollo con sal y pimienta, y ásala a la plancha hasta que esté doradita. Córtala en tiras.\n2. Trocea la lechuga con las manos (para que no se oxide) y ponla en un tazón grande.\n3. Agrega el aderezo y mezcla bien para cubrir las hojas. Sirve en el plato y decora encima con las tiras de pollo, los crotones y bastante queso parmesano.",
          fechaCreacion: DateTime.now(),
          idUsuario: '2',
        ),
      ];
      for (final receta in recetasSemillas) {
        await recipeBox.put(receta.id, receta);
      }
    }
  }

  /*void debugHive() {
    print("===== DEBUG HIVE =====");

    try {
      final usuarios = Hive.box<Usuario>('usuarios');
      final recetas = Hive.box<Receta>('recetas');

      print("\n--- Usuarios ---");
      print(usuarios.toMap().toString());

      print("\n--- Recetas ---");
      print(recetas.toMap().toString());

      print("=========================");
    } catch (e) {
      print("Error al leer Hive: $e");
    }
  }*/
}
