// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppConfigModelAdapter extends TypeAdapter<AppConfigModel> {
  @override
  final int typeId = 3;

  @override
  AppConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfigModel(
      language: fields[1] as String?,
      createSampleTask: fields[2] as bool,
      isOnboardingDone: fields[3] as bool,
      hasNotificationModalShown: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfigModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.createSampleTask)
      ..writeByte(3)
      ..write(obj.isOnboardingDone)
      ..writeByte(4)
      ..write(obj.hasNotificationModalShown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
