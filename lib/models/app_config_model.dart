import 'package:hive_flutter/hive_flutter.dart';
part 'app_config_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

/// si o si hay que pasar este modelo por hive, no borrar por que si no da error

@HiveType(typeId: 3)
class AppConfigModel extends HiveObject {
  //
  @HiveField(1)
  String? language;

  @HiveField(2)
  bool createSampleTask;

  @HiveField(3)
  bool isOnboardingDone;

  @HiveField(4)
  bool hasNotificationModalShown;

  AppConfigModel({
    this.language,
    this.createSampleTask = true,
    this.isOnboardingDone = false,
    this.hasNotificationModalShown = false,
  });

  @override
  String toString() {
    return '{ description: $language, sample_task: $createSampleTask, onborarding: $isOnboardingDone, notification: $hasNotificationModalShown }';
  }
}
