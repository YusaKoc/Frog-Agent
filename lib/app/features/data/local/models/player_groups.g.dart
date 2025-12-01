// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_groups.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerGroupAdapter extends TypeAdapter<PlayerGroup> {
  @override
  final int typeId = 10;

  @override
  PlayerGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerGroup(
      id: fields[0] as String,
      name: fields[1] as String,
      players: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.players)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
