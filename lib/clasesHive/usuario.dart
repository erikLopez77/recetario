// user.dart
import 'package:hive/hive.dart';

part 'usuario.g.dart'; // Archivo generado automáticamente

@HiveType(typeId: 0)
class Usuario {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  final String email;

  @HiveField(3)
  String password;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, email: $email, password: $password)';
  }
}
