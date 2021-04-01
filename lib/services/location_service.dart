import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_implementation/src/controllers/lang_dict.dart';
import 'package:basic_implementation/src/shared/constants.dart';
import 'package:basic_implementation/src/shared/translations/en_us.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


/* ============================================================================================= */

extension on HiveInterface {
  /// Get a name list of existing boxes
  Future<List<String>> getNamesOfBoxes() async {
    final appDir = await getApplicationDocumentsDirectory();
    var files = appDir.listSync();
    var _list = <String>[];

    files.forEach((file) {
      if (file.statSync().type == FileSystemEntityType.file 
        && p.extension(file.path).toLowerCase() == '.hive') {
        _list.add(p.basenameWithoutExtension(file.path));
      }
    });
    print('Current boxes: $_list');
    return _list;
  }
  /* ---------------------------------------------------------------------------- */
  /// Delete existing boxes from disk
  Future<void> deleteBoxes() async {
    final _boxes = await this.getNamesOfBoxes();
    if (_boxes.isNotEmpty) _boxes.forEach((name) => this.deleteBoxFromDisk(name));
  }
}

/* ============================================================================================= */

class LocationService extends Translations {
  static final langDict = Get.put(LangDict());
  /* ---------------------------------------------------------------------------- */
  static FutureOr<void> _openBoxes() async {
    if (!Hive.isBoxOpen(kDefName)) await Hive.openBox<String>(kDefName);
    if (!Hive.isBoxOpen(kLangName)) await Hive.openBox<String>(kLangName);
  }
  /* ---------------------------------------------------------------------------- */
  static FutureOr<void> initConfig({bool cleanHive = false}) async {
    await Hive.initFlutter();
    
    if (cleanHive) {
      await _setDefaultHiveStructure();
    } else {
      final valid = await isIntegrityOfBoxesOK();
      if (!valid) {
        await _setDefaultHiveStructure();
      }
    }

    await _openBoxes();
    langDict
      ..refreshData()
      ..currentLang.value = langDict.defaultLang.value;
  }
  /* ---------------------------------------------------------------------------- */
  static FutureOr<void> _setDefaultHiveStructure() async {
    await Hive.deleteBoxes();
    var box1 = await Hive.openBox<String>(kDefName);
    var box2 = await Hive.openBox<String>(kLangName);

    box1.put('language', 'english');
    box2.put('english', jsonEncode(kEnglish));
  }
  /* ---------------------------------------------------------------------------- */
  static FutureOr<bool> isIntegrityOfBoxesOK() async {
    var list = await Hive.getNamesOfBoxes();
    var flag = list.isNotEmpty && list.contains(kDefName) && list.contains(kLangName);
    
    if (flag) {
      var box1 = await Hive.openBox<String>(kDefName);
      var box2 = await Hive.openBox<String>(kLangName);
      
      try {
        String? _lang = box1.get('language');
        flag = _lang != null;
        if (flag) {
          final _data = box2.get(_lang);
          flag = _data != null;
        }
      } catch(e) {
        flag = false;
      } finally {
        return flag;
      }
    }
    return false;
  }
  /* ---------------------------------------------------------------------------- */
  static void changeLocale(String lang) {
    final _locale = langDict.locales[lang] ?? Get.locale!;
    Get.updateLocale(_locale);
  }
  /* ---------------------------------------------------------------------------- */
  static FutureOr<void> newLangEntry(String lang, Map<String, dynamic> data) async {
    _openBoxes();
    var box = Hive.box<String>(kLangName);
    if (!box.keys.contains(lang)) box.put(lang, jsonEncode(data));
    langDict.refreshData();
  }
  /* ---------------------------------------------------------------------------- */
  static FutureOr<void> changeDefaultLanguage() async {
    var box = Hive.box<String>(kDefName);
    box.put('language', langDict.currentLang.value);
  }
  /* ---------------------------------------------------------------------------- */
  @override
  Map<String, Map<String, String>> get keys => langDict.translations;
}


/*
const Hive = {
  'defaults': {
    'laguage': 'english',
  },
  'languages': {
    'english': {
      'label': 'English',
      'language_code': 'en',
      'country_code': 'US',
      'translations': {
        'greeting': 'Hi! noob',
      }
    },
  }
};
*/
/*
https://api.flutter.dev/flutter/material/MaterialApp/supportedLocales.html
https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html
https://saimana.com/list-of-country-locale-code/
{
  'chinese': {
    'language_code': 'zh',
    'country_code': 'CN',
    'translations': {
      'greeting': 'Hi! noob',
    },
  }
}
*/