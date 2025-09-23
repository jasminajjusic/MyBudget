// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_limit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryLimitModelAdapter extends TypeAdapter<CategoryLimitModel> {
  @override
  final int typeId = 5;

  @override
  CategoryLimitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryLimitModel(
      category: fields[0] as String,
      limit: fields[1] as double,
      period: fields[2] as String,
      sendNotification: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryLimitModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.limit)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.sendNotification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryLimitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
