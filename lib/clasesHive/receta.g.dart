// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecetaAdapter extends TypeAdapter<Receta> {
  @override
  final int typeId = 1;

  @override
  Receta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receta(
      id: fields[0] as String,
      titulo: fields[1] as String,
      descripcion: fields[2] as String,
      ingredientes: fields[3] as String,
      pasos: fields[4] as String,
      fechaCreacion: fields[5] as DateTime,
      idUsuario: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Receta obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.descripcion)
      ..writeByte(3)
      ..write(obj.ingredientes)
      ..writeByte(4)
      ..write(obj.pasos)
      ..writeByte(5)
      ..write(obj.fechaCreacion)
      ..writeByte(6)
      ..write(obj.idUsuario);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
