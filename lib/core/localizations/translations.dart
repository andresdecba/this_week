import 'package:get/get.dart';
import 'package:todoapp/core/localizations/en_US.dart';
import 'package:todoapp/core/localizations/es_AR.dart';
import 'package:todoapp/core/localizations/pt_BR.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en_US': en_US,
        'es_AR': es_AR,
        'pt_BR': pt_BR,
      };
}
