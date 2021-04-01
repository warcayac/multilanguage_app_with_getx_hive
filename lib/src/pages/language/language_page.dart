import 'package:basic_implementation/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wnetworking/wnetworking.dart';

class LangsUrls {
  static const _base = 'https://gist.githubusercontent.com/warcayac';
  static const chinese = '$_base/d7f71fd6751ffdfdd02d1ba940c5a4c9/raw/0b2c90c4b8d30d7759d847ba23587747df7a3833/chinese.json';
  static const korean = '$_base/47c914dad1b48beb918fdd3b3140d101/raw/c809785c4893fee847d5a93d445b839367d4d8db/korean.json';
  static const spanish = '$_base/fffbea6c4fa6da9e98843c7d40f8b9b0/raw/c5a80d7134679d0d1e740f01c72d959b3712d7f3/spanish.json';
}

class LanguagePage extends StatelessWidget {
  /* ---------------------------------------------------------------------------- */
  const LanguagePage({Key? key}) : super(key: key);
  /* ---------------------------------------------------------------------------- */
  void _installLanguageFrom(BuildContext context, String url) async {
    final sb1 = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Text('The application needs to be restarted', style: TextStyle(fontSize: 16)),
        ],
      ),
      backgroundColor: Colors.red[600],
      duration: Duration(seconds: 2),
    );
    final sb2 = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_download_outlined, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Text('Installing language...', style: TextStyle(fontSize: 16)),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );

    await Future.wait([
      Future.delayed(
        Duration(milliseconds: 100), () => ScaffoldMessenger.of(context).showSnackBar(sb2)
      ),
      HttpReqService
        .getJson<Map<String, dynamic>>(url)
        .then((response) {
          if (response != null) {
            final name = response['name'] as String;
            final data = response['data'] as Map<String, dynamic>;
            LocationService.newLangEntry(name, data);
          }
        })
    ]);
    ScaffoldMessenger.of(context).showSnackBar(sb1);
  }
  /* ---------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My International Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            Text('greeting'.tr, style: TextStyle(fontSize: 30, color: Colors.amberAccent[700])),
            SizedBox(height: 100),
            Obx(() => DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              value: LocationService.langDict.currentLang.value,
              items: LocationService.langDict.labels.entries.map((me) => DropdownMenuItem(
                value: me.key,
                child: Text(me.value),
              )).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  LocationService.langDict.currentLang.value = value;
                  LocationService.changeLocale(value);
                }
              },
            )),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => LocationService.changeDefaultLanguage(),
              child: Text('Set default language', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent[100],
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available languages to install:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => _installLanguageFrom(context, LangsUrls.chinese), 
                        child: Text('Chinese'),
                      ),
                      TextButton(
                        onPressed: () => _installLanguageFrom(context, LangsUrls.korean), 
                        child: Text('Korean'),
                      ),
                      TextButton(
                        onPressed: () => _installLanguageFrom(context, LangsUrls.spanish), 
                        child: Text('Spanish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
