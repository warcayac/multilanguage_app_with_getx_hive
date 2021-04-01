import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class HomePage extends StatefulWidget {
  /* ---------------------------------------------------------------------------- */
  HomePage({Key? key}) : super(key: key);
  /* ---------------------------------------------------------------------------- */
  @override
  _HomePageState createState() => _HomePageState();
}

/* ============================================================================================= */

class _HomePageState extends State<HomePage> {
  Box<Map<String, String>>? box;
  /* ---------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    openBox();
  }
  /* ---------------------------------------------------------------------------- */
  @override
  void dispose() async {
    await box!.close();
    await Hive.close();
    super.dispose();
  }
  /* ---------------------------------------------------------------------------- */
  void openBox() async => box = await Hive.openBox('langs');
  /* ---------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  const data = {'hello': 'Hello!'};
                  await box!.put('en', data);
                  print('Data saved');
                },
                child: Text('Save map'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var data = await box!.get('en');
                  print('Data recovered: ${data.runtimeType}');
                  print(data);
                }, 
                child: Text('Recover map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
