// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[7] as String,
      description: fields[1] as String,
      date: fields[2] as DateTime,
      status: fields[3] as String,
      subTasks: (fields[4] as List).cast<SubTaskModel>(),
      repeatId: fields[5] as String?,
      notificationData: fields[6] as NotificationModel?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.subTasks)
      ..writeByte(5)
      ..write(obj.repeatId)
      ..writeByte(6)
      ..write(obj.notificationData)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
