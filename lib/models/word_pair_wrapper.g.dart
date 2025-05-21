// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_pair_wrapper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordPairWrapperAdapter extends TypeAdapter<WordPairWrapper> {
  @override
  final int typeId = 0;

  @override
  WordPairWrapper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordPairWrapper(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordPairWrapper obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.first)
      ..writeByte(1)
      ..write(obj.second);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordPairWrapperAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
