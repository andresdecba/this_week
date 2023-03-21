import 'package:hive_flutter/hive_flutter.dart';
part 'my_app_config.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 2)
class MyAppConfig extends HiveObject {
  //
  @HiveField(1)
  String? language;

  @HiveField(2)
  bool createSampleTask;

  @HiveField(3)
  bool isOnboardingDone;

  MyAppConfig({
    this.language,
    this.createSampleTask = true,
    this.isOnboardingDone = false,
  });

  @override
  String toString() {
    return '{ description: $language, sample task: $createSampleTask }';
  }
}
