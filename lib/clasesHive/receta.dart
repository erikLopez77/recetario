import 'package:hive/hive.dart';

part 'receta.g.dart';

@HiveType(typeId: 1)
class Receta {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final String descripcion;

  @HiveField(3)
  final String ingredientes;

  @HiveField(4)
  final String pasos;

  @HiveField(5)
  final DateTime fechaCreacion;

  @HiveField(6)
  final String idUsuario;
  Receta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.ingredientes,
    required this.pasos,
    required this.fechaCreacion,
    required this.idUsuario,
  });

  @override
  String toString() {
    return 'Receta(id: $id, titulo: $titulo, usuario: $idUsuario)';
  }
}
