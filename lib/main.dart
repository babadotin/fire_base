import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latest_project/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Firestore CRUD',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
