// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'siswa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiswaAdapter extends TypeAdapter<Siswa> {
  @override
  final int typeId = 0;

  @override
  Siswa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Siswa(
      fields[1] as String,
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Siswa obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.judul)
      ..writeByte(1)
      ..write(obj.desc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiswaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
