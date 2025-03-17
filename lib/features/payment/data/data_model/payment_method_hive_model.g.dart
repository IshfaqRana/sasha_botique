// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentMethodHiveModelAdapter
    extends TypeAdapter<PaymentMethodHiveModel> {
  @override
  final int typeId = 2;

  @override
  PaymentMethodHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentMethodHiveModel(
      id: fields[0] as String,
      type: fields[1] as String,
      last4Digits: fields[2] as String,
      cardHolderName: fields[3] as String,
      expiryDate: fields[4] as String,
      country: fields[5] as String,
      isDefault: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentMethodHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.last4Digits)
      ..writeByte(3)
      ..write(obj.cardHolderName)
      ..writeByte(4)
      ..write(obj.expiryDate)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
