import 'package:hive_flutter/hive_flutter.dart';
part 'my_app_config.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// flutter packages pub run build_runner build

@HiveType(typeId: 2)
class MyAppConfig extends HiveObject {
  //
  @HiveField(1)
  String? language;

  MyAppConfig({
    this.language,
  });

  @override
  String toString() {
    return '{ description: $language }';
  }
}
