// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      description: fields[1] as String,
      dateTime: fields[2] as DateTime,
      notificationDateTime: fields[4] as DateTime?,
      status: fields[3] as String,
      subTasks: (fields[5] as List).cast<SubTask>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.notificationDateTime)
      ..writeByte(5)
      ..write(obj.subTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubTaskAdapter extends TypeAdapter<SubTask> {
  @override
  final int typeId = 1;

  @override
  SubTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubTask(
      title: fields[0] as String,
      isDone: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SubTask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
