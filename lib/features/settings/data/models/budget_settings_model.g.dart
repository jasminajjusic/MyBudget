// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetSettingsModelAdapter extends TypeAdapter<BudgetSettingsModel> {
  @override
  final int typeId = 1;

  @override
  BudgetSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetSettingsModel(
      totalBudget: fields[0] as double,
      categories: (fields[1] as List?)?.cast<String>(),
    ).._limits = (fields[2] as List?)?.cast<CategoryLimitModel>();
  }

  @override
  void write(BinaryWriter writer, BudgetSettingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalBudget)
      ..writeByte(1)
      ..write(obj.categories)
      ..writeByte(2)
      ..write(obj._limits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
