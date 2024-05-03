import 'package:flutter/material.dart';
import 'package:fire_base/pages/add_person_page.dart';
import 'package:fire_base/pages/list_person_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late SharedPreferences _preferences;
  late Box<String> _hiveBox;

  @override
  void initState() {
    super.initState();
    _initHive();
    _initSharedPreferences();
  }

  Future<void> _initHive() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _hiveBox = await Hive.openBox<String>('myBox');
  }

  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Contact List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Option 1':
                  _saveToSharedPreferences('Option 1');
                  break;
                // case 'Option 2':
                // _addToHiveBox('Option 2');
                // break;
                case 'Option 3':
                  _readFromSharedPreferences();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Option 1',
                child: Text('Save "Option 1" to Shared Preferences'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: Text('Add "Option 2" to Hive Box'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 3',
                child: Text('Read from Shared Preferences'),
              ),
            ],
          ),
        ],
      ),
      drawer: const Drawer(),
      body: const ListpersonPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPersonPage(),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  // void _addToHiveBox(String value) {
  //   _hiveBox.add(value);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Added "$value" to Hive Box'),
  //     ),
  //   );
  // }

  void _saveToSharedPreferences(String value) {
    _preferences.setString('key', value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "$value" to Shared Preferences'),
      ),
    );
  }

  void _readFromSharedPreferences() {
    final value = _preferences.getString('key');
    if (value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Value from Shared Preferences: $value'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No value found in Shared Preferences'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _hiveBox.close();
    super.dispose();
  }
}
