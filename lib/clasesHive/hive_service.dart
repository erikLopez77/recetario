import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recetario/clasesHive/receta.dart';
import 'package:recetario/clasesHive/usuario.dart';

class HiveService {
  static final String _usuarioActualKey = 'usuarioActualId';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    //registrar adaptadores
    Hive.registerAdapter(UsuarioAdapter());
    Hive.registerAdapter(RecetaAdapter());
    //abrir boxes
    await Hive.openBox<Usuario>('usuarios');
    await Hive.openBox<Receta>('recetas');
    await Hive.openBox('configuracion');
  }

  //usuarios
  static Usuario? obtenerUsuarioPorEmail(String email) {
    final userBox = Hive.box<Usuario>('usuarios');

    for (final usuario in userBox.values) {
      if (usuario.email == email) {
        return usuario;
      }
    }
    return null;
  }

  static Future<void> guardarUsuario(Usuario usuario) async {
    final userBox = Hive.box<Usuario>('usuarios');
    await userBox.put(usuario.id, usuario);
  }

  static Future<bool> verificarCredenciales(
    String email,
    String contrasena,
  ) async {
    print(email+"email de paraametro");
    print(contrasena+"contrasena de paraametro");
    final userBox = Hive.box<Usuario>('usuarios');

    for (final usuario in userBox.values) { 
      print(usuario.email+"email ");
    print(usuario.password+"contrasena ");
      if (usuario.email == email && usuario.password == contrasena) {
        return true;
      }
    }
    return false;
  }

  // sesiones
  static Future<void> iniciarSesion(Usuario usuario) async {
    final configBox = Hive.box('configuracion');
    configBox.put(_usuarioActualKey, usuario.id);
  }

  static Future<void> cerrarSesion() async {
    final configBox = Hive.box('configuracion');
    configBox.delete(_usuarioActualKey);
  }

  static Usuario? obtenerUsuarioActual() {
    final configBox = Hive.box('configuracion');
    final userBox = Hive.box<Usuario>('usuarios');
    //obtenemos el valor asociado a la clave
    final usuarioActualId = configBox.get(_usuarioActualKey);
    if (usuarioActualId != null) {
      return userBox.get(usuarioActualId);
    }
    return null;
  }

  //recetas
  static Future<void> guardarReceta(Receta receta) async {
    final recipeBox = Hive.box<Receta>('recetas');
    await recipeBox.put(receta.id, receta);
  }

  static List<Receta> obtenerRecetasUsuario() {
    final recipeBox = Hive.box<Receta>('recetas');
    final usuarioActual = obtenerUsuarioActual();

    if (usuarioActual == null) return [];

    return recipeBox.values
        .where((receta) => receta.idUsuario == usuarioActual.id)
        .toList();
  }

  static Future<void> eliminarReceta(String id) async {
    final recipeBox = Hive.box<Receta>('recetas');

    for (final receta in recipeBox.values) {
      if (receta.id == id) {
        recipeBox.delete(receta.id);
      }
    }
  }

  //Cambiar contraseñaa
  static Future<bool> actualizarContrasena(String userId, String nuevaContrasena) async {
    try {
      final userBox = Hive.box<Usuario>('usuarios');
      Usuario? usuario = userBox.get(userId);
      if (usuario == null) return false;

      usuario.password = nuevaContrasena; 
      await userBox.put(userId, usuario); 

      return true;
    } catch (e) {
      print("Error actualizando contraseña: $e");
      return false;
    }
  }

  static Future<bool> actualizarNombre(String id, String nuevoNombre) async {
    final box = await Hive.openBox<Usuario>('usuarios');
    final usuario = box.get(id);

    if (usuario == null) return false;

    usuario.nombre = nuevoNombre;
    await box.put(id, usuario);
    return true;
  }

}
