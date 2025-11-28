import 'package:hive/hive.dart';

part 'receta.g.dart';

@HiveType(typeId: 1)
class Receta {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String descripcion;

  @HiveField(3)
  String ingredientes;

  @HiveField(4)
  String pasos;

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

Receta copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? ingredientes,
    String? pasos,
    DateTime? fechaCreacion,
    String? idUsuario,
  }) {
    return Receta(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      ingredientes: ingredientes ?? this.ingredientes,
      pasos: pasos ?? this.pasos,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      idUsuario: idUsuario ?? this.idUsuario,
    );
  }
  
  @override
  String toString() {
    return 'Receta(id: $id, titulo: $titulo, usuario: $idUsuario)';
  }
}
