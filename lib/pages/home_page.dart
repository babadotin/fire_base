import 'package:flutter/material.dart';
import 'package:latest_project/pages/add_person_page.dart';
import 'package:latest_project/pages/list_person_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
                  break;
                case 'Option 2':
                  break;
                case 'Option 3':
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Option 1',
                child: Text('Option 1'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: Text('Option 2'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 3',
                child: Text('Option 3'),
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
}
