// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_case.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepairCaseAdapter extends TypeAdapter<RepairCase> {
  @override
  final int typeId = 0;

  @override
  RepairCase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepairCase(
      caseId: fields[0] as String,
      customerName: fields[1] as String,
      phone: fields[2] as String,
      droneModel: fields[3] as String,
      serialNumber: fields[4] as String,
      problemDescription: fields[5] as String,
      estimatedCost: fields[6] as double,
      deadline: fields[7] as DateTime?,
      assignedTo: fields[8] as String,
      admittedAt: fields[9] as DateTime,
      photos: (fields[10] as List).cast<String>(),
      isDelivered: fields[11] as bool,
      paymentMethod: fields[12] as String?,
      finalAmount: fields[13] as double?,
      deliveredBy: fields[14] as String?,
      deliveredAt: fields[15] as DateTime?,
      deliveryPartner: fields[16] as String?,
      deliveryToken: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RepairCase obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.caseId)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.droneModel)
      ..writeByte(4)
      ..write(obj.serialNumber)
      ..writeByte(5)
      ..write(obj.problemDescription)
      ..writeByte(6)
      ..write(obj.estimatedCost)
      ..writeByte(7)
      ..write(obj.deadline)
      ..writeByte(8)
      ..write(obj.assignedTo)
      ..writeByte(9)
      ..write(obj.admittedAt)
      ..writeByte(10)
      ..write(obj.photos)
      ..writeByte(11)
      ..write(obj.isDelivered)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.finalAmount)
      ..writeByte(14)
      ..write(obj.deliveredBy)
      ..writeByte(15)
      ..write(obj.deliveredAt)
      ..writeByte(16)
      ..write(obj.deliveryPartner)
      ..writeByte(17)
      ..write(obj.deliveryToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairCaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
