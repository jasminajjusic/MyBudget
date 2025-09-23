// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repeating_payment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepeatingPaymentAdapter extends TypeAdapter<RepeatingPayment> {
  @override
  final int typeId = 8;

  @override
  RepeatingPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepeatingPayment(
      name: fields[0] as String,
      dateTime: fields[1] as DateTime,
      amount: (fields[2] as double?) ?? 0.0,
      iconKey: (fields[3] as String?) ?? 'default',
    );
  }

  @override
  void write(BinaryWriter writer, RepeatingPayment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.iconKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatingPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
