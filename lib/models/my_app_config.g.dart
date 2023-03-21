// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_app_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyAppConfigAdapter extends TypeAdapter<MyAppConfig> {
  @override
  final int typeId = 2;

  @override
  MyAppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyAppConfig(
      language: fields[1] as String?,
      createSampleTask: fields[2] as bool,
      isOnboardingDone: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MyAppConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.createSampleTask)
      ..writeByte(3)
      ..write(obj.isOnboardingDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyAppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
