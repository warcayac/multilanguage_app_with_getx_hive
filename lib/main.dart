import 'package:basic_implementation/services/location_service.dart';
import 'package:basic_implementation/src/pages/language/language_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async {
  await LocationService.initConfig(cleanHive: false);
  runApp(MyApp());
}

/* ============================================================================================= */

class MyApp extends StatelessWidget {
  /* ---------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Multiple Language',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LanguagePage(),
      locale: LocationService.langDict.locale,
      fallbackLocale: LocationService.langDict.fallbackLocale,
      translations: LocationService(),
    );
  }
}
