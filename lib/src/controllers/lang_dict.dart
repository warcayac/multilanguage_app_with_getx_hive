import 'dart:convert';
import 'dart:ui';

import 'package:basic_implementation/src/shared/constants.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';


class LangDict extends GetxController {
  final fallbackLocale = Locale('en', 'US');
  var defaultLang = ''.obs;
  var locales = <String, Locale>{}.obs;
  var labels = <String, String>{}.obs;
  var translations = <String, Map<String, String>>{}.obs;
  var currentLang = ''.obs;
  /* ---------------------------------------------------------------------------- */
  Locale get locale => locales[defaultLang.value] ?? fallbackLocale;
  // Map<String, Map<String, String>> get getTx => translations.value;
  /* ---------------------------------------------------------------------------- */
  void refreshData() {
    var box = Hive.box<String>(kLangName);

    defaultLang.value = Hive.box<String>(kDefName).get('language')!;
    locales.clear();
    labels.clear();
    translations.clear();

    var list = box.keys;
    list.forEach((lang) {
      final data = jsonDecode(box.get(lang)!) as Map<String, dynamic>;
      final lc = data['language_code'] as String;
      final cc = (data['country_code'] ?? '') as String;

      locales[lang] = Locale(lc, cc);
      labels[lang] = data['label'];
      var code = lc + (cc != '' ? '_' : '') + cc;
      var tx = (data['translations'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
      translations[code] = tx;
    });
  }
}